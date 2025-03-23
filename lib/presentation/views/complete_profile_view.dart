import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:songswipe/helpers/export_helpers.dart';
import 'package:songswipe/presentation/widgets/export_widgets.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  // Constante que almacena la ruta a las imagenes
  final String assetsPath = 'assets/images/useful';

  // Controllers de los TextField
  late TextEditingController usernameController;
  late TextEditingController nameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controllers
    usernameController = TextEditingController();
    nameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    // Destruimos los controllers
    usernameController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  File? _image; // Imagen seleccionada
  final ImagePicker _picker = ImagePicker();

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
        await _picker.pickImage(source: ImageSource.gallery);

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
            ),

            // Texto informativo para el username
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Text(
                  'You can change your username later on the profile page.'),
            ),

            // CustomTextField para el nombre
            CustomTextfield(
              title: capitalizeFirstLetter(text: localization.name),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder:
                  capitalizeFirstLetter(text: localization.name_placeholder),
              textEditingController: nameController,
            ),

            // Espaciado
            Padding(padding: EdgeInsets.symmetric(vertical: 20)),

            // CustomTextField para los apellidos
            CustomTextfield(
              title: capitalizeFirstLetter(text: localization.lastname),
              padding: EdgeInsets.symmetric(horizontal: 50),
              placeholder: capitalizeFirstLetter(
                  text: localization.lastname_placeholder),
              textEditingController: lastNameController,
            ),

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
                backgroundColor: Color(0xFFFF9E16),
                onPressed: () {},
                text: localization.continue_s)
          ],
        ),
      )),
    );
  }
}
