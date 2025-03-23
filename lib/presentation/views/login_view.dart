import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class LoginView extends StatefulWidget {
  // Función para cambiar el lenguaje
  final Function(String) onChangeLanguage;

  const LoginView({super.key, required this.onChangeLanguage});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Constante que almacena la ruta a los logos
  final String assetsPath = 'assets/images/logos';

  // Controllers de los TextField
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // Destruimos los controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    final width = size.width;

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

              const SizedBox(height: 30),

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
                textEditingController: passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 10),

              // Texto para recuperar contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: width,
                  child: Text(
                    capitalizeFirstLetter(text: localization.forgot_password),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              CustomButton(
                  backgroundColor: Color(0xFF349BFB),
                  onPressed: () async {
                    String email = emailController.text;
                    String password = passwordController.text;

                    // Comprobamos que el email sea válido
                    Map<bool, String> resultsCheck =
                        emailValidator(email: email, context: context);

                    if (resultsCheck.keys.first) {
                      // Comprobamos que la contraseña no esté vacía
                      if (password.isNotEmpty) {
                        // Intentamos el inicio de sesión
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          print(credential.user!.email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            print('No user found for that email or password is wrong.');
                          } else {
                            print('An error has occurred');
                          }
                        }
                      } else {
                        print(localization.error_password_empty);
                      }
                    } else {
                      print(resultsCheck.entries.first.value);
                    }
                  },
                  text: capitalizeFirstLetter(text: localization.login)),

              const SizedBox(height: 30),

              // Separación
              SeparateSections(),

              const SizedBox(
                height: 20,
              ),

              // Iniciar sesión con proovedores
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
                height: 40,
              ),

              // Crear cuenta
              SizedBox(
                width: width,
                child: Text(
                  capitalizeFirstLetter(text: localization.not_registered),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 5),

              // Button para crear la cuenta
              CustomButton(
                  backgroundColor: Color(0xFFFF9E16),
                  onPressed: () {
                    context.go('/signup');
                  },
                  text: localization.create_account),
            ],
          ),
        ),
      ),
    );
  }
}
