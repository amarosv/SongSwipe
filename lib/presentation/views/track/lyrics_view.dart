import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

/// Vista de letras de la canción <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class LyricsView extends StatelessWidget {
  /// Letras de la canción
  final String lyrics;

  /// Título de la canción
  final String trackTitle;

  /// Artistas de la canción
  final String trackArtists;

  /// Url de la imagen de la canción
  final String trackCover;

  const LyricsView(
      {super.key,
      required this.lyrics,
      required this.trackTitle,
      required this.trackArtists, required this.trackCover});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return  Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Padding(
          // padding: EdgeInsets.only(right: 50),
          padding: EdgeInsets.only(right: width*0.128),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                Widget resultText;
          
                final text = trackTitle;
                final textPainter = TextPainter(
                    text: TextSpan(
                      text: text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    maxLines: 1,
                    textDirection: TextDirection.ltr)
                  ..layout(maxWidth: double.infinity);
          
                final textWidth = textPainter.size.width;
          
                if (textWidth > constraints.maxWidth) {
                  resultText = SizedBox(
                    height: 25,
                    child: Marquee(
                      text: text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
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
                    alignment: Alignment.topCenter,
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  );
                }
          
                return resultText;
              }),
          
              const SizedBox(height: 10),
          
              // Artistas
              Align(
                alignment: Alignment.bottomCenter,
                child: LayoutBuilder(builder: (context, constraints) {
                  Widget resultText;
                
                  final text = '($trackArtists)';
                  final textPainter = TextPainter(
                      text: TextSpan(
                        text: text,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      maxLines: 1,
                      textDirection: TextDirection.ltr)
                    ..layout(maxWidth: double.infinity);
                
                  final textWidth = textPainter.size.width;
                
                  if (textWidth > constraints.maxWidth) {
                    resultText = SizedBox(
                      height: 25,
                      child: Marquee(
                        text: text,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis),
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
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        style: TextStyle( 
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis),
                      ),
                    );
                  }
                
                  return resultText;
                }),
              )
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            lyrics,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              wordSpacing: 4,
              height: 1.6
            ),
          ),
        ),
      ),
    );
  }
}
