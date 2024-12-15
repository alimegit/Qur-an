// Define the abstract base class for AudioState
abstract class AudioState {}

// Initial state when nothing happens yet
class AudioInitial extends AudioState {}

// State when audio recording starts
class AudioRecording extends AudioState {}

// State when audio recording stops
class AudioStopped extends AudioState {}

// State when audio is playing
class AudioPlaying extends AudioState {}

// State when audio playback is paused
class AudioPaused extends AudioState {}

// State for any errors that occur during recording or playback
class AudioError extends AudioState {
  final String message;

  AudioError(this.message);
}

// State to visualize audio waveform updates
class AudioWaveformUpdated extends AudioState {
  final List<int> waveformBytes;

  AudioWaveformUpdated(this.waveformBytes);
}
class AudioStoppedPlayback extends AudioState {}
class AudioPlayingPositionUpdated extends AudioState {
  final double positionInSeconds;

  AudioPlayingPositionUpdated(this.positionInSeconds);
}
