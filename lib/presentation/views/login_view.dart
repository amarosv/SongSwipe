import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Constante que almacena la ruta a los logos
  final String assetsPath = 'assets/images/logos';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomDropdownLanguage(),
            Image(
              image: AssetImage('$assetsPath/logo-horizontal-sin-fondo.png'),
            )
          ],
        ),
      ),
    );
  }
}