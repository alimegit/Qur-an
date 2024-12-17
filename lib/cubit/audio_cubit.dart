import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bloc/bloc.dart';
import 'package:learn_quran/cubit/audio_state.dart';
import 'package:learn_quran/services/storage_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class AudioCubit extends Cubit<AudioState> {
  late final RecorderController recorderController;
  late final PlayerController playerController;
  String? path;
  bool isRecording = false;
  bool _isPlaying = false;
  StreamSubscription? _playerSubscription;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  late Timer _timer;

  List<String> savedAudioPaths = [];

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

  Future<void> startRecording() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      path = "${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await recorderController.record(path: path);
      isRecording = true;
      _startRecordingTimer();
      emit(AudioRecording());
    } catch (e) {
      emit(AudioError('Failed to start recording: $e'));
    }
  }

  Future<void> stopRecording() async {
    await recorderController.stop();
    _stopTimer();
    emit(AudioStopped());
  }

  Future<void> sendRecording() async {
 emit(AudioInitial());
  }

  Future<void> playRecording() async {
    if (path == null || !File(path!).existsSync()) {
      emit(AudioError(path == null
          ? "Fayl yo‘q: Path qiymati null"
          : "Fayl mavjud emas: $path"));
      return;
    }
    try {
      await playerController.preparePlayer(path: path!);
      await playerController.startPlayer();
      _isPlaying = true;
      _startPlaybackTimer();
      emit(AudioPlaying());
      _playerSubscription?.cancel();
      _playerSubscription = playerController.onCompletion.listen((event) {
        _onPlaybackComplete();
      });
    } catch (err) {
      emit(AudioError(err.toString()));
    }
  }

  Future<void> pauseAudio() async {
    await playerController.pausePlayer();
    _stopTimer();
    emit(AudioPaused());
  }

  Future<void> deleteRecording() async {
    if (path == null) {
      emit(AudioError("Fayl yo‘q: Path qiymati null"));
      return;
    }
    try {
      final audioFile = File(path!);
      if (await audioFile.exists()) {
        await audioFile.delete();
        path = null;
        emit(AudioStopped());
        emit(AudioDeleted());
        _playbackDuration = Duration.zero;
        _recordingDuration = Duration.zero;
        print("Audio fayli o'chirildi.");
      } else {
        emit(AudioError("Fayl topilmadi: $path"));
      }
    } catch (e) {
      emit(AudioError('Failed to delete recording: $e'));
    }
  }

  void _onPlaybackComplete() {
    _isPlaying = false;
    _stopTimer();
    emit(AudioStopped());
  }

  void _startRecordingTimer() {
    _recordingDuration = Duration.zero;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _recordingDuration += const Duration(milliseconds: 100);
      emit(AudioRecording());
    });
  }

  void _startPlaybackTimer() {
    _playbackDuration = Duration.zero;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _playbackDuration += const Duration(milliseconds: 100);
      emit(AudioPlaying());
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<String> saveAudioToStorage(String path) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = "recording_${DateTime.now().millisecondsSinceEpoch}.m4a";
      final newPath = "${directory.path}/$fileName";
      final recordedFile = File(path);

      if (await recordedFile.exists()) {
        final newFile = await recordedFile.copy(newPath);

        // Audio faylini ro'yxatga qo'shish
        final audioList = StorageRepository.getList('audioPaths').toList();
        audioList.add(newFile.path);
        await StorageRepository.putList('audioPaths', audioList);

        return newPath;
      } else {
        throw Exception("Original audio fayli mavjud emas.");
      }
    } catch (e) {
      throw Exception('Audio faylini saqlashda xatolik yuz berdi: $e');
    }
  }
  List<String> getSavedAudioPaths() {
    return savedAudioPaths;
  }

  String getFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = (duration.inMilliseconds.remainder(1000) ~/ 100);
    return "$minutes:$seconds.$milliseconds";
  }

  String get recordingDurationFormatted => getFormattedDuration(_recordingDuration);
  String get playbackDurationFormatted => getFormattedDuration(_playbackDuration);
  Duration get recordingDuration => _recordingDuration;
  Duration get playbackDuration => _playbackDuration;

  @override
  Future<void> close() {
    _playerSubscription?.cancel();
    _timer.cancel();
    return super.close();
  }
}