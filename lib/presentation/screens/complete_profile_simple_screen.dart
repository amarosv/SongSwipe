import 'package:flutter/material.dart';
import 'package:songswipe/presentation/views/complete_profile_simple_view.dart';

/// Pantalla para completar el perfil simple <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CompleteProfileSimpleScreen extends StatelessWidget {
  /// Nombre de la ruta
  static const name = 'complete-profile-simple-screen';
  /// Proveedor (Apple o Google)
  final String supplier;
  const CompleteProfileSimpleScreen({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return CompleteProfileSimpleView(supplier: supplier);
  }
}