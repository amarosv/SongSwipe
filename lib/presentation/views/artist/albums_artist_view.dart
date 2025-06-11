import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';

/// Vista que muestra los albumes del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class AlbumArtistView extends StatefulWidget {
  /// ID del artista
  final int idArtist;

  /// Nombre del artista
  final String nameArtist;

  const AlbumArtistView(
      {super.key, required this.idArtist, required this.nameArtist});

  @override
  State<AlbumArtistView> createState() => _AlbumArtistViewState();
}

class _AlbumArtistViewState extends State<AlbumArtistView> {
  // Variable que almacena el límite de albums a traer
  final int _limit = 25;

  // Variable que almacena el próximo enlace
  String _nextUrl = '';

  // Variable que almacena la lista con todos los albums
  late List<Album> _allAlbums = [];

  // Variable que indica si se están cargando más canciones
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  // Función que obtiene los albums
  void _fetchAlbums() async {
    if (!_isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        setState(() => _isLoadingMore = true);

        final data = await getArtistsAlbums(
            idArtist: widget.idArtist, limit: _limit, url: _nextUrl);

        if (!mounted) {
          return;
        }

        setState(() {
          _allAlbums.addAll(data.albums);
          _nextUrl = data.next;
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
          title: Column(
            children: [
              Text(
                localization.all_albums.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${localization.by} ${widget.nameArtist}',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        body: _allAlbums.isEmpty
            ? Center(child: CircularProgressIndicator())
            : FadeInLeft(
                child: ListView.builder(
                    shrinkWrap: true,
                    // padding: EdgeInsets.zero,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: _isLoadingMore
                        ? _allAlbums.length + 1
                        : _allAlbums.length,
                    itemBuilder: (context, index) {
                      Widget result;

                      if (index == _allAlbums.length) {
                        result = const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        Album album = _allAlbums[index];

                        if (index == _allAlbums.length - 1 &&
                            _nextUrl.isNotEmpty) {
                          _fetchAlbums();
                        }

                        result = FadeInLeft(
                          child: CustomListAlbumWidget(
                            album: album,
                            index: index,
                            albumsLength: _allAlbums.length
                          ),
                        );
                      }

                      return result;
                    }),
              ));
  }
}
