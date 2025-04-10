import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:songswipe/config/constants/environment.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/internal_api.dart';
import 'package:toastification/toastification.dart';

/// Vista de la pantalla completar perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  // Constante que almacena la ruta a las imagenes
  final String assetsPath = 'assets/images/useful';

  bool _usernameRequired = false;
  bool _nameRequired = false;
  bool _lastNameRequired = false;
  bool _activatedButton = false;

  bool _usernameExists = false;
  Timer? _debounce;

  // Controllers de los TextField
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;

  File? _image; // Imagen seleccionada
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    usernameController = TextEditingController();
    usernameController.addListener(_onUsernameChanged);
    nameController = TextEditingController();
    nameController.addListener(() {
      // Quitamos el alert
      setState(() {
        _nameRequired = false;
      });
      checkIfButtonIsActived();
    });
    lastNameController = TextEditingController();
    lastNameController.addListener(() {
      // Quitamos el alert
      setState(() {
        _lastNameRequired = false;
      });
      checkIfButtonIsActived();
    });
  }

  @override
  void dispose() {
    // Destruimos los controllers
    usernameController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  // Función que se llama cuando el username ha cambiado
  void _onUsernameChanged() {
    _debounce?.cancel();

    // Forzamos minúsculas en tiempo real
    final currentText = usernameController.text;
    final lowerText = currentText.toLowerCase();
    if (currentText != lowerText) {
      usernameController.value = usernameController.value.copyWith(
        text: lowerText,
        selection: TextSelection.collapsed(offset: lowerText.length),
      );
      return; // evitamos duplicar acciones mientras se sincroniza el texto
    }

    // Quitamos el alert
    setState(() {
      _usernameRequired = false;
    });

    // Primero comprobamos que el username no esté vacío y sea de al menos 4 caracteres
    if (lowerText.isNotEmpty && lowerText.length >= 4) {
      _debounce = Timer(const Duration(milliseconds: 700), () {
        _checkIfUsernameExists(lowerText);
      });
    } else {
      setState(() {});
    }
  }

  // Comprueba si ya existe ese username
  Future<void> _checkIfUsernameExists(String username) async {
    print(username);
    final url = Uri.parse('${Environment.apiUrl}/check-username/$username');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _usernameExists = data;

          if (_usernameExists) {
            checkIfButtonIsActived();
          }
        });
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Recortar Imagen',
            toolbarColor: Colors.orange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset
                  .square, // Permite recortar en formato cuadrado
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]),
        IOSUiSettings(title: 'Recortar Imagen', aspectRatioPresets: [
          CropAspectRatioPreset.square, // Permite recortar en formato cuadrado
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      File? croppedFile = await _cropImage(File(pickedFile.path));

      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
        });
      }
    }
  }

  /// Función que comprueba que los campos requeridos estén rellenos
  /// y activa el botón para continuar
  void checkIfButtonIsActived() {
    if (usernameController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty) {
      setState(() {
        _activatedButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.complete_profile.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),

            // CustomTextField para el username
            CustomTextfield(
              title: capitalizeFirstLetter(text: localization.username),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder: capitalizeFirstLetter(
                  text: localization.username_placeholder),
              textEditingController: usernameController,
              icon: _usernameRequired
                  ? Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : usernameController.text.isNotEmpty &&
                          usernameController.text.length >= 4
                      ? _usernameExists
                          ? Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                      : null,
            ),

            // Texto informativo para el username
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child:
                  Text(capitalizeFirstLetter(text: localization.username_info)),
            ),

            // CustomTextField para el nombre
            CustomTextfield(
                title: capitalizeFirstLetter(text: localization.name),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder:
                    capitalizeFirstLetter(text: localization.name_placeholder),
                textEditingController: nameController,
                icon: _nameRequired
                    ? Icon(
                        Icons.warning,
                        color: Colors.red,
                      )
                    : null),

            // Espaciado
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),

            // CustomTextField para los apellidos
            CustomTextfield(
                title: capitalizeFirstLetter(text: localization.lastname),
                padding: EdgeInsets.symmetric(horizontal: 50),
                placeholder: capitalizeFirstLetter(
                    text: localization.lastname_placeholder),
                textEditingController: lastNameController,
                icon: _lastNameRequired
                    ? Icon(
                        Icons.warning,
                        color: Colors.red,
                      )
                    : null),

            // Espaciado
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),

            // Texto para subir la imagen
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: SizedBox(
                width: width,
                child: Text(
                  capitalizeFirstLetter(text: localization.upload_your_photo),
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            // Imagen para subir la foto
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: _image != null
                      ? Image.file(_image!,
                          fit: BoxFit.cover) // Mostrar imagen seleccionada
                      : Image.asset(
                          '$assetsPath/upload-photo.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            // Espaciado
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),

            // Button para continuar
            CustomButton(
                backgroundColor:
                    _activatedButton ? Color(0xFFFF9E16) : Colors.grey,
                onPressed: _activatedButton
                    ? () async {
                        String name = nameController.text;
                        String lastName = lastNameController.text;
                        String username = usernameController.text;

                        // Primero comprueba que estén los campos rellenos
                        if (username.isNotEmpty &&
                            name.isNotEmpty &&
                            lastName.isNotEmpty) {
                          String? base64Image;

                          // Si hay imagen, la convertimos a base 64
                          if (_image != null) {
                            base64Image = await convertFileToBase64(_image!);
                          }

                          // Registramos al usuario en la base de datos
                          bool registered = await registerUserInDatabase(
                              name: name,
                              lastName: lastName,
                              username: username,
                              base64Image: base64Image);

                          // Si se ha registrado correctamente, vamos a la siguiente pantalla
                          if (registered) {
                            context.go('/select-artists');
                          }
                        } else {
                          // Mostramos la notificación
                          toastification.show(
                            type: ToastificationType.error,
                            context: context,
                            style: ToastificationStyle.flatColored,
                            title: Text(capitalizeFirstLetter(
                                text: localization.attention)),
                            description: RichText(
                                text: TextSpan(
                                    text: capitalizeFirstLetter(
                                        text: localization.fill_fields),
                                    style: TextStyle(color: Colors.black))),
                            autoCloseDuration: const Duration(seconds: 3),
                          );

                          setState(() {
                            if (username.isEmpty) {
                              _usernameRequired = true;
                            }

                            if (name.isEmpty) {
                              _nameRequired = true;
                            }

                            if (lastName.isEmpty) {
                              _lastNameRequired = true;
                            }
                          });
                        }
                      }
                    : () {},
                text: localization.continue_s)
          ],
        ),
      )),
    );
  }
}
