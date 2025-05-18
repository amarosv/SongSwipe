import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/custom_search_widget.dart';
import 'package:songswipe/presentation/widgets/custom_user_widget.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para la pantalla de búsqueda de amigos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final User _user = FirebaseAuth.instance.currentUser!;

  late String _uid;

  // Controller del TextField
  late TextEditingController _searchController;

  Timer? _debounce;

  // Lista que almacena los usuarios encontrados
  List<UserApp> users = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _searchController = TextEditingController();
    _searchController.addListener(_onUsernameChanged);
  }

  // Función que se llama cuando el username ha cambiado
  void _onUsernameChanged() {
    _debounce?.cancel();

    // Forzamos minúsculas en tiempo real
    final currentText = _searchController.text;
    final lowerText = currentText.toLowerCase();
    if (currentText != lowerText) {
      _searchController.value = _searchController.value.copyWith(
        text: lowerText,
        selection: TextSelection.collapsed(offset: lowerText.length),
      );
      return; // evitamos duplicar acciones mientras se sincroniza el texto
    }

    // Primero comprobamos que el username no esté vacío y sea de al menos 4 caracteres
    if (lowerText.isNotEmpty && lowerText.length >= 4) {
      _debounce = Timer(const Duration(milliseconds: 700), () async {
        final newUsers = await getUsersByUsername(username: _searchController.text);

        // Eliminamos al usuario principal si aparece en la lista
        newUsers.removeWhere((u) => u.uid == _uid);

        // Eliminar usuarios no presentes en newUsers
        for (int i = users.length - 1; i >= 0; i--) {
          if (!newUsers.any((u) => u.uid == users[i].uid)) {
            final removedUser = users.removeAt(i);
            _listKey.currentState?.removeItem(
              i,
              (context, animation) => FadeOutRight(
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: CustomUserWidget(user: removedUser),
                ),
              ),
            );
          }
        }

        // Añadir nuevos usuarios que no estaban
        for (var newUser in newUsers) {
          if (!users.any((u) => u.uid == newUser.uid)) {
            users.insert(0, newUser);
            _listKey.currentState?.insertItem(0);
          }
        }
      });
    } else {
      for (int i = users.length - 1; i >= 0; i--) {
        final removedUser = users.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => FadeOutRight(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: CustomUserWidget(user: removedUser),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            CustomSearch(
                placeholder:
                    capitalizeFirstLetter(text: localization.search_friend),
                suffixIcon: Icon(Icons.search),
                textEditingController: _searchController),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: users.length,
                itemBuilder: (context, index, animation) {
                  return FadeInLeft(
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: GestureDetector(
                        onTap: () => context.push('/user?uid=${users[index].uid}'),
                        child: CustomUserWidget(user: users[index])),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
