import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:songswipe/helpers/strings_methods.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;
    User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage('assets/images/useful/email.png'),
                width: 128,
              ),
            ),
            const SizedBox(height: 20),
            // Texto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text.rich(
                TextSpan(
                  text: capitalizeFirstLetter(text: localization.sent_email),
                  children: [
                    TextSpan(
                        text: user.email,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text:
                                  '. ${capitalizeFirstLetter(text: localization.verify)}',
                              style: TextStyle(fontWeight: FontWeight.normal))
                        ]),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Botón para reenviar el email
            CustomButton(
                backgroundColor: Color(0xFF349BFB),
                onPressed: () {},
                text: upperCaseAfterSpace(text: localization.resend)),
            const SizedBox(height: 20),
            // Botón para cambiar el email
            CustomButton(
              backgroundColor: Colors.transparent,
              onPressed: () {},
              text: upperCaseAfterSpace(text: localization.change_email),
              textColor: Colors.black,
              border: BorderSide(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
