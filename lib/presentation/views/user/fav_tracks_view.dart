import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/export_apis.dart';

/// Vista para mostrar las canciones favoritas <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class FavTracksView extends StatefulWidget {
  /// UID del usuario
  final String uid;

  /// Lista de IDs de las canciones
  final List<int> tracks;

  const FavTracksView({super.key, required this.uid, required this.tracks});

  @override
  State<FavTracksView> createState() => _FavTracksViewState();
}

class _FavTracksViewState extends State<FavTracksView> {
  // Variable que almacena el límite de canciones a traer
  final int _limit = 25;

  // Variable que almacena el próximo enlace
  String _nextUrl = '';

  // Variable que almacena la lista con todas las canciones
  late List<Track> _allTracks = [];

  late List<int> _idsTracks = [];

  // Variable que indica si se están cargando más canciones
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadTracksIds();
    _fetchTracks();
  }

  void _loadTracksIds() async {
    _idsTracks = await getLikedTracksIds(uid: widget.uid);
    setState(() {
      
    });
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
          liked: true,
          limit: _limit,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _allTracks.addAll(data.tracks);
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
        centerTitle: true,
        title: Text(
          localization.their_fav_tracks.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () => context
                .push('/swipes-library', extra: widget.tracks)
                .then((result) async {
              if (result is Future<void>) {
                print('waiting...');
                await result;
              }

              // ref.read(swipeChangedProvider.notifier).state = true;
            }),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: Icon(
                      Icons.swipe
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeInLeft(
        child: ListView.builder(
            shrinkWrap: true,
            // padding: EdgeInsets.zero,
            // physics: NeverScrollableScrollPhysics(),
            itemCount:
                _isLoadingMore ? _allTracks.length + 1 : _allTracks.length,
            itemBuilder: (context, index) {
              Widget result;

              if (index == _allTracks.length) {
                result = const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                Track track = _allTracks[index];

                String artists = track.buildArtistsText();

                if (index == _allTracks.length - 1 && _nextUrl.isNotEmpty) {
                  _fetchTracks();
                }

                result = FadeInLeft(
                  child: CustomListTracks(
                    track: track,
                    artists: artists,
                    allTracksLength: _allTracks.length,
                    index: index,
                    isSelecting: false,
                    isSelected: false,
                    onSelect: () {},
                  ),
                );
              }

              return result;
            }),
      ),
    );
  }
}
