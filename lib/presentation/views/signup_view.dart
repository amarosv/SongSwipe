import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class SignUpView extends StatefulWidget {
  // Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const SignUpView({super.key, required this.onChangeLanguage});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // Constante que almacena la ruta a los logos
  final String assetsPath = 'assets/images/logos';

  // Controllers de los TextField
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  Timer? _verificationTimer; // Timer para verificar el correo electrónico

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Destruimos los controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _verificationTimer?.cancel();
    super.dispose();
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
        print('✅ Correo verificado. Registrando en la API...');

        // Detén el Timer ya que el correo ha sido verificado
        _verificationTimer?.cancel();

        // Llamada a la API para guardar el usuario
        final response = await http.post(
          Uri.parse(Environment.apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'uid': user.uid,
            'name': 'Amaro',
            'lastName': 'Suárez',
            'email': emailController.text,
            'photoURL':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Spider-Man.jpg/1200px-Spider-Man.jpg',
            'dateJoining': 'null',
            'username': emailController.text + user.uid,
            'userDeleted': false,
            'userBlocked': false
          }),
        );

        if (response.statusCode == 200) {
          print('✅ Usuario registrado en la API.');
          // context.go('/home'); // Redirigir al home
        } else {
          print('❌ Error al registrar en la API: ${response.body}');
        }
      } else {
        print('⚠️ Aún no ha verificado el correo.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dropdown para los idiomas
              CustomDropdownLanguage(
                onChangeLanguage: widget.onChangeLanguage,
              ),

              const SizedBox(height: 10),

              // Logo en horizontal
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Image(
                  image:
                      AssetImage('$assetsPath/logo-horizontal-sin-fondo.png'),
                ),
              ),

              const SizedBox(height: 20),
              
              // CustomTextField para el email
              CustomTextfield(
                title: capitalizeFirstLetter(text: localization.email),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder:
                    capitalizeFirstLetter(text: localization.email_placeholder),
                textEditingController: emailController,
              ),

              const SizedBox(height: 20),

              // CustomTextField para la contraseña
              CustomTextfield(
                title: capitalizeFirstLetter(text: localization.password),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization.password_placeholder),
                isPassword: true,
                textEditingController: passwordController,
              ),

              const SizedBox(height: 20),

              // CustomTextField para confirmar la contraseña
              CustomTextfield(
                title:
                    capitalizeFirstLetter(text: localization.confirm_password),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization.confirm_password_placeholder),
                isPassword: true,
                textEditingController: confirmPasswordController,
              ),

              const SizedBox(height: 20),

              // Button para crear la cuenta
              CustomButton(
                  backgroundColor: Color(0xFFFF9E16),
                  onPressed: () async {
                    // Comprobamos que el email sea válido
                    Map<bool, String> resultsCheckEmail = emailValidator(
                        email: emailController.text, context: context);

                    if (resultsCheckEmail.keys.first) {
// Comprobamos si las dos contraseñas coinciden
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        // Comprobamos si la contraseña cumple con los requisitos
                        Map<bool, String> resultsCheck = passwordValidator(
                            password: passwordController.text,
                            context: context);

                        if (resultsCheck.keys.first) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            // Vamos a completar el perfil
                            context.push('/complete-profile');

                            // Enviamos el correo de verificación
                            // await credential.user!.sendEmailVerification();
                            // print(
                            //     'Correo de verificación enviado a ${credential.user!.email}');
                          
                            // // Inicia la verificación periódica del correo electrónico
                            // _startEmailVerificationCheck();
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            print('Error ${e.toString()}');
                          }
                        } else {
                          print(resultsCheck.entries.first.value);
                        }
                      } else {
                        print(localization.error_passwords_match);
                      }
                    } else {
                      print(resultsCheckEmail.entries.first.value);
                    }
                  },
                  text: localization.create_account),

              const SizedBox(height: 20),

              // Separación
              SeparateSections(),

              const SizedBox(height: 20),

              // Crear cuenta con proovedores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: CustomSocialButton(
                        backgroundColor: Colors.white,
                        onPressed: () {},
                        text: 'Apple',
                        borderColor: Colors.black,
                        imagePath: 'assets/images/social/apple.png',
                      ),
                    ),
                    Expanded(
                      child: CustomSocialButton(
                        backgroundColor: Colors.black,
                        onPressed: () {},
                        textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        text: 'Google',
                        borderColor: Colors.black,
                        imagePath: 'assets/images/social/google.png',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // Texto tiene cuenta
              Text(capitalizeFirstLetter(
                  text: localization.already_have_an_account)),

              const SizedBox(
                height: 5,
              ),

              // Botón para ir al Login
              CustomButton(
                  backgroundColor: Color(0xFF349BFB),
                  onPressed: () {
                    // Vamos al login
                    context.go('/login');
                  },
                  text: upperCaseAfterSpace(text: localization.login))
            ],
          ),
        ),
      ),
    );
  }
}
