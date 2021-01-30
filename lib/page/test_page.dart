/*import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/common_param.dart';
import 'package:tus_client/tus_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videochat_package/constants/customMgr/spMgr.dart';

class TusUploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<TusUploadPage> {
  double _progress = 0;
  File _file;
  TusClient _client;
  Uri _fileUrl;
  TusHttp tusHttp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TUS Client Upload Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                "This demo uses TUS client to upload a file",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                color: Colors.teal,
                child: InkWell(
                  onTap: () async {
                    _file = await _copyToTemp(await FilePicker.getFile());
                    setState(() {
                      _progress = 0;
                      _fileUrl = null;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.cloud_upload, color: Colors.white, size: 60),
                        Text(
                          "Upload a file",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: _file == null
                          ? null
                          : () async {
                              // Create a client
                              if (g_strToken == null) {
                                SpMgr sp = await SpMgr.getInstance();
                                g_strToken = sp.getString("SP_TOKEN");
                              }
                              print("-----token的值-----：$g_strToken");
                              print("Create a client");
                              _client = TusClient(Uri.parse("https://test.ntyirong.com/api/test/tus_port"), _file,
                                  store: TusFileStore(await getTemporaryDirectory()),
                                  metadata: <String, String>{
                                    "auth_token: ": "$g_strToken",
                                    "callback_url": "http://127.0.0.2/callback",
                                  },
                                  headers: <String, String>{"msg_id": "222", "project_id": "222"},
                                  maxChunkSize: 2 * 1024 * 1024 //2M
                                  );

                              print("Starting upload");
                              await _client.upload(
                                onComplete: () async {
                                  print("Completed!");
                                  await _clearFromTemp();
                                  setState(() => _fileUrl = _client.uploadUrl);
                                },
                                onProgress: (progress) {
                                  print("Progress: $progress");
                                  setState(() => _progress = progress);
                                },
                              );
                            },
                      child: Text("Upload"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: RaisedButton(
                      onPressed: _progress == 0
                          ? null
                          : () async {
                              _client.pause();
                            },
                      child: Text("Pause"),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  color: Colors.grey,
                  width: double.infinity,
                  child: Text(" "),
                ),
                FractionallySizedBox(
                  widthFactor: _progress / 100,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(1),
                    color: Colors.green,
                    child: Text(" "),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  width: double.infinity,
                  child: Text("Progress: ${_progress.toStringAsFixed(1)}%"),
                ),
              ],
            ),
            GestureDetector(
              onTap: _progress != 100
                  ? null
                  : () async {
                      await launch(_fileUrl.toString());
                    },
              child: Container(
                color: _progress == 100 ? Colors.green : Colors.grey,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: Text(_progress == 100 ? "Link to view:\n ${_fileUrl}" : "-"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Copy file to temporary directory before uploading
  Future<File> _copyToTemp(File chosenFile) async {
    if (chosenFile != null) {
      final tempDir = await getTemporaryDirectory();
      String newPath = join(tempDir.path, basename(chosenFile.path));
      print("Chosen file: ${chosenFile.path}");
      print("Temp file: $newPath");
      return await chosenFile.copy(newPath);
      // return XFile(newPath);
    }
    return null;
  }

  /// clear file from temporary directory after uploading
  _clearFromTemp() async {
    final f = File(_file.path);
    await f?.delete();
    setState(() => _file = null);
  }
}

class TusHttp {
  TusClient _tusClient;
  Uri fileUrl = Uri();
  double dProgress = 0.0;

  final String strUrl;
  final String strToken;
  File file;
  dynamic Function(double) cbProgress;
  TusHttp(this.strUrl, this.file, {this.strToken = "false", this.cbProgress});

  Future<TusClient> _init() async {
    int fileSize = await getFileSize(file);
    int chunkSize = 0;
    if (fileSize > 0 && fileSize < 4 * 1024 * 1024) {
      chunkSize = 512 * 1024;
    } else if (fileSize >= 4 * 1024 * 1024 && fileSize < 10 * 1024 * 1024) {
      chunkSize = 1 * 1024 * 1024;
    } else if (fileSize >= 10 * 1024 * 1024 && fileSize < 20 * 1024 * 1024) {
      chunkSize = 5 * 1024 * 1024;
    } else {
      chunkSize = 2 * 1024 * 1024;
    }

    File fileTmp = await _copyToTemp(this.file);
    _tusClient = TusClient(Uri.parse(strUrl), fileTmp,
        store: TusFileStore(await getTemporaryDirectory()),
        metadata: <String, String>{
          "auth_token: ": strToken,
          "callback_url": "http://127.0.0.1/callback",
        },
        maxChunkSize: 2 * 1024 * 1024 //单个上传块大小2M
        );
    return _tusClient;
  }

  Future<TusClient> getClient() async {
    return await _init();
  }

  Future<dynamic> upLoadFile() async {
    return await _tusClient.upload(
        */ /*    onComplete: () async {
        print("Completed!");
        await _clearFromTemp();
        fileUrl = _tusClient.uploadUrl;
      },*/ /*
*/ /*      onProgress:  (progress) {
        print("Progress: $progress");
       dProgress = progress;
      },*/ /*
        );
  }

  /// Copy file to temporary directory before uploading
  Future<File> _copyToTemp(File chosenFile) async {
    if (chosenFile != null) {
      final tempDir = await getTemporaryDirectory();
      String newPath = join(tempDir.path, basename(chosenFile.path));
      print("Chosen file: ${chosenFile.path}");
      print("Temp file: $newPath");
      return await chosenFile.copy(newPath);
      // return XFile(newPath);
    }
    return null;
  }

  /// clear file from temporary directory after uploading
  _clearFromTemp() async {
    final f = File(this.file.path);
    await f?.delete();
    file = null;
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/index.dart';

class WeChatRecordScreen extends StatefulWidget {
  @override
  _WeChatRecordScreenState createState() => _WeChatRecordScreenState();
}

class _WeChatRecordScreenState extends State<WeChatRecordScreen> {
  String toastShow = "悬浮框";
  OverlayEntry overlayEntry;

  showView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("仿微信发送语音"),
      ),
      body: Center(
        child:
            new VoiceWidget(
              startRecord: startRecord,
              stopRecord: stopRecord,
              // 加入定制化Container的相关属性
              height: 40.0,
            ),

      ),
    );
  }
}