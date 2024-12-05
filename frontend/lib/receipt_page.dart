import 'package:camera/camera.dart';
import 'package:euchack/components/standard_scaffold.dart';
import 'package:euchack/constants/app_styles.dart';
import 'package:euchack/constants/colors.dart';
import 'package:euchack/providers/cam_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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

      print(imageFile.path);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isTakingPicture = false;
      });
    }
  }

  @override
  void dispose() {
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageTitle = "Scan Receipt";
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
              onPressed: takePictureAndSend,
              child: const Icon(Icons.camera_alt, size: 30, color: textColor),
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
            size: const Size(300, 395),
            alignment: Alignment.center,
            child: SizedBox(
              width: 300,
              height: 396,
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
