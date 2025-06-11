import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Vista para la pantalla de exportar canciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ExportTracksView extends StatefulWidget {
  /// Lista de canciones
  final Set<Track> tracks;

  const ExportTracksView({super.key, required this.tracks});

  @override
  State<ExportTracksView> createState() => _ExportTracksViewState();
}

class _ExportTracksViewState extends State<ExportTracksView> {
  // Tupla con lista de canciones exportadas y lista de canciones fallidas
  late (List<Map<String, String>> ids, List<Track> cancionesFallidas)? pair;

  // Variable que almacena las canciones exportadas
  late List<Map<String, String>> _spotifyTrackDataFuture;

  // Variable que almacena las canciones fallidas
  late List<Track> _cancionesFallidas;

  // Variable que almacena si se está cargando
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initView();
  }

  // Función que llama a exportar las canciones
  void _initView() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pair = await authenticateAndSearchTracks(
        tracks: widget.tracks.toList(),
        context: context,
      );

      if (!mounted) return;

      if (pair == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(capitalizeFirstLetter(text: AppLocalizations.of(context)!.login_abort))),
        );
        Navigator.pop(context);
        return;
      }

      _spotifyTrackDataFuture = pair!.$1;
      _cancionesFallidas = pair!.$2;
      _isLoading = false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
          title: Text(capitalizeFirstLetter(
              text: '${localization.export_to} Spotify'))),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        '${_spotifyTrackDataFuture.length} ${localization.of_txt} ${widget.tracks.length} ${localization.tracks_exported}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_cancionesFallidas.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalizeFirstLetter(
                                  text:
                                      '${localization.cant_export} ${_cancionesFallidas.length} ${localization.tracks}:'),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            ..._cancionesFallidas.map((track) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: CustomContainer(
                                    color: Colors.transparent,
                                    borderColor: Colors.red,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          track.md5Image,
                                          height: 64,
                                          width: 64,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                track.title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                track.buildArtistsText(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        capitalizeFirstLetter(
                            text: '${localization.tracks_succes_export}:'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.tracks.length,
                      itemBuilder: (context, index) {
                        final track = widget.tracks.elementAt(index);
                        Map<String, String>? spotifyTrack;
                        if (index < _spotifyTrackDataFuture.length) {
                          spotifyTrack = _spotifyTrackDataFuture[index];
                        }

                        return Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Deezer')),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomContainer(
                                color: Colors.transparent,
                                borderColor: Colors.black,
                                child: Row(
                                  children: [
                                    Image.network(
                                      track.album.cover,
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            track.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            track.buildArtistsText(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(localization.as.toUpperCase()),
                            const SizedBox(height: 5),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text('Spotify')),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomContainer(
                                color: Colors.transparent,
                                borderColor: Colors.black,
                                child: Row(
                                  children: [
                                    Image.network(
                                      spotifyTrack != null
                                          ? (spotifyTrack['image'] ?? '')
                                          : '',
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            spotifyTrack != null
                                                ? (spotifyTrack['title'] ??
                                                    'Sin título')
                                                : 'Sin título',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            spotifyTrack != null
                                                ? (spotifyTrack['artists'] ??
                                                    'Sin título')
                                                : 'Sin título',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
