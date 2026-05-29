import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'methods/post_storage.dart';
import '../../providers/user_provider.dart';
import '../home.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;

  final TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

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
    final user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Image",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_image == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select an image"),
                  ),
                );
                return;
              }
              String response = await PostStorage().uploadPost(
                captionController.text,
                user!.uid,
                user.username,
                user.photoUrl,
                _image!,
              );
              if (response == "Ok") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Post uploaded"),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(response),
                  ),
                );
              }
            },
            child: const Text(
              "Post",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 35,
                color: Color.fromARGB(218, 226, 37, 24),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Add Image",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Choose an image from your gallery or take a one.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: selectImageFromGallery,
              child: Container(
                width: 230,
                height: 230,
                color: Colors.grey.shade200,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        "assets/images/Post_image.png",
                          width: 120,
                          height: 120,
                      ),
              ),
            ),
            const SizedBox(height: 30),
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
          ],
        ),
      ),
    );
  }
}
