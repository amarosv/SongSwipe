import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/custom_last_swipes_widget%20copy.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para ver las stats del usuario <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena los últimos 5 swipes del usuario
  late List<Track> _lastSwipes = List.empty();

  // Variable que almacena los 10 artistas con más likes del usuario
  late List<Artist> _artistsLiked = List.empty();

  // Variable que almacena los 10 artistas con más dislikes del usuario
  late List<Artist> _artistsDisliked = List.empty();

  // Variable que almacena los 10 artistas con más swipes del usuario
  late List<Artist> _artistsSwiped = List.empty();

  // Variable que almacena los 10 artistas con más likes del usuario
  late List<Album> _albumsLiked = List.empty();

  // Variable que almacena los 10 artistas con más dislikes del usuario
  late List<Album> _albumsDisliked = List.empty();

  // Variable que almacena los 10 artistas con más swipes del usuario
  late List<Album> _albumsSwiped = List.empty();

  // Variable que almacena el número total de likes del usuario
  late int _likes = 0;

  // Variable que almacena el número total de dislikes del usuario
  late int _dislikes = 0;

  // Variable que almacena el número total de swipes del usuario
  late int _swipes = 0;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
    _loadData();
  }

  // Función que carga las estadísticas del usuario
  void _loadData() async {
    if (!mounted) return;

    try {
      final results = await Future.wait([
        getLast5Swipes(uid: _uid),
        getTopLikedArtistsByUser(uid: _uid),
        getTopDislikedArtistsByUser(uid: _uid),
        getTopSwipedArtistsByUser(uid: _uid),
        getTopLikedAlbumsByUser(uid: _uid),
        getTopDislikedAlbumsByUser(uid: _uid),
        getTopSwipedAlbumsByUser(uid: _uid),
        getLikedTracksIds(uid: _uid),
        getDislikedTracksIds(uid: _uid),
        getSwipedTracksIds(uid: _uid)
      ]);

      setState(() {
        _lastSwipes = results[0] as List<Track>;
        _artistsLiked = results[1] as List<Artist>;
        _artistsDisliked = results[2] as List<Artist>;
        _artistsSwiped = results[3] as List<Artist>;
        _albumsLiked = results[4] as List<Album>;
        _albumsDisliked = results[5] as List<Album>;
        _albumsSwiped = results[6] as List<Album>;
        List<dynamic> likes = results[7] as List<dynamic>;
        _likes = likes.length;
        List<dynamic> dislikes = results[8] as List<dynamic>;
        _dislikes = dislikes.length;
        List<dynamic> swipes = results[9] as List<dynamic>;
        _swipes = swipes.length;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.my_stats.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              // Stats de deslizamientos
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  capitalizeFirstLetter(text: localization.swipes),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              CustomStatsWidget(
                stats:
                    Stats(likes: _likes, dislikes: _dislikes, swipes: _swipes),
              ),

              // Últimos 5 Swipes
              _lastSwipes.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.last_swipes),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomLastSwipesWidget(tracks: _lastSwipes),
                      ],
                    )
                  : Container(),

              // Artista con más likes
              _artistsLiked.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_liked_artists),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomArtistsWidget(
                          artists: _artistsLiked,
                          text: 'likes',
                        )
                      ],
                    )
                  : Container(),

              // Artista con más dislikes
              _artistsDisliked.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_disliked_artists),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomArtistsWidget(
                          artists: _artistsDisliked,
                          text: 'dislikes',
                        )
                      ],
                    )
                  : Container(),

              // Artista con más swipes
              _artistsSwiped.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_swiped_artists),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomArtistsWidget(
                          artists: _artistsSwiped,
                          text: 'swipes',
                        )
                      ],
                    )
                  : Container(),

              // Albumes con más likes
              _albumsLiked.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_liked_albums),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomAlbumsWidget(
                          albums: _albumsLiked,
                          text: 'likes',
                        )
                      ],
                    )
                  : Container(),

              // Albumes con más dislikes
              _albumsDisliked.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_disliked_albums),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomAlbumsWidget(
                          albums: _albumsLiked,
                          text: 'dislikes',
                        )
                      ],
                    )
                  : Container(),

              // Albumes con más swipes
              _albumsSwiped.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(
                                text: localization.top_swiped_albums),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomAlbumsWidget(
                          albums: _albumsLiked,
                          text: 'swipes',
                        )
                      ],
                    )
                  : Container(),

              const SizedBox(height: 20),

              CustomAdvertisimentWidget(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
