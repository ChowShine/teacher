import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

enum en_AudioType {
  AUDIO_TYPE_LOCAL, //本地
  AUDIO_TYPE_URL, //网络URL
  AUDIO_TYPE_BYTE, //字节
}

class AudioPalyerMgr {
  AudioPlayer _audioPlayer;

  final en_AudioType type; //语音来类型
  final String strAddr; //语音地址


  AudioPalyerMgr(this.type, this.strAddr) {
    assert(strAddr != null && strAddr.isNotEmpty);
    _audioPlayer = AudioPlayer();
  }

  onPlayerStateChangedListen(Function(AudioPlayerState s) f) {
    _audioPlayer.onPlayerStateChanged.listen(f);
  }

  onDurationChangedListen(Function(Duration d) f) {
    _audioPlayer.onDurationChanged.listen(f);
  }

  Future<bool> play() async {
    int result = 0;
    switch (type) {
      case en_AudioType.AUDIO_TYPE_LOCAL:
        result = await _audioPlayer.play(strAddr, isLocal: true);
        break;
      case en_AudioType.AUDIO_TYPE_URL:
        result = await _audioPlayer.play(strAddr);
        break;
      case en_AudioType.AUDIO_TYPE_BYTE:
        Uint8List byteData = File(strAddr).readAsBytesSync();
        result = await _audioPlayer.playBytes(byteData);
        break;
      default:
        break;
    }
    return result == 1 ? true : false;
  }

  Future<bool> pause() async {
    int result = await _audioPlayer.pause();
    return result == 1 ? true : false;
  }

  Future<bool> stop() async {
    int result = await _audioPlayer.stop();
    return result == 1 ? true : false;
  }

  dispose() {
    _audioPlayer.dispose();
  }
}
