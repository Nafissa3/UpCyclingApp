import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http; // Pour envoyer la photo
import 'result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Fonction pour envoyer la photo au backend
  Future<void> _sendPhotoToBackend(File photoFile) async {
    final uri = Uri.parse('https://ton-api.com/upload'); // Remplace par l'URL de ton backend

    try {
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // doit correspondre au nom attendu par ton backend
          photoFile.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image envoyée avec succès');
      } else {
        print('Échec de l\'envoi: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur envoi image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_controller!),
                ),
                Positioned(
                  top: 57,
                  left: 25,
                  width: 45,
                  height: 44,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/flecheretour.png'),
                  ),
                ),
                Positioned(
                  top: 167,
                  left:
                  (MediaQuery.of(context).size.width - 287.5) / 2,
                  child: SizedBox(
                    width: 287.5,
                    height: 478,
                    child: Image.asset('assets/images/cadrephoto.png'),
                  ),
                ),
                Positioned(
                  bottom: 46,
                  left:
                  (MediaQuery.of(context).size.width - 65) / 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/tourphoto.png',
                        width: 65,
                        height: 65,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isPressed = true;
                          });
                          Future.delayed(const Duration(milliseconds: 150),
                                  () {
                                setState(() {
                                  _isPressed = false;
                                });
                              });

                          try {
                            await _initializeControllerFuture;
                            final XFile image =
                            await _controller!.takePicture();
                            final File photoFile = File(image.path);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Photo prise')),
                            );

                            // Envoi vers le backend
                            await _sendPhotoToBackend(photoFile);

                            // Naviguer vers la page de résultat
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultPage(
                                    photoFile: photoFile),
                              ),
                            );
                          } catch (e) {
                            print('Erreur prise photo : $e');
                          }
                        },
                        child: AnimatedScale(
                          scale: _isPressed ? 0.8 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Image.asset(
                            'assets/images/boutonphoto.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
