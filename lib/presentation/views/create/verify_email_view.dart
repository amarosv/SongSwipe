import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:toastification/toastification.dart';

/// Vista para la pantalla de verificación del email <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  User user = FirebaseAuth.instance.currentUser!;
  late AppLocalizations localization;
  bool _isButtonDisabled = false;
  int _counter = 60;
  Timer? _timer;
  Timer? _verificationTimer; // Timer para verificar el correo electrónico

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _startEmailVerificationCheck();
  }

  void _startCountdown() {
    setState(() {
      _isButtonDisabled = true;
      _counter = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  // Función para iniciar la verificación periódica del correo electrónico
  void _startEmailVerificationCheck() {
    const checkInterval = Duration(seconds: 5); // Verifica cada 5 segundos

    _verificationTimer = Timer.periodic(checkInterval, (timer) async {
      await _checkEmailVerification();
    });
  }

  // Función para comprobar si el usuario verificó el correo
  Future<void> _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload(); // Recargamos la información del usuario

      if (user.emailVerified) {
        // Mostramos la notificación
        toastification.show(
          context: context,
          style: ToastificationStyle.flatColored,
          title: Text(capitalizeFirstLetter(text: localization.verified)),
          description: RichText(
              text: TextSpan(
                  text:
                      capitalizeFirstLetter(text: localization.verified_email),
                  style: TextStyle(color: Colors.black))),
          autoCloseDuration: const Duration(seconds: 3),
        );

        // Detén el Timer ya que el correo ha sido verificado
        _verificationTimer?.cancel();

        // Vamos a la pantalla de completar el perfil
        context.go("/complete-profile");
      } else {
        print('⚠️ Aún no ha verificado el correo.');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;

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
            CustomButton(
              backgroundColor:
                  _isButtonDisabled ? Colors.grey : Color(0xFF349BFB),
              onPressed: () async {
                if (!_isButtonDisabled) {
                  // Enviamos el email
                  await user.sendEmailVerification();

                  // Mostramos la notificación
                  toastification.show(
                    context: context,
                    style: ToastificationStyle.flatColored,
                    title: Text(capitalizeFirstLetter(text: localization.sent)),
                    description: RichText(
                        text: TextSpan(
                            text: capitalizeFirstLetter(
                                text: localization.resent),
                            style: TextStyle(color: Colors.black))),
                    autoCloseDuration: const Duration(seconds: 3),
                  );

                  // "Deshabilitamos el botón" e iniciamos la cuenta atrás
                  _startCountdown();
                }
              },
              text: _isButtonDisabled
                  ? '${_counter}s'
                  : upperCaseAfterSpace(text: localization.resend),
            )
          ],
        ),
      ),
    );
  }
}
