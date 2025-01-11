import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Variable que almacena el idioma seleccionado
  Language language = Language.english;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}