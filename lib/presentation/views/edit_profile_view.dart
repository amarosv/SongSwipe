import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:songswipe/config/languages/app_localizations.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/models/export_models.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';
import 'package:songswipe/services/api/externals_api.dart';
import 'package:songswipe/services/api/internal_api.dart';

/// Vista para editar el perfil <br>
/// @author Amaro Suárez <br>
/// @version 1.0
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  // Obtenemos el usuario actual
  final User _user = FirebaseAuth.instance.currentUser!;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Variable que almacena el uid del usuario actual
  late String _uid;

  // Variable que almacena los datos del usuario
  late UserApp _userApp;

  // Controllers de los TextField
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;

  // Variable que almacena si se esta cargando los datos
  bool _isLoading = true;

  // Variable que almacena la imagen seleccionada
  File? _image;

  // Variable que almacena si el nombre de usuario existe
  bool _usernameExists = false;

  // Timer
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _uid = _user.uid;

    // Inicializamos los controllers
    _usernameController = TextEditingController();
    _usernameController.addListener(_onUsernameChanged);

    _nameController = TextEditingController();
    _nameController.addListener(() => setState(() {}));

    _lastNameController = TextEditingController();
    _lastNameController.addListener(() => setState(() {}));
    _loadData();
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

    // Primero comprobamos que el username no esté vacío, sea de al menos 4 caracteres y no contenga
    // espacios ni caracteres especiales
    if (lowerText.isNotEmpty && lowerText.length >= 4 && isValid) {
      _debounce = Timer(const Duration(milliseconds: 700), () async {
        _usernameExists = await checkIfUsernameExists(_usernameController.text);
        setState(() {});
      });
    } else {
      _usernameExists = true;
      setState(() {});
    }
  }

  // Función para obtener todos los datos
  void _loadData() async {
    if (!mounted) return;
    try {
      final results = await Future.wait([getUserByUID(uid: _uid)]);

      setState(() {
        _userApp = results[0];
        // _usernameController.text = _userApp.username;
        // _nameController.text = _userApp.name;
        // _lastNameController.text = _userApp.lastName;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
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

  @override
  Widget build(BuildContext context) {
    // Constante que almacena la localización de la app
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localization.edit_profile.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Imagen
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : NetworkImage(_userApp.photoUrl),
                            radius: 64,
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                  ),

                  // Botón para deshacer la imagen seleccionada
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomButton(
                          backgroundColor: Colors.redAccent,
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          text: capitalizeFirstLetter(
                              text: localization.reset_picture)),
                    ),

                  const SizedBox(
                    height: 20,
                  ),

                  // CustomTextField para el username
                  CustomTextfield(
                    title: capitalizeFirstLetter(text: localization.username),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    placeholder: _userApp.username,
                    textEditingController: _usernameController,
                    icon: _usernameController.text.isNotEmpty &&
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

                  const SizedBox(
                    height: 20,
                  ),

                  // Nombre
                  CustomTextfield(
                      title: capitalizeFirstLetter(text: localization.name),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      placeholder: _userApp.name,
                      textEditingController: _nameController),

                  const SizedBox(
                    height: 20,
                  ),

                  // Apellidos
                  CustomTextfield(
                      title: capitalizeFirstLetter(text: localization.lastname),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      placeholder: _userApp.lastName,
                      textEditingController: _lastNameController),

                  const SizedBox(
                    height: 20,
                  ),

                  // Botón para actualizar
                  CustomButton(
                      backgroundColor: !_usernameExists &&
                              (_usernameController.text.isNotEmpty ||
                                  _nameController.text.isNotEmpty ||
                                  _lastNameController.text.isNotEmpty ||
                                  _image != null)
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      onPressed: () async {
                        if (!_usernameExists &&
                            (_usernameController.text.isNotEmpty ||
                                _nameController.text.isNotEmpty ||
                                _lastNameController.text.isNotEmpty ||
                                _image != null)) {
                          // Variable que almacena la url de la imagen
                          String urlImage = '';

                          // Variable que almacena el nombre de usuario
                          String username = _usernameController.text;

                          // Variable que almacena el nombre del usuario
                          String name = _nameController.text;

                          // Variable que almacena el apellido del usuario
                          String lastName = _lastNameController.text;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) =>
                                Center(child: CircularProgressIndicator()),
                          );

                          // Comprobamos si ha editado la imagen
                          if (_image != null) {
                            // Eliminamos todas las imagenes
                            deleteAllUserImagesFromImagekit(_uid);

                            // Subimos la imagen
                            urlImage = await saveImageInImagekit(_uid, _image!);
                            _userApp.photoUrl = urlImage;
                          }

                          // Comprobamos si el username está vacío
                          if (username.isNotEmpty) {
                            _userApp.username = username;
                          }

                          // Comprobamos si el nombre está vacío
                          if (name.isNotEmpty) {
                            _userApp.name = name;
                          }

                          // Comprobamos si el apellido está vacío
                          if (lastName.isNotEmpty) {
                            _userApp.lastName = lastName;
                          }

                          // Actualizamos el usuario
                          bool updated = await updateUser(user: _userApp);

                          Navigator.of(context).pop();

                          print(updated);
                          if (updated) {
                            context.pop(true);
                          }
                        }
                      },
                      text: capitalizeFirstLetter(text: localization.update))
                ],
              ),
            ),
    );
  }
}
