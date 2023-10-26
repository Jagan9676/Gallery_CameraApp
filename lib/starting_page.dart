
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({Key? key}) : super(key: key);

  @override
  _StartingPageState createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
     late CameraController _controller;
  late Future<void> _initializeControllerFuture;
bool isReady = false;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final deviceCameras = await availableCameras();
    _controller = CameraController(
      deviceCameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      if (!mounted) {
        return;
      }
      setState(() {
        isReady = true; // Set isReady to true when the camera is ready.
      });
    } catch (e) {
      print(e);
    }
  }



 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openImagePicker() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile picture = await _controller.takePicture();

    setState(() {
      _image = File(picture.path);
    });
    }

  @override
  Widget build(BuildContext context) {
    return isReady == true ?  Scaffold(
      appBar: AppBar(
        title: const Text('Camera and Image Picker'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(_image!),
                    )
                  : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: CameraPreview(_controller),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_image == null) {
                    _openImagePicker();
                  } else {
                    setState(() {
                      _image = null;
                    });
                  }
                },
                child: Text(_image == null ? 'Select An Image' : 'Clear Image'),
              ),
              const SizedBox(height: 20),
              if (_image == null)
                IconButton(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.camera),
                ),
            ],
          ),
        ),
      ),
    ): const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
 