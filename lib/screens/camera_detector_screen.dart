import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import '../widgets/words/object_detector_painter.dart';

class CameraDetectorScreen extends StatefulWidget {
  const CameraDetectorScreen({super.key});

  @override
  State<CameraDetectorScreen> createState() => _CameraDetectorScreenState();
}

class _CameraDetectorScreenState extends State<CameraDetectorScreen> {
  CameraController? _controller;
  ObjectDetector? _objectDetector;
  bool _isBusy = false;
  List<DetectedObject> _objects = [];
  Map<String, dynamic> _dictionary = {};
  bool _isDetecting = false;
  bool _isDisposed = false; // Thêm flag này

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/dictionary.json',
      );
      _dictionary = json.decode(response);

      final cameras = await availableCameras();
      
      if (_isDisposed) return; // Kiểm tra trước khi khởi tạo
      
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      await _controller?.initialize();
      
      if (_isDisposed) {
        _controller?.dispose();
        return;
      }

      final options = ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);

      if (mounted) setState(() {});
      
      // Tự động bật nhận diện
      _isDetecting = true;
      _startContinuousDetection();
    } catch (e) {
      debugPrint("Lỗi khởi tạo: $e");
    }
  }

  Future<void> _startContinuousDetection() async {
    while (!_isDisposed && mounted && _controller != null) {
      if (_isDetecting && !_isBusy) {
        await _captureAndDetect();
      }
      await Future.delayed(const Duration(milliseconds: 800)); // Tăng thời gian delay
    }
  }

  Future<void> _captureAndDetect() async {
    // Kiểm tra kỹ trước khi chụp
    if (_isDisposed || 
        _isBusy || 
        _objectDetector == null || 
        _controller == null || 
        !_controller!.value.isInitialized) {
      return;
    }
    
    _isBusy = true;
    
    try {
      final XFile imageFile = await _controller!.takePicture();
      
      // Kiểm tra lại sau khi chụp xong
      if (_isDisposed) {
        await File(imageFile.path).delete();
        return;
      }
      
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final objects = await _objectDetector!.processImage(inputImage);
      
      // Xóa file ngay sau khi xử lý
      await File(imageFile.path).delete();
      
      if (mounted && !_isDisposed) {
        setState(() {
          _objects = objects;
        });
      }
      
    } catch (e) {
      debugPrint("Lỗi nhận diện: $e");
    } finally {
      _isBusy = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vật thể quanh ta"),
        actions: [
          IconButton(
            icon: Icon(_isDetecting ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _isDetecting = !_isDetecting;
              });
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          
          // Vẽ khung nhận diện
          if (_objects.isNotEmpty)
            CustomPaint(
              painter: ObjectDetectorPainter(
                _objects,
                Size(
                  _controller!.value.previewSize!.height,
                  _controller!.value.previewSize!.width,
                ),
                _dictionary,
              ),
            ),
          
          // Trạng thái
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isDetecting && !_isBusy)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    ),
                  if (_isDetecting && !_isBusy) const SizedBox(width: 8),
                  Text(
                    _isDetecting 
                      ? "Nhận diện: ${_objects.length} vật thể"
                      : "Tạm dừng",
                    style: TextStyle(
                      color: _isDetecting ? Colors.greenAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true; // Đánh dấu đã dispose
    _isDetecting = false; // Dừng nhận diện
    
    // Đợi một chút để đảm bảo vòng lặp dừng
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller?.dispose();
      _objectDetector?.close();
    });
    
    super.dispose();
  }
}