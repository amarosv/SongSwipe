import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';
import 'package:toastification/toastification.dart';

/// Vista de la pantalla completar perfil simple <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CompleteProfileSimpleView extends StatefulWidget {
  /// Proveedor (Apple o Google)
  final String supplier;
  const CompleteProfileSimpleView({super.key, required this.supplier});

  @override
  State<CompleteProfileSimpleView> createState() =>
      _CompleteProfileSimpleViewState();
}

class _CompleteProfileSimpleViewState extends State<CompleteProfileSimpleView> {
  // Controllers de los TextField
  late TextEditingController _usernameController;

  bool _usernameRequired = false;
  bool _activatedButton = false;

  bool _usernameExists = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Inicializamos el controller
    _usernameController = TextEditingController();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    // Destruimos el controller
    _usernameController.dispose();
    super.dispose();
  }

  // Función que se llama cuando el username ha cambiado
  void _onUsernameChanged() {
    _debounce?.cancel();

    // Variable que almacena si el nombre de usuario no contiene espacios ni caracteres especiales
    bool isValid = false;

    // Forzamos minúsculas en tiempo real
    final currentText = _usernameController.text;
    final lowerText = currentText.toLowerCase();
    if (currentText != lowerText) {
      _usernameController.value = _usernameController.value.copyWith(
        text: lowerText,
        selection: TextSelection.collapsed(offset: lowerText.length),
      );
      return; // evitamos duplicar acciones mientras se sincroniza el texto
    }

    // Validar caracteres permitidos
    isValid = RegExp(r'^[a-z0-9_]*$').hasMatch(lowerText);

    // Quitamos el alert
    setState(() {
      _usernameRequired = false;
    });

    // Primero comprobamos que el username no esté vacío, sea de al menos 4 caracteres y no contenga
    // espacios ni caracteres especiales
    if (lowerText.isNotEmpty && lowerText.length >= 4 && isValid) {
      _debounce = Timer(const Duration(milliseconds: 700), () async {
        _usernameExists = await checkIfUsernameExists(_usernameController.text);
        setState(() {
          if (!_usernameExists) {
            checkIfButtonIsActived();
          } else {
            setState(() {
              _activatedButton = false;
            });
          }
        });
      });
    } else {
      setState(() {});
    }
  }

  /// Función que comprueba que los campos requeridos estén rellenos
  /// y activa el botón para continuar
  void checkIfButtonIsActived() {
    if (_usernameController.text.isNotEmpty) {
      setState(() {
        _activatedButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localization.select_your_username.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CustomTextField para el username
            CustomTextfield(
              title: capitalizeFirstLetter(text: localization.username),
              padding: EdgeInsets.symmetric(horizontal: 20),
              placeholder: capitalizeFirstLetter(
                  text: localization.username_placeholder),
              textEditingController: _usernameController,
              icon: _usernameRequired
                  ? Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : _usernameController.text.isNotEmpty &&
                          _usernameController.text.length >= 4
                      ? _usernameExists
                          ? Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                      : null,
            ),

            // Texto informativo para el username
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child:
                  Text(capitalizeFirstLetter(text: localization.username_info)),
            ),

            const SizedBox(height: 20,),

            // Button para continuar
            CustomButton(
                backgroundColor:
                    _activatedButton ? Color(0xFFFF9E16) : Colors.grey,
                onPressed: _activatedButton
                    ? () async {
                        User user = FirebaseAuth.instance.currentUser!;
                        String username = _usernameController.text;

                        // Primero comprueba que estén los campos rellenos
                        if (username.isNotEmpty) {
                          // Registramos al usuario en la base de datos
                          bool registered = await registerUserInDatabase(
                              name: user.displayName!,
                              lastName: ' ',
                              username: username,
                              supplier: widget.supplier);

                          // Si se ha registrado correctamente, vamos a la siguiente pantalla
                          if (registered) {
                            context.go('/select-artists');
                          }
                        } else {
                          // Mostramos la notificación
                          toastification.show(
                            type: ToastificationType.error,
                            context: context,
                            style: ToastificationStyle.flatColored,
                            title: Text(capitalizeFirstLetter(
                                text: localization.attention)),
                            description: RichText(
                                text: TextSpan(
                                    text: capitalizeFirstLetter(
                                        text: localization.fill_fields),
                                    style: TextStyle(color: Colors.black))),
                            autoCloseDuration: const Duration(seconds: 3),
                          );

                          setState(() {
                            if (username.isEmpty) {
                              _usernameRequired = true;
                            }
                          });
                        }
                      }
                    : () {},
                text: localization.continue_s)
          ],
        ),
      ),
    );
  }
}
