library  audio.record;//录制语音
import 'package:flutter_plugin_record/const/response.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';

class AudioRecordMgr{

  FlutterPluginRecord record ;

  AudioRecordMgr(){
    record ??= FlutterPluginRecord();
  }

  responseListen(void Function(RecordResponse response) f){
    record.response.listen(f);
  }

  ///语音录制初始化
  Future<void> init() async{
    record.initRecordMp3();
  }

  ///开始语音录制的方法
  Future<void> start() async {
    await record.start();
  }

  ///停止语音录制的方法
  Future<void> stop() async{
    await record.stop();
  }

  dispose(){
    record.dispose();
  }
}