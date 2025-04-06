import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:songswipe/presentation/providers/export_providers.dart';

/// Vista de la pantalla de cambiar el tema <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class ChangeThemeView extends ConsumerWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final Map<String, Color> colors = ref.watch( colorListProvider );
    final int selectedColor = ref.watch( themeNotifierProvider ).selectedColor;
    // final int selectedColor = ref.watch( selectedColorProvider );

    return ListView.builder(
      itemCount: colors.length,
      itemBuilder:(context, index) {
        final String name = colors.keys.toList()[index];
        final Color color = colors.values.toList()[index];

        return RadioListTile(
          title: Text(name, style: TextStyle( color: color )),
          subtitle: Text('${ color.value }'),
          activeColor: color,
          value: index,
          groupValue: selectedColor,
          onChanged: (value) {
            // ref.read( selectedColorProvider.notifier ).state = index;
            ref.read( themeNotifierProvider.notifier )
              .changeColorIndex(index);
          }
        );
      },
    );
  }
}