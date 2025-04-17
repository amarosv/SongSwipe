import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/helpers/auth_methods.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

/// Vista para la pantalla de sign up <br>
/// @author Amaro Suárez <br>
/// @version 1.0
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

  // Booleanos que controlan cuando se muestran los mensajes de error
  bool _showErrorEmail = false;
  bool _showErrorPassword = false;

  // Cadenas que almacenan los mensajes de error
  String _emailError = '';
  String _passwordError = '';

  // Controllers de los TextField
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    emailController = TextEditingController();
    emailController.addListener(() {
      setState(() {
        _showErrorEmail = false;
      });
    });
    passwordController = TextEditingController();
    passwordController.addListener(() {
      setState(() {
        _showErrorPassword = false;
      });
    });
    confirmPasswordController = TextEditingController();
    confirmPasswordController.addListener(() {
      setState(() {
        _showErrorPassword = false;
      });
    });
  }

  @override
  void dispose() {
    // Destruimos los controllers
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image(
                  image:
                      AssetImage('$assetsPath/logo-horizontal-sin-fondo.png'),
                ),
              ),

              const SizedBox(height: 20),

              // CustomTextField para el email
              CustomTextfield(
                title: capitalizeFirstLetter(text: localization.email),
                padding: EdgeInsets.symmetric(horizontal: 20),
                placeholder:
                    capitalizeFirstLetter(text: localization.email_placeholder),
                textEditingController: emailController,
                icon: _showErrorEmail
                    ? Icon(
                        Icons.warning,
                        color: Colors.red,
                      )
                    : null,
              ),

              // Mensaje de error del email
              _showErrorEmail
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                          width: width,
                          child: Text(
                            _emailError,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )),
                    )
                  : Container(),

              const SizedBox(height: 20),

              // CustomTextField para la contraseña
              CustomTextfield(
                title: capitalizeFirstLetter(text: localization.password),
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                placeholder: capitalizeFirstLetter(
                    text: localization.confirm_password_placeholder),
                isPassword: true,
                textEditingController: confirmPasswordController,
              ),

              // Mensaje de error de la contraseña
              _showErrorPassword
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                          width: width,
                          child: Text(
                            _passwordError,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )),
                    )
                  : Container(),

              const SizedBox(height: 20),

              // Button para crear la cuenta
              CustomButton(
                  backgroundColor: Color(0xFFFF9E16),
                  onPressed: () async {
                    String password = passwordController.text;
                    String confirmPassword = confirmPasswordController.text;

                    // Comprobamos que el email sea válido
                    Map<bool, String> resultsCheckEmail = emailValidator(
                        email: emailController.text, context: context);

                    if (resultsCheckEmail.keys.first) {
                      // Comprobamos si las dos contraseñas coinciden
                      if (password == confirmPassword) {
                        // Comprobamos si la contraseña cumple con los requisitos
                        Map<bool, String> resultsCheck = passwordValidator(
                            password: password, context: context);

                        if (resultsCheck.keys.first) {
                          setState(() {
                            _showErrorEmail = false;
                            _showErrorPassword = false;
                          });

                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: password,
                            );

                            // Enviamos el email de verificación
                            await credential.user!.sendEmailVerification();

                            // Vamos a completar a verificar el correo
                            context.push('/verify-email');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showNotification(
                                  capitalizeFirstLetter(
                                      text: localization.attention),
                                  capitalizeFirstLetter(
                                      text: localization.error_password_weak),
                                  context);
                            } else if (e.code == 'email-already-in-use') {
                              showNotification(
                                  capitalizeFirstLetter(
                                      text: localization.attention),
                                  capitalizeFirstLetter(
                                      text: localization.error_account),
                                  context);
                            }
                          } catch (e) {
                            print('Error ${e.toString()}');
                          }
                        } else {
                          setState(() {
                            _showErrorPassword = true;
                            _passwordError = capitalizeFirstLetter(
                                text: resultsCheck.entries.first.value);
                          });
                        }
                      } else {
                        setState(() {
                          _showErrorPassword = true;
                          _passwordError = capitalizeFirstLetter(
                              text: localization.error_passwords_match);
                        });
                      }
                    } else {
                      setState(() {
                        _showErrorEmail = true;
                        _emailError = capitalizeFirstLetter(
                            text: resultsCheckEmail.entries.first.value);
                      });
                    }
                  },
                  text: localization.create_account),

              const SizedBox(height: 20),

              // Separación
              SeparateSections(),

              const SizedBox(height: 20),

              // Crear cuenta con proovedores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        onPressed: () async {
                          User? userCredential =
                              await signInWithGoogle();

                          print(userCredential);

                          if (userCredential != null) {
                            context.go('/complete-profile-simple');
                          }
                        },
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
