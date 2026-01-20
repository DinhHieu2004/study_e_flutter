import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/detected_provider.dart';

class CameraDetectorScreen extends ConsumerStatefulWidget {
  const CameraDetectorScreen({super.key});

  @override
  ConsumerState<CameraDetectorScreen> createState() =>
      _CameraDetectorScreenState();
}

class _CameraDetectorScreenState extends ConsumerState<CameraDetectorScreen> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller?.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Lỗi khởi tạo Camera: $e");
    }
  }

  Future<void> _onCapturePressed() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile imageFile = await _controller!.takePicture();

      await _controller!.pausePreview();

      await ref
          .read(geminiProvider.notifier)
          .identifyImage(File(imageFile.path));

      final state = ref.read(geminiProvider);

      if (state.word != null && mounted) {
        _showResultSheet(context, state.word!);
      } else if (state.error != null) {
        await _controller!.resumePreview();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error!)));
      }

      await File(imageFile.path).delete();
    } catch (e) {
      debugPrint("Lỗi xử lý: $e");
    }
  }

  void _showResultSheet(BuildContext context, dynamic word) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              word.en.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              word.ipa,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Divider(height: 30),
            Text(word.vn, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _controller!.resumePreview();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Tiếp tục chụp"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final geminiState = ref.watch(geminiProvider);

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhận diện vật thể AI"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          if (geminiState.loading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      "AI đang phân tích ảnh...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: geminiState.loading ? null : _onCapturePressed,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
