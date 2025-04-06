import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/select_genres_view.dart';

class SelectGenresScreen extends StatelessWidget {
  static const name = 'select-genres-screen';
  const SelectGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectGenresView();
  }
}