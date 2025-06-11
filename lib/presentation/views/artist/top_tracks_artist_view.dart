import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Vista que muestra las canciones top del artista <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class TopTracksArtistView extends StatefulWidget {
  /// Lista de canciones
  final List<Track> tracks;

  const TopTracksArtistView({super.key, required this.tracks});

  @override
  State<TopTracksArtistView> createState() => _TopTracksArtistViewState();
}

class _TopTracksArtistViewState extends State<TopTracksArtistView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                localization.top_tracks.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${localization.by} ${widget.tracks.first.artist.name}',
                style: TextStyle(
                  fontSize: 14
                ),
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => context
                  .push('/swipes', extra: widget.tracks)
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
                      child: Icon(Icons.swipe),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: FadeInLeft(
          child: ListView.builder(
            
            itemBuilder: (context, index) {
              Track track = widget.tracks[index];
                
              return FadeInLeft(child: CustomListTracks(track: track, artists: track.buildArtistsText(), allTracksLength: widget.tracks.length, index: index));
            }
          ),
        ));
  }
}
