import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  Future<void> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      Uint8List imageBytes = await file.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (file != null) {
      Uint8List imageBytes = await file.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            const Text(
              "Holbegram",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 50,
              ),
            ),
            Image.asset(
              "assets/images/logo.png",
              width: 80,
              height: 60,
            ),
            const SizedBox(height: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text (
                  "Hello, ${widget.username} Welcome to Holbegram.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Choose an image from your gallery or take a new one.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            CircleAvatar(
              radius: 120,
              backgroundColor: Colors.transparent,
              backgroundImage: _image != null ? MemoryImage(_image!) : null,
              child: _image == null
                ? Image.asset(
                  "assets/images/Sample_User_Icon.png",
                  width: 240,
                  height: 240,
                ) : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: Color.fromARGB(218, 226, 37, 24),
                  ),
                  onPressed: selectImageFromGallery,
                ),
                const SizedBox(width: 120),
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Color.fromARGB(218, 226, 37, 24),
                  ),
                  onPressed: selectImageFromCamera,
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 120,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(218, 226, 37, 24),
                ),
                onPressed: () {},
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
