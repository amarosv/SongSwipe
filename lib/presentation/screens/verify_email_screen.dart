import 'package:flutter/widgets.dart';
import 'package:songswipe/presentation/views/verify_email_view.dart';

/// Pantalla para verificar el email <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class VerifyEmailScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'verify-email-screen';
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerifyEmailView();
  }
}