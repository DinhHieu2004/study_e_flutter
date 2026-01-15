import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:web/web.dart' as web;

class AudioService {
  static final AudioPlayer _mobilePlayer = AudioPlayer();
  static web.HTMLAudioElement? _webAudio;

  static String _fixUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
  }

  static Future<void> play(String url) async {
    final fixedUrl = _fixUrl(url);

    if (kIsWeb) {
      try {
        _webAudio?.pause();
        _webAudio = web.HTMLAudioElement()
          ..src = fixedUrl
          ..autoplay = true
          ..load();
      } catch (e) {
        debugPrint('Web audio error: $e');
      }
    } else {
      // ===== MOBILE =====
      try {
        await _mobilePlayer.stop();
        await _mobilePlayer.play(UrlSource(fixedUrl));
      } catch (e) {
        debugPrint('Mobile audio error: $e');
      }
    }
  }

  static Future<void> stop() async {
    if (kIsWeb) {
      _webAudio?.pause();
    } else {
      await _mobilePlayer.stop();
    }
  }

  static void dispose() {
    if (kIsWeb) {
      _webAudio?.pause();
      _webAudio = null;
    } else {
      _mobilePlayer.dispose();
    }
  }
}
