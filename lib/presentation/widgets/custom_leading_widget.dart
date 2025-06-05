import 'package:flutter/material.dart';

/// Widget que personaliza el Leading de los AppBar <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CustomLeadingWidget extends StatelessWidget {
  final bool hasChange;
  final double textOpacity;

  const CustomLeadingWidget({super.key, required this.hasChange, required this.textOpacity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, hasChange),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 300),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textOpacity <= 0
                  ? Colors.black.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                key: ValueKey<bool>(textOpacity > 0),
                color: textOpacity <= 0
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}