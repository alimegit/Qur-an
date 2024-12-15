import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloc/bloc.dart';
import 'package:learn_quran/cubit/audio_state.dart';
import 'package:path_provider/path_provider.dart';

class AudioCubit extends Cubit<AudioState> {
  late final RecorderController recorderController;
  late final PlayerController playerController;
  String? path;
  bool isRecording = false;

  AudioCubit() : super(AudioInitial()) {
    _initializeControllers();
  }

  void _initializeControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    playerController = PlayerController();
  }

  /// Start recording audio
  Future<void> startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      path = "${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await recorderController.record(path: path);
      isRecording = true;
      emit(AudioRecording());
    } catch (e) {
      emit(AudioError('Failed to start recording: $e'));
    }
  }

  /// Stop recording audio
  Future<void> stopRecording() async {
    try {
      await recorderController.stop();
      isRecording = false;
      emit(AudioStopped(filePath: path));
    } catch (e) {
      emit(AudioError('Failed to stop recording: $e'));
    }
  }

  /// Play recorded audio
  bool _isPlaying = false;  // Playback holatini saqlash uchun private variable

// AudioCubit.dart
  Future<void> playRecording() async {
    if (path != null && File(path!).existsSync()) {
      try {
        await playerController.preparePlayer(path: path!);
        await playerController.startPlayer();

        _isPlaying = true;
        emit(AudioPlaying());  // UI-ni yangilash

        playerController.addListener(() {
          emit(AudioPlaying());  // Replay uchun listener orqali yangilang
        });
      } catch (err) {
        emit(AudioError(err.toString()));
      }
    }
  }



  /// Pause playback
  Future<void> pauseAudio() async {
    await playerController.pausePlayer();
    emit(AudioPaused());
  }

  /// Refresh UI recording components
  void refreshWave() {
    if (isRecording) recorderController.refresh();
  }
}
