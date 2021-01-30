//全局函数
import 'package:flutter/material.dart';
import 'package:teacher/page/common/opration_file.dart';
import 'package:videochat_package/constants/constants.dart';
import 'common_param.dart';
import 'dart:math' as math;
import 'dart:io';
import 'dart:typed_data';
import 'package:videochat_package/constants/customMgr/compressMgr.dart';
import 'package:video_compress/video_compress.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:tus_client/tus_client.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/customMgr/stringMgr.dart';
import 'package:videochat_package/constants/customMgr/fileMgr.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'dart:io';
import 'package:videochat_package/constants/customMgr/dirMgr.dart';
import 'package:videochat_package/constants/customMgr/fileMgr.dart';
import 'package:flutter_html/flutter_html.dart';
/*
@function：
@param1：
@param2:
@return：
*/
Widget func_buildNonData() {
  return Container(
    color: Colors.white,
    child: Center(
        child: Container(
      width: ScreenMgr.setAdapterSize(500.0),
      height: ScreenMgr.setAdapterSize(500.0),
      child: func_buildImageAsset("fs_list_null.png"),
    )),
  );
}

/*
@function：创建多个标签
@param1：
@param2:
@return：
*/
func_buildChip(List<String> lsChip) {
  if (lsChip == null || lsChip.isEmpty) return SizedBox();
  List<Widget> lsWidget = [];
  for (var ele in lsChip) {
    lsWidget.add(CusChip(
      ele,
      color: Color.fromARGB(255, 175, 193, 255),
    ));
    lsWidget.add(HSpacer(ScreenMgr.setAdapterSize(10.0)));
  }
  return Row(
    children: lsWidget,
  );
}

/*
@function：
@param1：
@param2:
@return：
*/

func_buildImageAsset(String strPath, {double dScale: 2.0, BoxFit fit}) {
  if (strPath == null || strPath.isEmpty) return Container();
  if (fit == null) {
    return Image.asset(
      "${Constants.strImagesDir}$strPath",
      scale: dScale,
    );
  } else {
    return Image.asset(
      "${Constants.strImagesDir}$strPath",
      scale: dScale,
      fit: fit,
    );
  }
}

/*
@function：根据图片和视频数目获取高度 最多9张
@param1：
@param2:
@return：
*/

func_getHeightFromPic(int picNum) {
  if (picNum == 0) {
    return ScreenMgr.setAdapterSize(0.0);
  } else if (picNum == 1) {
    return ScreenMgr.setAdapterSize(500.0);
  } else if (picNum > 1 && picNum <= 3) {
    return ScreenMgr.setAdapterSize(330.0);
  } else if (picNum > 3 && picNum <= 6) {
    return ScreenMgr.setAdapterSize(660.0);
  } else {
    return ScreenMgr.setAdapterSize(990.0);
  }
}

/*
@function：发布图片 和 附件时高度  最多12张
@param1：附件个数
@return：高度
*/
double func_PublishHeight(int picNum) {
  if (picNum == 0) {
    //一个添加图片
    return ScreenMgr.setAdapterSize(330.0);
  } else if (picNum >= 1 && picNum <= 2) {
    return ScreenMgr.setAdapterSize(330.0);
  } else if (picNum >= 3 && picNum <= 5) {
    return ScreenMgr.setAdapterSize(330.0 * 2);
  } else if (picNum >= 6 && picNum <= 8) {
    return ScreenMgr.setAdapterSize(330.0 * 3);
  } else if (picNum >= 9 && picNum <= 12) {
    return ScreenMgr.setAdapterSize(330.0 * 4);
  } else {
    return ScreenMgr.setAdapterSize(330.0 * 4);
  }
}

/*
@function：根据图片个数获取高度
@param1：
@param2:
@return：
*/
func_ShowPicHeight(int picNum) {
  if (picNum == 0) {
    return ScreenMgr.setAdapterSize(0.0);
  } else if (picNum == 1) {
    return ScreenMgr.setAdapterSize(500.0);
  } else if (picNum > 1 && picNum <= 3) {
    return ScreenMgr.setAdapterSize(330.0);
  } else if (picNum > 3 && picNum <= 6) {
    return ScreenMgr.setAdapterSize(660.0);
  } else {
    return ScreenMgr.setAdapterSize(990.0);
  }
}

Future<bool> func_showSimpleDialog(String str, BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(str ?? '确定清空此页面所有信息嘛?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                '确定',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        );
      });
}

/*
@function：转换日期 10月10日的格式
@param1：
@return：
*/

String transDateTime(DateTime dateTime) {
  int nYear = dateTime.year;
  int nMonth = dateTime.month;
  int nDate = dateTime.day;
  return "$nMonth月$nDate日";
}

/*
@function：
@param1：
@param2:
@return：
*/
matchImg(String input) {
  return StringMgr.matchImg(input);
}

matchVideo(String input) {
  return StringMgr.matchVideo(input);
}

String getFileName(File file) {
  return FileMgr().getFileName(file);
}

String getFileNameNoExt(File file) {
  return FileMgr().getFileNameNoExt(file);
}

Future<int> getFileSize(File file) async {
  return await FileMgr().getFileSize(file);
}

//压缩 视频 图片
Future<File> compressFile(File file) async {
  if (file == null || !file.existsSync()) return null;
  File fileCompress;
  if (matchImg(file.path)) {
    ImageCompressMgr imgCompress = new ImageCompressMgr(minWidth: 600, minHeight: 600, quality: 60);
    await imgCompress.compressFile2File(file).then((value) => fileCompress = value);
    print("-----压缩图片-----");
  } else if (matchVideo(file.path)) {
    VideoCompressMgr videoCompress = new VideoCompressMgr(videoQuality: VideoQuality.DefaultQuality);
    await videoCompress.compressFile2File(file).then((value) => fileCompress = value);
    print("-----压缩视频-----");
  }
  return fileCompress;
}

Future<VideoImgParam> getVideoImgFromAssetEntity(String strName, int id, AssetEntity asset_file,int nMsgId) async {
  if (!mp_VideoImgParam.containsKey(id)) mp_VideoImgParam[id] = new List();
  File file = await asset_file.file;
  VideoImgParam param;
  if (matchVideo(file.path)) {
    //保存缩略图和时间
    param = new VideoImgParam(
        strName: strName,
        id: id,
        uuid: Uuid().v1(),
        thumbnail: await asset_file.thumbData,
        time: asset_file.videoDuration.inSeconds,
        file: file,
        type: 1,
        nProjectId:gProjectInfo.nProjectId,
        nMsgId:nMsgId,
        strAddress:file.path,
        bLocal: true);
    mp_VideoImgParam[id].add(param);
  } else {
    //图片
    param = new VideoImgParam(
        strName: strName,
        id: id,
        uuid: Uuid().v1(),
        thumbnail: await asset_file.thumbData,
        file: file,
        type: 0,
        nProjectId:gProjectInfo.nProjectId,
        nMsgId:nMsgId,
        strAddress:file.path,
        bLocal: true);
    mp_VideoImgParam[id].add(param);
  }
  await OpDataBase.insert2Table("tb_$id", param);
  return param;
}

//布置作业也需要选择
Future<VideoImgParam> getVideoImgFromAssetEntityForHomework(AssetEntity asset_file) async {

  File file = await asset_file.file;
  VideoImgParam param;
  if (matchVideo(file.path)) {
    //保存缩略图和时间
    param = new VideoImgParam(
        strName: "",
        id: 0,
        uuid: Uuid().v1(),
        thumbnail: await asset_file.thumbData,
        time: asset_file.videoDuration.inSeconds,
        file: file,
        type: 1,
        nProjectId:gProjectInfo.nProjectId,
        nMsgId:0,
        strAddress:file.path,
        bLocal: true);
  } else {
    //图片
    param = new VideoImgParam(
        strName: "",
        id: 0,
        uuid: Uuid().v1(),
        thumbnail: await asset_file.thumbData,
        file: file,
        type: 0,
        nProjectId:gProjectInfo.nProjectId,
        nMsgId:0,
        strAddress:file.path,
        bLocal: true);
  }
  return param;
}

//时间转换 将秒转换为时：分:秒
String showVideoTime(int seconds) {
  int sec = seconds ?? 0;
  if (sec > 9999)
    return "00:${sec.toString().substring(0, 2)}";
  else if (sec > 999)
    return "00:0${sec.toString().substring(0, 1)}";
  else {
    var d = Duration(seconds: sec);
    List<String> parts = d.toString().split(':');
    if (parts[0] == "0")
      return '${parts[1]}:${parts[2].substring(0, 2)}';
    else
      return '${parts[0]}:${parts[1]}:${parts[2].substring(0, 2)}';
  }
}

//列表展开，收缩
class CusSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  CusSliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(CusSliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

// uploadReq(
//     Directory dir, File file, int stuId,int nProjectId,int nMsgId, dynamic Function() onComplete, dynamic Function(double) onProgress) async {
//   TusClient client = TusClient(Uri.parse("${gnNetType == 0 ? URL.API_ADD_TUS : URLIntranet.API_ADD_TUS}"), file,
//       store: TusFileStore(dir),
//       metadata: <String, String>{
//         "auth_token: ": "$g_strToken",
//         "callback_url": "http://127.0.0.2/callback",
//       },
//       headers: <String, String>{
//         "project-id": "$nProjectId",
//         "msg-id": "$nMsgId",
//         "token": "$g_strToken",
//         "student-id": "$stuId",
//         "receive-type": "2"
//       },
//       maxChunkSize: 2 * 1024 * 1024 //2M
//       );
//
//   await client.upload(
//     onComplete: onComplete,
//     onProgress: onProgress,
//   );
// }



Future<void> uploadOne(VideoImgParam param,void Function() onFinish) async{
  int studentId = param.id;
  if(studentId > 0 && mp_VideoImgParam.containsKey(studentId)){
    var item;
    for(int i = 0; i < mp_VideoImgParam[studentId].length;i++){
      if(mp_VideoImgParam[studentId][i].uuid == param.uuid){
        item = mp_VideoImgParam[studentId][i];
        break;
      }
    }
    if(item != null){
      var file = item.file;
      //压缩
      item.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_COMPRESS.index];
      Constants.eventBus.emit("UpdateUploadList", item);
      File fileCompress = await compressFile(file);

      //压缩完 状态变为 正在上传...
      item.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_DOING.index];
      Constants.eventBus.emit("UpdateUploadList", item); //上传列表刷新

      String strName = getFileNameNoExt(fileCompress);
      strName = strName.replaceAll(" ", "_");
      strName = strName.replaceAll("-", "_");
      File fileTus = await FileMgr().copyFileToTempDirExt(fileCompress, strName: strName);

      Directory dr = await DirMgr.getDir(DirType.en_DirTemp);
      dr = Directory(dr.path + "/" + strName);
      item.size = await FileMgr().getFileSize(fileCompress);
      item.file = fileCompress; //保存压缩后的文件
      dynamic Function() onComplete = () async {
        Constants.log.v("Completed!");
        final f = File(fileTus.path);
        await f?.delete();
        item.percent = 100.0;
        item.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_SUCCESS.index];
        item.done = 1;
        await OpDataBase.deleteTable(item); //更新数据库
        //mp_VideoImgParam[studentId].removeAt(item);
        for(int i = 0; i < mp_VideoImgParam[studentId].length;i++){
          if(mp_VideoImgParam[studentId][i].uuid == param.uuid){
            mp_VideoImgParam[studentId].removeAt(i);
            break;
          }
        }
        Constants.eventBus.emit("UpdateUploadList", item); //上传列表刷新
        Constants.eventBus.emit("refreshImageVideo", true); //转圈刷新
      };

      dynamic Function(double) onProgress = (progress) async {
        Constants.log.v("Progress: $progress");
        item.percent = double.parse(progress.toStringAsFixed(1));
        await OpDataBase.updateTable(item); //更新数据库
        Constants.eventBus.emit("UpdateUploadList", item); //上传列表刷新
      };
      try {
        item.setTusClient(dr, fileTus, studentId, param.nProjectId,param.nMsgId);
        await item.upload(onComplete, onProgress);
        onFinish();
        Constants.eventBus.emit("UpdateUploadList", item); //上传列表刷新
        Constants.eventBus.emit("refreshImageVideo", true); //转圈刷新
      } catch (e) {
        item.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index];
        await OpDataBase.updateTable(item); //更新数据库
        Constants.eventBus.emit("UpdateUploadList", item); //上传列表刷新
        Constants.eventBus.emit("refreshImageVideo", true); //转圈刷新
      }
    }
  }
  else assert(false);
}

parseVersion(String version) {
  int ver = 0;
  ver = int.parse(version.replaceAll('.', ''));
  return ver;
}

/*
@function：显示html
@param1：html内容
@return：
*/
showHtmlView(String strHtml) {
  return Container(
    alignment: Alignment.centerLeft,
    width: ScreenMgr.scrWidth * 0.75,
    child: Html(
      data: strHtml,
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      blockSpacing: 0.0,
      shrinkToFit: true,
      onLinkTap: (url) {
        // open url in a webview
      },
      onImageTap: (src) {
        // Display the image in large form.
      },
      customRender: (node, children) {},
    ),
  );
}