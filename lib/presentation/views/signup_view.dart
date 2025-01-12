import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
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
            ),

            const SizedBox(height: 20),
            CustomTextfield(
              title: capitalizeFirstLetter(text: AppLocalizations.of(context)!.email),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder: capitalizeFirstLetter(text: AppLocalizations.of(context)!.email_placeholder),
            ),

            const SizedBox(height: 20),
            CustomTextfield(
              title: capitalizeFirstLetter(text: AppLocalizations.of(context)!.password),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder: capitalizeFirstLetter(text: AppLocalizations.of(context)!.password_placeholder),
              isPassword: true,
            ),

            const SizedBox(height: 20),
            CustomTextfield(
              title: capitalizeFirstLetter(text: AppLocalizations.of(context)!.confirm_password),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder: capitalizeFirstLetter(text: AppLocalizations.of(context)!.confirm_password_placeholder),
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }
}
