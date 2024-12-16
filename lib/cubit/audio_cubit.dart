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

  Future<void> stopRecording() async {
    final path = await recorderController.stop(); // Ensure this returns a valid path
    if (path != null) {
      playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true, // Extract waveform data
      );
      emit(AudioStopped());
    }
  }


  /// Play recorded audio
  bool _isPlaying = false;  // Playback holatini saqlash uchun private variable

// AudioCubit.dart
  Future<void> playRecording() async {
    if (path == null) {
      emit(AudioError("Fayl yo‘q: Path qiymati null"));
      return;
    }

    if (!File(path!).existsSync()) {
      emit(AudioError("Fayl mavjud emas: $path"));
      return;
    }

    try {
      await playerController.preparePlayer(path: path!);
      await playerController.startPlayer();
      _isPlaying = true;
      emit(AudioPlaying());
      print("Audio o‘ynatilmoqda");
    } catch (err) {
      emit(AudioError(err.toString()));
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
  /// Delete recorded audio file
  Future<void> deleteRecording() async {
    if (path == null) {
      emit(AudioError("Fayl yo‘q: Path qiymati null"));
      return;
    }

    try {
      final audioFile = File(path!);
      if (await audioFile.exists()) {
        await audioFile.delete();  // Faylni o‘chirish
        path = null;  // path ni null ga qo‘ying
        emit(AudioDeleted());  // UI ga notification yuboring
        print("Audio fayli o‘chirildi.");
      } else {
        emit(AudioError("Fayl topilmadi"));
      }
    } catch (e) {
      emit(AudioError('Failed to delete recording: $e'));
    }
  }

}
