import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US"); 
    await _flutterTts.setSpeechRate(0.5);   
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);        
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

final ttsProvider = Provider((ref) => TTSService());