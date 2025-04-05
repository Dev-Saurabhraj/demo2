import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:http/http.dart' as http;

class PoseDetectorScreen extends StatefulWidget {
  @override
  _PoseDetectorScreenState createState() => _PoseDetectorScreenState();
}

class _PoseDetectorScreenState extends State<PoseDetectorScreen> {
  late CameraController _cameraController;
  late PoseDetector _poseDetector;
  Pose? _lastPose;
  bool _isDetecting = false;
  bool _cameraInitialized = false;
  String _result = '';

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first; // Rear camera
    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();
    await _cameraController.startImageStream(_processCameraImage);
    setState(() {
      _cameraInitialized = true;
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final poses = await _poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final keypoints = pose.landmarks.values.expand((landmark) => [
          landmark.x,
          landmark.y,
          landmark.z ?? 0.0,
        ]).toList();

        setState(() {
          _lastPose = pose;
        });

        if (keypoints.length == 132) {
          await _sendToServer(keypoints);
        }
      }
    } catch (e) {
      print("Pose Detection Error: $e");
    }

    _isDetecting = false;
  }

  Future<void> _sendToServer(List<double> keypoints) async {
    final url = Uri.parse('http://10.87.81.31:5000/predict'); // Replace <your-ip>
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'keypoints': keypoints}),
      );

      if (response.statusCode == 200) {
        print("Server Response: ${response.body}");
        setState(() {
          _result = json.decode(response.body)['result'];
        });
      } else {
        print("Server Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("HTTP Error: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Pose Detector")),
      body: _cameraInitialized
          ? Stack(
        children: [
          CameraPreview(_cameraController),
          if (_lastPose != null)
            CustomPaint(
              painter: PosePainter(
                _lastPose!,
                _cameraController.value.previewSize!,
              ),
              child: Container(),
            ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Prediction: $_result",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;

  PosePainter(this.pose, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint jointPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final Paint bonePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final double scaleX = size.width / imageSize.height;
    final double scaleY = size.height / imageSize.width;

    Map<PoseLandmarkType, Offset> landmarkMap = {};

    for (final entry in pose.landmarks.entries) {
      final landmark = entry.value;
      final x = landmark.y * scaleX;
      final y = landmark.x * scaleY;
      final offset = Offset(x, y);
      landmarkMap[entry.key] = offset;
      canvas.drawCircle(offset, 4, jointPaint);
    }

    void connect(PoseLandmarkType a, PoseLandmarkType b) {
      if (landmarkMap[a] != null && landmarkMap[b] != null) {
        canvas.drawLine(landmarkMap[a]!, landmarkMap[b]!, bonePaint);
      }
    }

    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    connect(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    connect(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    connect(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    connect(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    connect(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    connect(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    connect(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    connect(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    connect(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    connect(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
