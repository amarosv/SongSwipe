import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/views/export_views.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Vista para la pantalla biblioteca de canciones <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView>
    with AutomaticKeepAliveClientMixin {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Variable que almacena el uid del usuario
  late String _uid;

  // Variable que almacena si está en la vista de cuadrícula
  bool _grid = true;

  // Variable que almacena el total de canciones
  int _totalTracks = 0;

  // Variable que almacena si se están seleccionando canciones
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              capitalizeFirstLetter(
                  text:
                      !_isSelecting
                        ? '${localization.showing} $_totalTracks ${localization.tracks}'
                        : '$_totalTracks  ${localization.selected_tracks}'
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: localization.liked.toUpperCase()),
              Tab(text: localization.disliked.toUpperCase()),
            ],
          ),
          actions: [
            // Iconos para cambiar la vista
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CustomContainer(
                child: Row(
                  children: [
                    // Cuadrícula
                    GestureDetector(
                      onTap: () {
                        if (!_grid) {
                          _grid = true;
                        }

                        setState(() {});
                      },
                      child: CustomContainer(
                        color: _grid ? Colors.black45 : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Icon(
                            Icons.grid_view_rounded,
                            color: _grid
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ),

                    // Lista
                    GestureDetector(
                      onTap: () {
                        if (_grid) {
                          _grid = false;
                        }

                        setState(() {});
                      },
                      child: CustomContainer(
                        color: !_grid ? Colors.black45 : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Icon(
                            Icons.list,
                            color: !_grid
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: TabBarView(
          children: [
            FadeIn(
              child: LikedView(
                uid: _uid,
                grid: _grid,
                onTotalChanged: ((int count, bool selecting) res) => {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _totalTracks = res.$1;
                        _isSelecting = res.$2;
                      });
                    }
                  })
                },
              ),
            ),
            FadeIn(
              child: DislikedView(
                uid: _uid,
                grid: _grid,
                onTotalChanged: ((int count, bool selecting) res) => {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _totalTracks = res.$1;
                        _isSelecting = res.$2;
                      });
                    }
                  })
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
