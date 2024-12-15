import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;

  AudioCubit() : super(AudioInitial());

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      final bool isPermissionGranted = await _recorder.hasPermission();
      if (!isPermissionGranted) {
        emit(AudioError('Permission not granted'));
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _filePath = '${directory.path}/$fileName';

      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      );

      await _recorder.start(config, path: _filePath!);
      emit(AudioRecording());
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  /// Stop recording audio
  Future<void> stopRecording() async {
    try {
      await _recorder.stop();
      emit(AudioStopped());
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  /// Play recorded audio
  Future<void> playRecording() async {
    if (_filePath != null) {
      try {
        await _audioPlayer.setFilePath(_filePath!);

        // Get the total duration
        _totalDuration = _audioPlayer.duration?.inSeconds.toDouble() ?? 0;
        await _audioPlayer.play();

        emit(AudioPlaying());

        // Continuously update the current position
        _audioPlayer.positionStream.listen((position) {
          _currentPosition = position.inSeconds.toDouble();
          emit(AudioPlayingPositionUpdated(_currentPosition));
        });

        // Visualize the waveform (Placeholder)
        await _updateWaveform();

      } catch (e) {
        emit(AudioError(e.toString()));
      }
    }
  }

  /// Pause audio playback
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    emit(AudioPaused());
  }

  /// Stop and reset audio playback
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    emit(AudioStoppedPlayback());
  }

  /// Dispose resources
  void dispose() {
    _recorder.dispose();
    _audioPlayer.dispose();
  }

  /// Placeholder method to visualize waveform
  Future<void> _updateWaveform() async {
    if (_filePath != null) {
      try {
        final audioFile = File(_filePath!);
        final bytes = await audioFile.readAsBytes();

        // Placeholder to process and visualize audio bytes
        // You can integrate a waveform visualization package here
        // like flutter_waveform or custom rendering.
        emit(AudioWaveformUpdated(bytes));

      } catch (e) {
        emit(AudioError('Unable to load waveform'));
      }
    }
  }
}
