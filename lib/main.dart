// ignore_for_file: unnecessary_null_comparison, unused_element, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAPnpL52r8laTFnPv-CJQQMFti2FpOF9_E',
          appId: '1:688787314144:android:f51a492c4ca85862958785',
          messagingSenderId: '688787314144',
          projectId: 'fistwear-69dd0'));

  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PickImage(
        title: 'Image picker',
      ),
    );
  }
}

class PickImage extends StatefulWidget {
  const PickImage({super.key, required this.title});
  final String title;

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  // ignore: unused_field
  late bool _load = false;
  late File? imgFile;
  final imgPicker = ImagePicker();
  late String? imgUrl;

  Widget diplayImage() {
    if (imgFile == null) {
      return const Text('No Image Selected');
    } else {
      return Image.file(
        imgFile!,
        width: 350,
        height: 350,
      );
    }
  }

  void openCamera() async {
    // ignore: deprecated_member_use
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      _load = true;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  void openGallery() async {
    // ignore: deprecated_member_use
    var imaGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      _load = true;
      imgFile = File(imaGallery!.path);
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Options'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text('Capure Image From Camera'),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    child: const Text('Capure Image From Gellery'),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _uploadFile() async {
    Random random = Random();
    int i = random.nextInt(100000);
    // ignore: unused_local_variable, non_constant_identifier_names, constant_identifier_names
    const NavigationDestination = 'clothes';
    Reference ref =
        FirebaseStorage.instance.ref(NavigationDestination).child('clothes$i');
    await ref.putFile(imgFile!);
    imgUrl = await ref.getDownloadURL();
    print(imgUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _load ? diplayImage() : const SizedBox(),
          const SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
              onPressed: () {
                showOptionsDialog(context);
              },
              child: const Text('Select Your Image')),
          ElevatedButton(
              onPressed: () {
                _uploadFile();
              },
              child: const Text('Uplod'))
        ],
      )),
    );
  }
}
