import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/config/providers/export_providers.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Vista para la pantalla de las canciones con dislike <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class DislikedView extends ConsumerStatefulWidget {
  /// UID del usuario
  final String uid;

  /// Variable que almacena si debe mostrarse en cuadrícula
  final bool grid;

  /// Callback para notificar el total de canciones
  final Function((int total, bool selecting)) onTotalChanged;

  const DislikedView({
    super.key,
    required this.uid,
    required this.grid,
    required this.onTotalChanged,
  });

  @override
  ConsumerState<DislikedView> createState() => _DislikedViewState();
}

class _DislikedViewState extends ConsumerState<DislikedView>
    with AutomaticKeepAliveClientMixin {
  // Variable que almacena el límite de canciones a traer
  final int _limit = 25;

  // Variable que almacena el límite de canciones a exportar
  final int _exportLimit = 100;

  // Variable que almacena el próximo enlace
  String _nextUrl = '';

  // Variable que almacena la lista con todas las canciones
  late List<Track> _allTracks = [];

  // Variable que almacena la lista con todos los ids de las canciones
  late List<int> _allTracksIds = [];

  // Variable que indica si se están cargando más canciones
  bool _isLoadingMore = false;

  // Variable que indica el número total de canciones
  int _totalTracks = 0;

  // Variable que almacena si se están seleccionando canciones
  bool _selecting = false;

  // Lista que almacena las canciones seleccionadas
  late Set<Track> _selectedTracks = {};

  @override
  void initState() {
    super.initState();
    _loadAllTracks();

    _fetchTracks();
  }

  // Función que obtiene todos los IDs de las canciones
  void _loadAllTracks() async {
    _allTracksIds = await getDislikedTracksIds(uid: widget.uid);
    setState(() {});
  }

  // Función que obtiene las canciones
  void _fetchTracks({bool reset = false}) async {
    if (!_isLoadingMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        setState(() => _isLoadingMore = true);

        if (reset) {
          _allTracks.clear();
          _nextUrl = '';
        }

        final data = await getLibraryUser(
          uid: widget.uid,
          url: _nextUrl,
          liked: false,
          limit: _limit,
        );

        setState(() {
          _allTracks.addAll(data.tracks);
          _nextUrl = data.linkNextPage;
          _isLoadingMore = false;
          _totalTracks = data.totalTracks;
          _loadAllTracks();
        });

        if (!_selecting) {
          widget.onTotalChanged((_totalTracks, false));
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localization = AppLocalizations.of(context)!;

    ref.listen<bool>(swipeChangedProvider, (prev, next) {
      if (next == true && mounted) {
        _fetchTracks(reset: true);
        ref.read(swipeChangedProvider.notifier).state = false;
      }
    });

    final size = MediaQuery.of(context).size;
    final height = size.height;

    return _allTracks.isEmpty && !_isLoadingMore
        ? Center(
            child: Text(capitalizeFirstLetter(text: localization.no_tracks)),
          )
        : _allTracks.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : VisibilityDetector(
                key: const Key('disliked-view'),
                onVisibilityChanged: (info) {
                  widget.onTotalChanged((
                    _selecting ? _selectedTracks.length : _totalTracks,
                    _selecting
                  ));
                },
                child: Scaffold(
                  body: !widget.grid
                      ? FadeInLeft(
                          child: ListView.builder(
                              shrinkWrap: true,
                              // padding: EdgeInsets.zero,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: _isLoadingMore
                                  ? _allTracks.length + 1
                                  : _allTracks.length,
                              itemBuilder: (context, index) {
                                Widget result;

                                if (index == _allTracks.length) {
                                  result = const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  Track track = _allTracks[index];

                                  String artists = track.buildArtistsText();

                                  if (index == _allTracks.length - 1 &&
                                      _nextUrl.isNotEmpty) {
                                    _fetchTracks();
                                  }

                                  result = FadeInLeft(
                                    child: CustomListTracks(
                                      track: track,
                                      artists: artists,
                                      allTracksLength: _allTracks.length,
                                      index: index,
                                      isSelecting: _selecting,
                                      isSelected:
                                          _selectedTracks.contains(track),
                                      onSelect: () {
                                        setState(() {
                                          if (_selectedTracks.contains(track)) {
                                            _selectedTracks.remove(track);
                                          } else {
                                            if (_selectedTracks.length >=
                                                _exportLimit) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        capitalizeFirstLetter(
                                                            text:
                                                                '${localization.cant_select} $_exportLimit ${localization.plural_tracks}'))),
                                              );
                                              return;
                                            }
                                            _selectedTracks.add(track);
                                          }

                                          widget.onTotalChanged(
                                              (_selectedTracks.length, true));
                                        });
                                      },
                                    ),
                                  );
                                }

                                return result;
                              }),
                        )
                      : FadeInDown(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.6 / 4,
                              ),
                              itemCount: _isLoadingMore
                                  ? _allTracks.length + 1
                                  : _allTracks.length,
                              itemBuilder: (context, index) {
                                Widget result;

                                if (index == _allTracks.length) {
                                  result = const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  Track track = _allTracks[index];

                                  String artists = track.buildArtistsText();

                                  if (index == _allTracks.length - 1 &&
                                      _nextUrl.isNotEmpty) {
                                    _fetchTracks();
                                  }

                                  result = FadeInDown(
                                    child: CustomGridTracks(
                                      height: height,
                                      track: track,
                                      artists: artists,
                                      index: index,
                                      isSelecting: _selecting,
                                      isSelected:
                                          _selectedTracks.contains(track),
                                      onSelect: () {
                                        setState(() {
                                          if (_selectedTracks.contains(track)) {
                                            _selectedTracks.remove(track);
                                          } else {
                                            if (_selectedTracks.length >=
                                                _exportLimit) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        capitalizeFirstLetter(
                                                            text:
                                                                '${localization.cant_select} $_exportLimit ${localization.plural_tracks}'))),
                                              );
                                              return;
                                            }
                                            _selectedTracks.add(track);
                                          }

                                          widget.onTotalChanged(
                                              (_selectedTracks.length, true));
                                        });
                                      },
                                    ),
                                  );
                                }

                                return result;
                              }),
                        ),
                  floatingActionButton: _selecting
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              heroTag: 'export_fab_dis',
                              onPressed: () => {
                                if (_selectedTracks.isEmpty)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(capitalizeFirstLetter(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .select_one_track))),
                                    )
                                  }
                                else
                                  {
                                    context.push(
                                      '/export',
                                      extra: _selectedTracks,
                                    )
                                  }
                              },
                              shape: CircleBorder(),
                              child: Icon(Icons.outbond),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton(
                                heroTag: 'cancel_fab_dis',
                                shape: CircleBorder(),
                                child: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selecting = !_selecting;
                                    _selectedTracks.clear();
                                  });

                                  if (!_selecting) {
                                    widget
                                        .onTotalChanged((_totalTracks, false));
                                  }
                                })
                          ],
                        )
                      : SpeedDial(
                          animatedIcon: AnimatedIcons.menu_arrow,
                          children: [
                            SpeedDialChild(
                                shape: CircleBorder(),
                                child: Icon(Icons.swipe),
                                label: 'Swipe',
                                onTap: _allTracksIds.length > 1
                                    ? () => context
                                            .push('/swipes-library',
                                                extra: _allTracksIds)
                                            .then((result) {
                                          if (result == true) {
                                            ref
                                                .read(swipeChangedProvider
                                                    .notifier)
                                                .state = true;
                                          }
                                        })
                                    : null),
                            SpeedDialChild(
                                shape: CircleBorder(),
                                child: Icon(Icons.outbond),
                                label: capitalizeFirstLetter(
                                    text: localization.export_tracks),
                                onTap: () {
                                  setState(() {
                                    _selecting = !_selecting;
                                    _selectedTracks.clear();
                                  });

                                  if (!_selecting) {
                                    widget
                                        .onTotalChanged((_totalTracks, false));
                                  }
                                })
                          ],
                        ),
                ));
  }
}
