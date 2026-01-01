import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechState {
  final bool isListening;
  final String recognizedText;
  final double soundLevel;

  SpeechState({
    this.isListening = false,
    this.recognizedText = "Chưa ghi âm",
    this.soundLevel = 0.0,
  });

  SpeechState copyWith({
    bool? isListening,
    String? recognizedText,
    double? soundLevel,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      soundLevel: soundLevel ?? this.soundLevel,
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState> {
  SpeechNotifier() : super(SpeechState());
  final SpeechToText _speech = SpeechToText();

  Future<void> startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      state = state.copyWith(isListening: true, recognizedText: "Đang nghe...");
      _speech.listen(
        onResult: (result) {
          state = state.copyWith(recognizedText: result.recognizedWords);
        },
        onSoundLevelChange: (level) =>
            state = state.copyWith(soundLevel: level),
        localeId: "en-US", 
      );
    }
  }
  

  Future<void> stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);
  }

  void resetSpeech() {
    state = state.copyWith(recognizedText: "");
  }

}

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((
  ref,
) {
  return SpeechNotifier();
});
