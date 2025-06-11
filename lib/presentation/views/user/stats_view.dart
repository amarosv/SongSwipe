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
  /// UID del usuario
  final String uid;

  const StatsView({super.key, required this.uid});

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

  // Variable que almacena si se están cargando los datos
  bool _loading = true;

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
      // Primer grupo
      final result1 = await Future.wait([
        getLast5Swipes(uid: widget.uid),
        getLikedTracksIds(uid: widget.uid),
        getDislikedTracksIds(uid: widget.uid),
        getSwipedTracksIds(uid: widget.uid),
      ]);

      await Future.delayed(Duration(milliseconds: 500));

      // Segundo grupo
      final result2 = await Future.wait([
        getTopLikedArtistsByUser(uid: widget.uid),
        getTopDislikedArtistsByUser(uid: widget.uid),
        getTopSwipedArtistsByUser(uid: widget.uid),
      ]);

      await Future.delayed(Duration(milliseconds: 500));

      // Tercer grupo
      final result3 = await Future.wait([
        getTopLikedAlbumsByUser(uid: widget.uid),
        getTopDislikedAlbumsByUser(uid: widget.uid),
        getTopSwipedAlbumsByUser(uid: widget.uid),
      ]);

      setState(() {
        _lastSwipes = result1[0] as List<Track>;
        List<dynamic> likes = result1[1] as List<dynamic>;
        _likes = likes.length;
        List<dynamic> dislikes = result1[2] as List<dynamic>;
        _dislikes = dislikes.length;
        List<dynamic> swipes = result1[3] as List<dynamic>;
        _swipes = swipes.length;

        _artistsLiked = result2[0];
        _artistsDisliked = result2[1];
        _artistsSwiped = result2[2];

        _albumsLiked = result3[0];
        _albumsDisliked = result3[1];
        _albumsSwiped = result3[2];

        _loading = false;
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
          _uid == widget.uid
            ? localization.my_stats.toUpperCase()
            : localization.their_stats.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
        ? Center(child: CircularProgressIndicator(),)
        : SingleChildScrollView(
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
                                text: _uid == widget.uid
                                  ? localization.top_liked_artists
                                  : localization.top_liked_artists_by
                            ),
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
                                text: _uid == widget.uid
                                  ? localization.top_disliked_artists
                                  : localization.top_disliked_artists_by),
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
                                text: _uid == widget.uid
                                  ? localization.top_swiped_artists
                                  : localization.top_swiped_artists_by),
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
                                text: _uid == widget.uid
                                  ? localization.top_liked_albums
                                  : localization.top_liked_albums_by),
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
                                text: _uid == widget.uid
                                  ? localization.top_disliked_albums
                                  : localization.top_disliked_albums_by),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomAlbumsWidget(
                          albums: _albumsDisliked,
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
                                text: _uid == widget.uid
                                  ? localization.top_swiped_albums
                                  : localization.top_swiped_albums_by),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        CustomAlbumsWidget(
                          albums: _albumsSwiped,
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
