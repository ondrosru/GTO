import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gtoserviceapp/components/widgets/dialogs/error_dialog.dart';
import 'package:gtoserviceapp/services/cameras/cameras.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final Function(Uint8List image) onPhotoTaken;

  CameraScreen({@required this.onPhotoTaken});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(Cameras.I.get(), ResolutionPreset.veryHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Камера"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.switch_camera),
            onPressed: _onSwitchPressed,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  void _onSwitchPressed() async {
    await controller?.dispose();
    controller = CameraController(Cameras.I.next(), ResolutionPreset.veryHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildPreview(),
        _buildOverlay(),
      ],
    );
  }

  Widget _buildPreview() {
    if (!controller.value.isInitialized) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: _buildTakePhotoButton(),
      ),
    );
  }

  RawMaterialButton _buildTakePhotoButton() {
    return RawMaterialButton(
      onPressed: _onTakePhotoButtonPressed,
      elevation: 2.0,
      fillColor: Colors.red,
      child: SizedBox(height: 32),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }

  void _onTakePhotoButtonPressed() async {
    _takePhoto().then((photo) {
      Navigator.of(context).pop();
      widget.onPhotoTaken(photo);
    });
  }

  Future<Uint8List> _takePhoto() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/gto_service/photos';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      showDialog(
        context: context,
        child: ErrorDialog.fromError(e),
      );
      return null;
    }

    var photo = await File(filePath).readAsBytes();
    File(filePath).delete();
    return photo;
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}
