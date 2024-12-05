import 'dart:io';

import 'package:camera/camera.dart';
import 'package:euchack/components/standard_scaffold.dart';
import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:euchack/providers/cam_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

const baseApiUrl = "https://dev.ryanh.co";

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  late CameraController camController;

  bool isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    final cameras = Provider.of<CameraProvider>(context, listen: false).cameras;

    if (cameras.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ReceiptPage()),
        );
      });
      return;
    }

    camController = CameraController(cameras[0], ResolutionPreset.veryHigh);

    camController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('no perms');
            break;
          default:
            print("Error: $e");
            break;
        }
      }
    });
  }

  Future<void> takePictureAndSend() async {
    if (!camController.value.isInitialized || isTakingPicture) {
      return;
    }

    setState(() {
      isTakingPicture = true;
    });

    try {
      final imageFile = await camController.takePicture();

      _uploadImage(File(imageFile.path));
    } catch (e) {
      print(e);
    }

    setState(() {
      isTakingPicture = false;
    });
  }

  @override
  void dispose() {
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageTitle = "Receipt";
    return StandardScaffold(
      automaticallyImplyLeading: true,
      showNavBar: false,
      title: pageTitle,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Place the receipt in the frame",
              style: header2Text,
            ),
            Gap(10),
            buildCamera(camController),
            const Gap(20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(primaryColor),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
              ),
              onPressed: takePictureAndSend,
              child: !isTakingPicture
                  ? const Icon(Icons.document_scanner_outlined,
                      size: 30, color: textColor)
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: const CircularProgressIndicator(
                        color: textColor,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCamera(CameraController camController) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedOverflowBox(
            size: const Size(300, 495),
            alignment: Alignment.center,
            child: SizedBox(
              width: 300,
              height: 496,
              child: camController.value.isInitialized
                  ? CameraPreview(camController)
                  : const Center(
                      child: CircularProgressIndicator(
                      color: backgroundColor,
                    )),
            ),
          ),
        ),
      ),
    ],
  );
}

Future<void> _uploadImage(File image) async {
  final String apiUrl = '$baseApiUrl/api/submitReceipt';

  try {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      print(await response.stream.bytesToString());
    } else {
      print(await response.stream.bytesToString());
      print('Image upload failed: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}
