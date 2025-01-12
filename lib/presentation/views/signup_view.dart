import 'package:flutter/material.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // Constante que almacena la ruta a los logos
  final String assetsPath = 'assets/images/logos';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Dropdown para los idiomas
            CustomDropdownLanguage(),
            const SizedBox(height: 20),

            // Logo en horizontal
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: Image(
                image: AssetImage('$assetsPath/logo-horizontal-sin-fondo.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}