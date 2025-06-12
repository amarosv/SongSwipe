import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/providers.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Vista para mostrar los artistas favoritos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavGenresView extends ConsumerStatefulWidget {
  const FavGenresView({super.key});

  @override
  ConsumerState<FavGenresView> createState() => _FavGenresViewState();
}

class _FavGenresViewState extends ConsumerState<FavGenresView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el límite de géneros a traer
  final int _limit = 25;

  // Variable que almacena el próximo enlace
  String _nextUrl = '';

  // Variable que almacena la lista con todos los géneros
  late List<Genre> _allGenres = [];

  // Variable que almacena la lista con los ids de los géneros
  late List<int> _allGenresIDs = [];

  // Variable que indica si se están cargando más géneros
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _getAllGenres();
    _fetchGenres();
  }

  void _getAllGenres() async {
    _allGenresIDs = await getFavoriteGenres(uid: _uid);
    setState(() {
      
    });
  }

  // Función que obtiene los géneros
  void _fetchGenres({bool reset = false}) async {
    if (!_isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        setState(() => _isLoadingMore = true);

        if (reset) {
          _allGenres.clear();
          _nextUrl = '';
        }

        final data = await getFavoriteGenresByUser(
            uid: _uid, limit: _limit, url: _nextUrl);

        if (!mounted) {
          return;
        }

        setState(() {
          _allGenres.addAll(data.genres);
          _nextUrl = data.linkNextPage;
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    ref.listen<int>(genresChangedProvider, (prev, next) {
      if (mounted && prev != next) {
        _fetchGenres(reset: true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.my_artists.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => context.push('/search-genres'),
              child: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: _allGenres.isEmpty
          ? Center(child: CircularProgressIndicator())
          : FadeInLeft(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _isLoadingMore
                    ? _allGenres.length + 1
                    : _allGenres.length,
                itemBuilder: (context, index) {
                  Widget result;

                  if (index == _allGenres.length) {
                    result = const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Genre genre = _allGenres[index];

                    if (index == _allGenres.length - 1 &&
                        _nextUrl.isNotEmpty) {
                      _fetchGenres();
                    }

                    result = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FadeInLeft(
                        child: Column(
                          children: [
                            Dismissible(
                              key: Key(genre.id.toString()),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              confirmDismiss: (_) async {
                                bool confirm = true;
                    
                                // Debe tener un mínimo de 3 géneros
                                if (_allGenresIDs.length <= 3) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(capitalizeFirstLetter(text: localization.must_have_genres)),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                    
                                  confirm = false;
                                }
                                return confirm;
                              },
                              onDismissed: (_) async {
                                await deleteGenreFromFavorites(uid: _uid, idGenre: genre.id);
                                setState(() {
                                  _allGenresIDs.removeWhere((item) => item == genre.id);
                                  _allGenres.removeAt(index);
                                });
                              },
                              child: ListTile(
                                leading: CustomRoundedImageWidget(path: genre.picture, height: 128,),
                                title: Text(genre.name),
                              ),
                            ),
                            if (index < _allGenres.length - 1)
                              Divider(
                                color: Theme.of(context).colorScheme.primary,
                              )
                          ],
                        ),
                      ),
                    );
                  }

                  return result;
                },
              ),
            ),
    );
  }
}
