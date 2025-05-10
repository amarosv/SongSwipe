import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Widget que personaliza el switch <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomSwitchContainer extends StatelessWidget {
  final String title;
  final bool switchValue;
  final Function(bool) function;

  const CustomSwitchContainer({super.key, required this.title, required this.switchValue, required this.function});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            capitalizeFirstLetter(text: title),
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Switch.adaptive(
              inactiveTrackColor: Colors.red,
              value: switchValue,
              onChanged: function)
        ],
      ),
    );
  }
}
