import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/deezer_api.dart';

/// Widget personalizado para mostrar los datos del album <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomAlbumWidget extends StatefulWidget {
  /// Album
  final Album album;

  /// Stats
  final Stats stats;

  const CustomAlbumWidget({super.key, required this.album, required this.stats});

  @override
  State<CustomAlbumWidget> createState() => _CustomAlbumWidgetState();
}

class _CustomAlbumWidgetState extends State<CustomAlbumWidget> {
  late Genre genre = Genre.empty();

  @override
  void initState() {
    super.initState();
    loadData();
    getGenre();
  }

  void loadData() async {
    try {
      final results = await Future.wait([
        getGenreById(genreID: widget.album.genreId)
      ]);

      if (!mounted) return;

      setState(() {
        genre = results[0];
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Función que obtiene los datos del género
  void getGenre() async {
    Genre temp = await getGenreById(genreID: widget.album.genreId);

    if (!mounted) return;
    
    setState(() {
      genre = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;
    
    return CustomContainer(
      child: SizedBox(
        height: 128,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: SizedBox(
                width: 128,
                child: Image.network(
                  widget.album.md5Image,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Datos
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                Widget resultText;
                                final text = widget.album.title;
                                final textPainter = TextPainter(
                                  text: TextSpan(
                                    text: text.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr,
                                )..layout(maxWidth: double.infinity);
                                final textWidth = textPainter.size.width;
                                if (textWidth > constraints.maxWidth) {
                                  resultText = SizedBox(
                                    height: 20,
                                    child: Marquee(
                                      text: text.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      blankSpace: 20.0,
                                      velocity: 40.0,
                                      pauseAfterRound: Duration(seconds: 4),
                                      startPadding: 0.0,
                                      accelerationDuration: Duration(seconds: 2),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration: Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    ),
                                  );
                                } else {
                                  resultText = Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      text.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  );
                                }
                                return resultText;
                              },
                            ),
                          ),
                          if (widget.album.explicitLyrics ||
                              widget.album.explicitContentCover == 1 ||
                              widget.album.explicitContentLyrics == 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.explicit,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${localization.by} ${widget.album.artist.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${widget.album.tracks.length} ${localization.tracks} · ${dateToYear(date: widget.album.releaseDate)} ${genre.name.isEmpty ? '' : '· ${genre.name}'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          capitalizeFirstLetter(text: localization.stats),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${widget.stats.likes} Likes · ${widget.stats.dislikes} Dislikes · ${widget.stats.swipes} Swipes',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
