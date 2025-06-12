import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/auth_methods.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/user_app.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/export_apis.dart';
import 'package:toastification/toastification.dart';

/// Vista para la pantalla de login <br>
/// @author Amaro Suárez <br>
/// @version 1.0
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

  // Booleanos que controlan cuando se muestran los mensajes de error
  bool _showErrorEmail = false;
  bool _showErrorPassword = false;

  // Cadenas que almacenan los mensajes de error
  String _emailError = '';
  String _passwordError = '';

  // Controllers de los TextField
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Cooldown para el envío de correo de recuperación
  bool _isCooldown = false;
  Timer? _cooldownTimer;
  int _secondsRemaining = 0;

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
  }

  @override
  void dispose() {
    // Destruimos los controllers
    emailController.dispose();
    passwordController.dispose();
    _cooldownTimer?.cancel();
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

              const SizedBox(height: 30),

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
                textEditingController: passwordController,
                isPassword: true,
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

              const SizedBox(height: 10),

              // Texto para recuperar contraseña
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: width,
                  child: InkWell(
                    onTap: () async {
                      if (_isCooldown) return;
                      final email = emailController.text.trim();

                      if (email.isEmpty) {
                        showNotification(
                          capitalizeFirstLetter(text: localization.attention),
                          capitalizeFirstLetter(
                              text: localization.error_email_empty),
                          context,
                        );
                        return;
                      }

                      final result =
                          emailValidator(email: email, context: context);
                      if (!result.keys.first) {
                        showNotification(
                          capitalizeFirstLetter(text: localization.attention),
                          capitalizeFirstLetter(
                              text: result.entries.first.value),
                          context,
                        );
                        return;
                      }

                      UserApp userApp = await getUserByEmail(email: email);

                      if (userApp.email.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                          toastification.show(
                            context: context,
                            style: ToastificationStyle.flatColored,
                            title: Text(
                                capitalizeFirstLetter(text: localization.sent)),
                            description: RichText(
                                text: TextSpan(
                                    text: capitalizeFirstLetter(
                                        text: localization.email_reset_sent),
                                    style: TextStyle(color: Colors.black))),
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                          setState(() {
                            _isCooldown = true;
                            _secondsRemaining = 60;
                          });
                          _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                            if (_secondsRemaining == 0) {
                              timer.cancel();
                              setState(() {
                                _isCooldown = false;
                              });
                            } else {
                              setState(() {
                                _secondsRemaining--;
                              });
                            }
                          });
                        } catch (e) {
                          showNotification(
                            capitalizeFirstLetter(text: localization.attention),
                            capitalizeFirstLetter(text: localization.error),
                            context,
                          );
                        }
                      } else {
                        showNotification(
                            capitalizeFirstLetter(text: localization.attention),
                            capitalizeFirstLetter(text: localization.email_not_exist),
                            context,
                          );
                      }
                    },
                    child: Text(
                      _isCooldown
                          ? '${capitalizeFirstLetter(text: localization.forgot_password)} (${_secondsRemaining}s)'
                          : capitalizeFirstLetter(text: localization.forgot_password),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: _isCooldown ? Colors.grey : Colors.black,
                      ),
                    ),
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
                      setState(() {
                        _showErrorEmail = false;
                        _showErrorPassword = false;
                      });

                      // Comprobamos que la contraseña no esté vacía
                      if (password.isNotEmpty) {
                        // Intentamos el inicio de sesión
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          if (!mounted) return;

                          if (credential.user != null) {
                            UserApp userApp =
                                await getUserByUID(uid: credential.user!.uid);

                            // Si el uid está vacío es porque está eliminado
                            if (userApp.uid.isNotEmpty) {
                              context.go('/home/4');
                            } else {
                              showNotification(
                                  capitalizeFirstLetter(
                                      text: localization.attention),
                                  capitalizeFirstLetter(
                                      text: localization
                                          .error_account_not_exists),
                                  context);
                            }
                          } else {
                            throw Error();
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            print(
                                'No user found for that email or password is wrong.');

                            showNotification(
                                capitalizeFirstLetter(
                                    text: localization.attention),
                                capitalizeFirstLetter(
                                    text:
                                        localization.error_account_not_exists),
                                context);
                          } else {
                            showNotification(
                                capitalizeFirstLetter(
                                    text: localization.attention),
                                capitalizeFirstLetter(text: localization.error),
                                context);
                          }
                        }
                      } else {
                        setState(() {
                          _showErrorPassword = true;
                          _passwordError = capitalizeFirstLetter(
                              text: localization.error_password_empty);
                        });
                        print(localization.error_password_empty);
                      }
                    } else {
                      setState(() {
                        _showErrorEmail = true;
                        _emailError = capitalizeFirstLetter(
                            text: resultsCheck.entries.first.value);
                      });
                      print(resultsCheck.entries.first.value);
                    }
                  },
                  text: upperCaseAfterSpace(text: localization.login)),

              const SizedBox(height: 30),

              // Separación
              SeparateSections(),

              const SizedBox(
                height: 20,
              ),

              // Iniciar sesión con proovedores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  spacing: 20,
                  children: [
                    // Necesita cuenta de pago de Apple Developer
                    // Expanded(
                    //   child: CustomSocialButton(
                    //     backgroundColor: Colors.white,
                    //     onPressed: () async {
                    //       if (!Platform.isIOS) return;

                    //       try {
                    //         final appleCredential = await SignInWithApple.getAppleIDCredential(
                    //           scopes: [
                    //             AppleIDAuthorizationScopes.email,
                    //             AppleIDAuthorizationScopes.fullName,
                    //           ],
                    //         );

                    //         final oauthCredential = OAuthProvider("apple.com").credential(
                    //           idToken: appleCredential.identityToken,
                    //           accessToken: appleCredential.authorizationCode,
                    //         );

                    //         final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

                    //         if (userCredential.user != null) {
                    //           context.go('/home/4');
                    //         }
                    //       } catch (e) {
                    //         print(e);
                    //         showNotification(
                    //           capitalizeFirstLetter(text: AppLocalizations.of(context)!.attention),
                    //           capitalizeFirstLetter(text: AppLocalizations.of(context)!.error),
                    //           context,
                    //         );
                    //       }
                    //     },
                    //     text: 'Apple',
                    //     borderColor: Colors.black,
                    //     imagePath: 'assets/images/social/apple.png',
                    //   ),
                    // ),

                    Expanded(
                      child: CustomSocialButton(
                        backgroundColor: Colors.black,
                        onPressed: () async {
                          User? user = await signInWithGoogle();

                          if (user != null) {
                            UserApp userApp = await getUserByUID(uid: user.uid);

                            // Si el uid está vacío es porque está eliminado
                            if (userApp.uid.isNotEmpty) {
                              context.go('/home/4');
                            } else {
                              showNotification(
                                  capitalizeFirstLetter(
                                      text: localization.attention),
                                  capitalizeFirstLetter(
                                      text: localization
                                          .error_account_not_exists),
                                  context);
                            }
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
                  text: upperCaseAfterSpace(text: localization.create_account)),
            ],
          ),
        ),
      ),
    );
  }
}
