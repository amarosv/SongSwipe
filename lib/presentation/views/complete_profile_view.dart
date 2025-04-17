import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;

  File? _image; // Imagen seleccionada
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    _usernameController = TextEditingController();
    _usernameController.addListener(_onUsernameChanged);
    _nameController = TextEditingController();
    _nameController.addListener(() {
      // Quitamos el alert
      setState(() {
        _nameRequired = false;
      });
      checkIfButtonIsActived();
    });
    _lastNameController = TextEditingController();
    _lastNameController.addListener(() {
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
    _usernameController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Función que se llama cuando el username ha cambiado
  void _onUsernameChanged() {
    _debounce?.cancel();

    // Variable que almacena si el nombre de usuario no contiene espacios ni caracteres especiales
    bool isValid = false;

    // Forzamos minúsculas en tiempo real
    final currentText = _usernameController.text;
    final lowerText = currentText.toLowerCase();
    if (currentText != lowerText) {
      _usernameController.value = _usernameController.value.copyWith(
        text: lowerText,
        selection: TextSelection.collapsed(offset: lowerText.length),
      );
      return; // evitamos duplicar acciones mientras se sincroniza el texto
    }

    // Validar caracteres permitidos
    isValid = RegExp(r'^[a-z0-9_]*$').hasMatch(lowerText);

    // Quitamos el alert
    setState(() {
      _usernameRequired = false;
    });

    // Primero comprobamos que el username no esté vacío, sea de al menos 4 caracteres y no contenga
    // espacios ni caracteres especiales
    if (lowerText.isNotEmpty && lowerText.length >= 4 && isValid) {
      _debounce = Timer(const Duration(milliseconds: 700), () async {
        _usernameExists = await checkIfUsernameExists(_usernameController.text);
        setState(() {
          if (_usernameExists) {
            checkIfButtonIsActived();
          }
        });
      });
    } else {
      setState(() {});
    }
  }

  // Función para recortar la imagen
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

  // Función para elegir la imagen
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
    if (_usernameController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty) {
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
              textEditingController: _usernameController,
              icon: _usernameRequired
                  ? Icon(
                      Icons.warning,
                      color: Colors.red,
                    )
                  : _usernameController.text.isNotEmpty &&
                          _usernameController.text.length >= 4
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
                textEditingController: _nameController,
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
                textEditingController: _lastNameController,
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
                        String name = _nameController.text;
                        String lastName = _lastNameController.text;
                        String username = _usernameController.text;

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
