/////////////////////////////////////////////////
//全局参数
import "package:flutter/material.dart";
import 'package:tus_client/tus_client.dart';
import 'package:video_player/video_player.dart';
import 'package:videochat_package/constants/customMgr/dbMgr.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'dart:io';
import '../provider/upload_provider.dart';
import 'dart:typed_data';
import 'package:cached_video_player/cached_video_player.dart';

const String VERSION = "version";
const String DOWNLAOD_URL = "downLoadUrl";

const int MAX_IAMGE_VIDEO = 12; //最大图片和视频数

final  String IMAGE_VIDEO_URL = "${gnNetType == 0 ? URL.API_ADD_UPLOAD : URLIntranet.API_ADD_UPLOAD}"; //用于拼接已有的视频或图片的网络地址

class CusFontSize {
  static final double size_12 = 12.0;
  static final double size_13 = 13.0;
  static final double size_14 = 14.0;
  static final double size_15 = 15.0;
  static final double size_16 = 16.0;
  static final double size_17 = 17.0;
  static final double size_18 = 18.0;
  static final double size_19 = 19.0;
  static final double size_20 = 20.0;
}

class CusColorGrey {
  static final Color grey100 = Colors.grey[100];
  static final Color grey200 = Colors.grey[200];
  static final Color grey300 = Colors.grey[300];
  static final Color grey400 = Colors.grey[400];
  static final Color grey500 = Colors.grey[500];
}

/////////////////////////////////////////////////
int gnNetType = 0; //网络类型 外网 内网

/////////////////////////////////////////////////
//课程信息
class ProjectInfo {
  int nProjectId = 0;
  int nSubjectId = 0;
  int nStationId = 0;
  int nLearnCardId = 0;
  String projectsName; //计算小能手
  String stationName;
  String learnCardName; //数学学习场
  String semesterName; //二年级绿色评测
  ProjectInfo(this.projectsName, this.stationName, this.learnCardName, this.semesterName);
}

ProjectInfo gProjectInfo = new ProjectInfo("", "", "", "");

/////////////////////////////////////////////////
String g_strTeacherName = ""; //登录名
String g_strToken; //token

const Color themeColor = Color(0xff00bc56);

//上传列表全局 状态管理
UpLoadProvider gUploadProvider = new UpLoadProvider();

class CacheVideoPlayerWidget extends StatefulWidget {
  CacheVideoPlayerWidget(this.key, this.url, this.cbSetState) : super(key: key);
  final String url;
  final void Function() cbSetState; //回调
  final Key key;
  @override
  CacheVideoPlayerWidgetState createState() => CacheVideoPlayerWidgetState();
}

class CacheVideoPlayerWidgetState extends State<CacheVideoPlayerWidget> {
  VideoPlayerController controller;
  @override
  void initState() {
    super.initState();

    controller ??= VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //widget.second = _controller.value.duration.inSeconds;
        g_videotime[widget.url] = controller.value.duration.inSeconds;
        //Constants.eventBus.emit("refreshImageVideo", true); //转圈刷新
        setState(() {});

        widget.cbSetState();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:controller.value.initialized
              ? AspectRatio(
                  aspectRatio: 1.0, //_controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                )
              : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}

enum enUploadStatus {
  UPLOAD_STATUS_WAIT,
  UPLOAD_STATUS_COMPRESS,
  UPLOAD_STATUS_DOING,
  UPLOAD_STATUS_SUCCESS,
  UPLOAD_STATUS_FAILURE,
  UPLOAD_STATUS_CANCEL,
}

List<String> glsUploadStatus = ["等待上传...", "正在压缩...", "正在上传...", "上传成功", "上传失败！", "已取消上传！"];

const double COMPLETE_PERCENT = 100.0;

//视频 图片一些参数
class VideoImgParam {
  String strName; //学生姓名
  int id; //学生id
  String uuid; //某个学生录入详情中，在所有视频图片中的索引
  CacheVideoPlayerWidget videoCtrl; //文件视频播放controller
  Uint8List thumbnail; //文件缩略图
  int time; //视频播放时间
  File file; //文件
  String status; //文件传输状态
  double percent; //文件传输进度
  int size; //文件大小
  int done; //是否完成 0未完成 1完成
  bool isExpand;
  int type; //0图片 1视频
  int nProjectId;
  int nMsgId;
  String strAddress;
  bool bLocal;
  TusClient tusClient;
  VideoImgParam(
      {this.strName,
      this.id,
      this.uuid,
      this.videoCtrl,
      this.thumbnail,
      this.time = 0,
      this.file,
      this.status = "等待上传...",
      this.percent = 0.1,
      this.size = 0,
      this.done = 0,
      this.isExpand = true,
      this.type,
      this.nProjectId,
      this.nMsgId,
      this.strAddress,
      this.bLocal});

  void setTusClient(Directory dir, File file, int stuId, int projectId, int msgId) {
    this.tusClient = new TusClient(Uri.parse("${gnNetType == 0 ? URL.API_ADD_TUS : URLIntranet.API_ADD_TUS}"), file,
        store: TusFileStore(dir),
        metadata: <String, String>{
          "auth_token: ": "$g_strToken",
          "callback_url": "http://127.0.0.2/callback",
        },
        headers: <String, String>{
          "project-id": "$projectId",
          "msg-id": "$msgId",
          "token": "$g_strToken",
          "student-id": "$stuId",
          "receive-type": "2"
        },
        maxChunkSize: 2 * 1024 * 1024 //2M
        );
  }

  Future<void> upload(dynamic Function() onComplete, dynamic Function(double) onProgress) async {
    if (this.tusClient != null) {
      await this.tusClient.upload(
            onComplete: onComplete,
            onProgress: onProgress,
          );
    }
  }

  void cancelUpload() {
    if (this.tusClient != null) {
      this.tusClient.pause();
    }
  }
}

Map<int, List<VideoImgParam>> mp_VideoImgParam = {}; //key:学生id（具有唯一性）
List<VideoImgParam> g_lsSave = []; //上传队列

List<int> g_lsAllSStuId = [];
Map<String, int> g_videotime = {};
DbMgr gDB = new DbMgr();

String g_strVer = "0.0.1";
