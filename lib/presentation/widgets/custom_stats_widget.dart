import 'package:flutter/material.dart';
import 'package:songswipe/helpers/utils.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget personalizado para mostrar las stats <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomStatsWidget extends StatelessWidget {
  /// Stats a mostrar
  final Stats stats;
  
  const CustomStatsWidget({
    super.key,
    required this.stats,
  });


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Likes
          Column(
            children: [
              Icon(
                Icons.thumb_up,
                size: 32,
              ),
              Text(
                  '${humanReadbleNumber(stats.likes)} likes')
            ],
          ),
          // Dislikes
          Column(
            children: [
              Icon(
                Icons.thumb_down,
                size: 32,
              ),
              Text(
                  '${humanReadbleNumber(stats.dislikes)} dislikes')
            ],
          ),
          // Swipes
          Column(
            children: [
              Icon(
                Icons.swipe_outlined,
                size: 32,
              ),
              Text(
                  '${humanReadbleNumber(stats.swipes)} swipes')
            ],
          ),
        ],
      ),
    ));
  }
}