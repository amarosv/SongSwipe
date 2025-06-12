import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/artist.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Vista para mostrar los artistas favoritos <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavArtistsView extends StatefulWidget {
  const FavArtistsView({super.key});

  @override
  State<FavArtistsView> createState() => _FavArtistsViewState();
}

class _FavArtistsViewState extends State<FavArtistsView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena el límite de artistas a traer
  final int _limit = 25;

  // Variable que almacena el próximo enlace
  String _nextUrl = '';

  // Variable que almacena la lista con todos los artistas
  late List<Artist> _allArtists = [];

  // Variable que almacena la lista con los ids de los artistas
  late List<int> _allArtistsIDs = [];

  // Variable que indica si se están cargando más artistas
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _getAllArtists();
    _fetchArtists();
  }

  void _getAllArtists() async {
    _allArtistsIDs = await getFavoriteArtists(uid: _uid);
    setState(() {
      
    });
  }

  // Función que obtiene los artistas
  void _fetchArtists() async {
    if (!_isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        setState(() => _isLoadingMore = true);

        final data = await getFavoriteArtistsByUser(
            uid: _uid, limit: _limit, url: _nextUrl);

        if (!mounted) {
          return;
        }

        setState(() {
          _allArtists.addAll(data.artists);
          _nextUrl = data.linkNextPage;
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.my_artists.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _allArtists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : FadeInLeft(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _isLoadingMore
                    ? _allArtists.length + 1
                    : _allArtists.length,
                itemBuilder: (context, index) {
                  Widget result;

                  if (index == _allArtists.length) {
                    result = const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    Artist artist = _allArtists[index];

                    if (index == _allArtists.length - 1 &&
                        _nextUrl.isNotEmpty) {
                      _fetchArtists();
                    }

                    result = InkWell(
                      onTap: () => context.push('/artist?id=${artist.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FadeInLeft(
                          child: Column(
                            children: [
                              Dismissible(
                                key: Key(artist.id.toString()),
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(right: 20),
                                  color: Colors.red,
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (_) async {
                                  bool confirm = true;
                      
                                  // Debe tener un mínimo de 5 artistas
                                  if (_allArtistsIDs.length <= 5) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(capitalizeFirstLetter(text: localization.must_have_artists)),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                      
                                    confirm = false;
                                  }
                                  return confirm;
                                },
                                onDismissed: (_) {
                                  setState(() {
                                    _allArtistsIDs.removeWhere((item) => item == artist.id);
                                    _allArtists.removeAt(index);
                                  });
                                },
                                child: ListTile(
                                  leading: CustomRoundedImageWidget(path: artist.picture, height: 128,),
                                  title: Text(artist.name),
                                  subtitle: Text('${humanReadbleNumber(artist.nbFans)} fans'),
                                ),
                              ),
                              if (index < _allArtists.length - 1)
                                Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                )
                            ],
                          ),
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
