// audio_state.dart
abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioRecording extends AudioState {}

class AudioStopped extends AudioState {
  final String? filePath;
  AudioStopped({this.filePath});
}

class AudioPlaying extends AudioState {}

class AudioPaused extends AudioState {}

class AudioFilePicked extends AudioState {
  final String path;
  AudioFilePicked(this.path);
}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
