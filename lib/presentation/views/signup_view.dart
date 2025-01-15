import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
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
    super.dispose();
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
              CustomDropdownLanguage(onChangeLanguage: widget.onChangeLanguage,),

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
                title: capitalizeFirstLetter(
                    text: localization.email),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization.email_placeholder),
                textEditingController: emailController,
              ),

              const SizedBox(height: 20),

              // CustomTextField para la contraseña
              CustomTextfield(
                title: capitalizeFirstLetter(
                    text: localization.password),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization.password_placeholder),
                isPassword: true,
                textEditingController: passwordController,
              ),

              const SizedBox(height: 20),

              // CustomTextField para confirmar la contraseña
              CustomTextfield(
                title: capitalizeFirstLetter(
                    text: localization.confirm_password),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization
                        .confirm_password_placeholder),
                isPassword: true,
                textEditingController: confirmPasswordController,
              ),

              const SizedBox(height: 20),

              // Button para crear la cuenta
              CustomButton(
                  backgroundColor: Color(0xFFFF9E16),
                  onPressed: () {
                    // TODO: Aquí se hace el registro en Firebase
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
                    context.push('/login');
                  },
                  text: upperCaseAfterSpace(
                      text: localization.login))
            ],
          ),
        ),
      ),
    );
  }
}
