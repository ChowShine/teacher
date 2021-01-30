import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videochat_package/constants/customMgr/screenMgr.dart';
import 'scan_dialog.dart';
import 'package:r_scan/src/r_scan_camera.dart';

List<RScanCameraDescription> rScanCameras;

class RScanCameraDialog extends StatefulWidget {
  @override
  _RScanCameraDialogState createState() => _RScanCameraDialogState();
}

class _RScanCameraDialogState extends State<RScanCameraDialog> {
  RScanCameraController _controller;
  bool isFirst = true;

  Future<bool> canOpenCameraView() async {
    var status =
    await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      return false;
    } else {
      return true;
    }
  }

  void initCamera() async {
    if (rScanCameras == null || rScanCameras.length == 0) {
      bool ret = await canOpenCameraView();
      if(ret){
        rScanCameras = await availableRScanCameras();
      }
    }
    if (rScanCameras != null && rScanCameras.length > 0) {
      _controller = RScanCameraController(
          rScanCameras[0], RScanCameraResolutionPreset.high)
        ..addListener(() {
          final result = _controller.result;
          if (result != null) {
            if (isFirst) {
              Navigator.of(context).pop(result);
              isFirst = false;
            }
          }
        })
        ..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rScanCameras == null || rScanCameras.length == 0) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('not have available camera'),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          ScanImageView(
            child: AspectRatio(
              aspectRatio: ScreenMgr.scrWidth/ScreenMgr.scrHeight,//_controller.value.aspectRatio,
              child: RScanCamera(_controller),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: FutureBuilder(
                future: getFlashMode(),
                builder: _buildFlashBtn,
              ))
        ],
      ),
    );
  }

  Future<bool> getFlashMode() async {
    bool isOpen = false;
    try {
      isOpen = await _controller.getFlashMode();
    } catch (_) {}
    return isOpen;
  }

  Widget _buildFlashBtn(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return snapshot.hasData
        ? Padding(
      padding: EdgeInsets.only(
          bottom: 24 + MediaQuery.of(context).padding.bottom),
      child: IconButton(
          icon: Icon(snapshot.data ? Icons.flash_on : Icons.flash_off),
          color: Colors.white,
          iconSize: 46,
          onPressed: () {
            if (snapshot.data) {
              _controller.setFlashMode(false);
            } else {
              _controller.setFlashMode(true);
            }
            setState(() {});
          }),
    )
        : Container();
  }
}
