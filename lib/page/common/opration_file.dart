//文件 或 数据库操作

import 'dart:io';
import 'package:videochat_package/constants/customMgr/dirMgr.dart';
import 'common_param.dart';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';

class OperationFile {
  /*
  @param:name 文件名
   */
  static Future<List<String>> readFileAsLines(String name) async {
    final path = await DirMgr.getDir(DirType.en_DirAppDoc); //getTemporaryDirectory();
    File file = new File("${path.path}/$name.ini");
    print("读取文件路径：${file.path}");
    if (!await file.exists()) {
      return null;
    }

    List<String> lines = await file.readAsLines();
    return lines;
  }

  /*
  @function：
  @param：strContent 保存的内容
  @param:name 文件名
  @return：
  */
  static Future<void> saveFileAsLines(List<String> strContent, String name) async {
    assert(strContent != null && strContent.length > 0);
    //提示：pub中有ini库可以方便的对ini文件进行解析
    final _path = await DirMgr.getDir(DirType.en_DirAppDoc);
    File file = new File("${_path.path}/$name.ini");

    //如果文件存在，删除
    if (!await file.exists()) {
      //创建文件
      file = await file.create();
    }

    //直接调用File的writeAs函数时
    //默认文件打开方式为WRITE:如果文件存在，会将原来的内容覆盖
    //如果不存在，则创建文件
    String strTemp = "";
    for (int i = 0; i < strContent.length; i++) {
      strTemp += strContent[i] + "\n";
    }
    //写入String，默认将字符串以UTF8进行编码
    await file.writeAsString(strTemp /*, mode: FileMode.append*/);
  }
}

class OpDataBase {
  static openDataBase(String dbName) async {
    await gDB.createDb("$dbName");
  }

  //表名，以”tb_“+学生Id  如：tb_333
  static openTable(String tbName) async {
    bool isExist = await gDB.isTableExist(tbName);
    if (!isExist) {
      gDB.createTable(
          "CREATE TABLE IF NOT EXISTS $tbName (uuid TEXT PRIMARY KEY,strName TEXT,video TEXT,thumbnail TEXT,time TEXT,file TEXT,status TEXT,percent TEXT,size TEXT,done TEXT,expand TEXT, type TEXT, id TEXT, msg_id INTEGER, project_id INTEGER)");
    }
  }

  //sit 为VideoImgParam中的参数index，（数据库字段不能设为index）
  static insert2Table(String tbName, VideoImgParam param) async {
    //video,thumbnail字段设为"0"
    await gDB.add(
        "INSERT INTO $tbName(uuid,strName,video,thumbnail,time,file,status,percent,size,done,expand,type,id,msg_id,project_id) VALUES('${param.uuid}','${param.strName}','0','0','${param.time}','${param.file.path}','${param.status}','${param.percent}','${param.size}','${param.done}','${param.isExpand}','${param.type}','${param.id}',${param.nMsgId},${param.nProjectId})");
  }

  static Future<void> updateTable(VideoImgParam para) async {
    await gDB.update(
        "UPDATE tb_${para.id} SET time='${para.time}',file='${para.file.path}',status='${para.status}',percent='${para.percent}',size='${para.size}',done='${para.done}',expand='${para.isExpand}' WHERE uuid='${para.uuid}' ");
  }

  static Future<void> deleteTable(VideoImgParam para) async {
    await gDB.delete("DELETE FROM tb_${para.id} WHERE uuid='${para.uuid}'");
  }

  static tableCount() async {
    var ret = await gDB.tableCount();
    return ret ?? 0;
  }

  //获取数据库中所有表的名字
  static Future<List<Map<String, dynamic>>> tableName() async {
    var ret = await gDB.tableName();
    return ret;
  }

  /*
  @function：关闭数据库
  @return：
  */
  static close() async {
    await gDB.close();
  }

  /*
  @function：数据库是否打开
  @return： true打开 false关闭
  */
  static bool isOpen() {
    return gDB.isOpen();
  }

  /*
  @function：查询数据
  @return： 查询结果
  */
  static Future<List<Map>> query(String sql) async {
    return await gDB.query(sql);
  }

  //根据表名获取所有学生id列表，如tb_333，tb_222得到[333,222]
  //第一个是系统表
  static Future<List<int>> getAllStuId() async {
    List<int> stuId = [];
    int i = 0;
    List<Map<String, dynamic>> ret = await OpDataBase.tableName();
    ret.forEach((element) {
      if (i != 0) {
        String str = element["name"];
        String strTmp = str.substring(3, str.length);
        stuId.add(int.parse(strTmp));
      }
      i++;
    });
    return stuId;
  }

  static getVideoImgParam() async{
    g_lsAllSStuId.forEach((element) async {
      if (!mp_VideoImgParam.containsKey(element)) {
        mp_VideoImgParam[element] = [];
        List<Map<String, dynamic>> lsParam = await gDB.query('SELECT * FROM tb_$element');
        for (int i = 0; i < lsParam.length; i++) {
          Map<String, dynamic> map = {};
          lsParam[i].forEach((key, value) {
            map[key] = value;
          });
          mp_VideoImgParam[element].add(await parseParamFromDb(map));
        }
      }
    });
  }

  static Future<VideoImgParam> parseParamFromDb(Map<String, dynamic> mpParam) async {
    VideoImgParam param = new VideoImgParam();
    param.uuid = mpParam['uuid'];
    param.strName = mpParam['strName'];
    param.videoCtrl = null;
    param.thumbnail = null;
    param.time = int.parse(mpParam['time']);
    param.strAddress = mpParam['file'];
    if (mpParam['file'] == "")
      param.file = null;
    else
      param.file = File(mpParam['file']);
    param.status = mpParam['status'];
    param.percent = double.parse(mpParam['percent']);
    param.size = int.parse(mpParam['size']);
    param.done = int.parse(mpParam['done']);
    param.isExpand = mpParam['expand'] == "false" ? false : true;
    param.type = int.parse(mpParam['type']);
    param.id = int.parse(mpParam['id']);
    param.nMsgId = mpParam['msg_id'];
    param.bLocal = true;
    param.nProjectId = mpParam['project_id'];

    if (param.done == 0) {
      param.status = glsUploadStatus[enUploadStatus.UPLOAD_STATUS_FAILURE.index];
    }
    if (param.type == 1) {
      //视屏获取缩略图
      if (mpParam['file'] != "")
        param.thumbnail = await VideoThumbnail.thumbnailData(
          video: param.file.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth:
              128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
      else
        param.thumbnail = null;//Uint8List.fromList([0]);
    } else {
      if (mpParam['file'] != "")
        param.thumbnail = param.file.readAsBytesSync();
      else
        param.thumbnail = null;//Uint8List.fromList([0]);
    }
    return param;
  }
}
