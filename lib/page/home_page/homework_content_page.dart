//作业内容

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:teacher/page/common/common_func.dart';
import 'package:teacher/page/common/common_param.dart';
import 'package:teacher/page/common/full_play.dart';
import 'package:videochat_package/constants/customMgr/screenMgr.dart';
import 'package:videochat_package/constants/customMgr/widgetMgr.dart';
import 'package:videochat_package/constants/photo_view_gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'select_subject_page.dart';
import 'select_student_page.dart';
import 'package:provider/provider.dart';
import '../provider/grade_class_provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/grade_class_model.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:oktoast/oktoast.dart';

class HomeWorkContentPage extends StatefulWidget {
  @override
  _HomeWorkContentPageState createState() => _HomeWorkContentPageState();
}

class _HomeWorkContentPageState extends State<HomeWorkContentPage> {
  final TextEditingController _titleController = new TextEditingController(); //标题
  final TextEditingController _contentController = new TextEditingController(); //标题
  int nFileNum = 0; //文件数量
  String strTime = ""; //显示的截至日期
  final weekDay = ["一", "二", "三", "四", "五", "六", "日"];
  GradeClassProvider provider = GradeClassProvider();
  List<String> lsSubject = []; //学科
  Map<String, List<String>> mpGradeClassStu = {}; //key：一年级一班，value：学生列表
  Map<String, List<String>> mpGradeClassHead = {}; //key：一年级一班，value：学生头像列表
  Map<String, List<String>> mpSubjectGradeClase = {}; //key：学科 对应 value：班级列表
  String strSelectSub = ""; //选择的科目，接口需要的参数
  List<String> lsHaveSelGrade = []; //已经选择的班级 一年级1班
  List<String> lsSelectGradeClass = []; //点击选择的年级班级[1-1,1-2]，接口需要的参数
  String strSelTime = ""; //选择的时间，接口需要的参数

  List<AssetEntity> assets = []; //选择的文件
  List<VideoImgParam> _lsVideoImg = []; //文件列表

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      await this.provider.getGradeClassSubStuReq();
      //将学科保存
      var lsSubjectTemp = this.provider.instance?.data?.subjectClass ?? [];
      if (lsSubjectTemp.isNotEmpty) {
        this.provider.instance.data.subjectClass.forEach((element) {
          lsSubject.add(element.subjectName);
          mpSubjectGradeClase[element.subjectName] = [];
          element.gradeClass.forEach((ele) {
            mpSubjectGradeClase[element.subjectName].add(ele.gradeClass);
          });
        });
      }
      //将班级人数保存
      var ls_grade_class = this.provider.instance?.data?.gradeClass ?? [];
      if (ls_grade_class.isNotEmpty) {
        this.provider.instance.data.gradeClass.forEach((element) {
          mpGradeClassStu[element.gradeClass] = [];
          mpGradeClassHead[element.gradeClass] = [];
          element.students.forEach((ele) {
            mpGradeClassStu[element.gradeClass].add(ele.studentName);
            mpGradeClassHead[element.gradeClass].add(ele.head);
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController?.dispose();
    _contentController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CusText(
          "作业内容",
          color: Colors.black,
          size: CusFontSize.size_18,
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ChangeNotifierProvider<BaseProvider<GradeClassModel>>(
        create: (_) => provider,
        child: Consumer<BaseProvider<GradeClassModel>>(
          builder: (_, provider, child) => Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: SingleChildScrollView(
                  child: Container(
                    height: _lsVideoImg.length > 0
                        ? ScreenMgr.scrHeight + ScreenMgr.setAdapterSize(300.0)
                        : ScreenMgr.scrHeight,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)), color: CusColorGrey.grey200),
                          height: ScreenMgr.setAdapterSize(150.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          padding: EdgeInsets.fromLTRB(
                            ScreenMgr.setAdapterSize(30.0),
                            ScreenMgr.setAdapterSize(5.0),
                            ScreenMgr.setAdapterSize(30.0),
                            ScreenMgr.setAdapterSize(5.0),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "请输入作业标题",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: CusColorGrey.grey400)),
                            maxLength: 20,
                            controller: _titleController,
                            maxLines: 1,
                          ),
                        ),
                        VSpacer(
                          ScreenMgr.setAdapterSize(50.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)), color: CusColorGrey.grey200),
                          height: ScreenMgr.setAdapterSize(280.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          padding: EdgeInsets.all(ScreenMgr.setAdapterSize(30.0)),
                          child: TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: "请输入具体内容",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: CusColorGrey.grey400)),
                            maxLength: 300,
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          height: ScreenMgr.setAdapterSize(100.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          child: Divider(
                            height: 1.0,
                            color: CusColorGrey.grey200,
                          ),
                        ),
                        //上传附件就显示
                        Visibility(
                          visible: nFileNum > 0,
                          child: Container(
                              height: ScreenMgr.setAdapterSize(240.0),
                              padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(30.0), 0.0,
                                  ScreenMgr.setAdapterSize(30.0), ScreenMgr.setAdapterSize(30.0)),
                              child: ListView.builder(
                                itemBuilder: (_, index) {
                                  return Container(
                                    margin: EdgeInsets.only(left: ScreenMgr.setAdapterSize(10.0)),
                                    width: ScreenMgr.setAdapterSize(200.0),
                                    height: ScreenMgr.setAdapterSize(200.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: buildVideoImg(index),
                                    ),
                                  );
                                },
                                itemCount: _lsVideoImg.length,
                                scrollDirection: Axis.horizontal,
                              )),
                        ),
                        Container(
                          height: ScreenMgr.setAdapterSize(200.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          child: Row(
                            children: [
                              HSpacer(ScreenMgr.setAdapterSize(30.0)),
                              InkWell(
                                onTap: () async {
                                  await pickMethod(0);
                                },
                                child: Column(
                                  children: [func_buildImageAsset("fs_image.png"), CusText("相册")],
                                ),
                              ),
                              HSpacer(ScreenMgr.setAdapterSize(150.0)),
                              InkWell(
                                onTap: () async {
                                  await pickMethod(1);
                                },
                                child: Column(
                                  children: [func_buildImageAsset("fs_camera.png"), CusText("拍照")],
                                ),
                              ),
                              HSpacer(ScreenMgr.setAdapterSize(150.0)),
                              InkWell(
                                onTap: () async {
                                  await pickMethod(2);
                                },
                                child: Column(
                                  children: [func_buildImageAsset("fs_video.png"), CusText("视频")],
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                        VSpacer(
                          ScreenMgr.setAdapterSize(50.0),
                          color: CusColorGrey.grey200,
                        ),
                        InkWell(
                          onTap: () async {
                            //RouteMgr().push(context, SelectSubjectPage(lsSubject));
                            await Navigator.of(context)
                                .push(
                              MaterialPageRoute(builder: (context) => new SelectSubjectPage(lsSubject, strSelectSub)),
                            )
                                .then((value) {
                              if (value != null && value != "") {
                                Constants.log.v("$value", tag: "选择学科");
                                setState(() {
                                  strSelectSub = value;
                                });
                              }
                              FocusScope.of(context).requestFocus(new FocusNode());
                            });
                          },
                          child: Container(
                            height: ScreenMgr.setAdapterSize(150.0),
                            margin: EdgeInsets.fromLTRB(
                                ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.grade,
                                  color: Colors.red,
                                  size: 8.0,
                                ),
                                CusText("选择学科", size: CusFontSize.size_16),
                                Spacer(),
                                CusText(
                                  "$strSelectSub",
                                  size: CusFontSize.size_16,
                                  color: CusColorGrey.grey500,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenMgr.setAdapterSize(10.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          child: Divider(
                            height: 1.0,
                            color: CusColorGrey.grey200,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (strSelectSub?.isNotEmpty ?? false) {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => new SelectStudentPage(mpGradeClassStu, mpGradeClassHead,
                                          mpSubjectGradeClase[strSelectSub], lsHaveSelGrade)))
                                  .then((value) {
                                if (value != null && value.isNotEmpty) {
                                  lsHaveSelGrade = value;
                                  if (lsHaveSelGrade.isNotEmpty) {
                                    if (lsSelectGradeClass.isNotEmpty) lsSelectGradeClass.clear();
                                    lsHaveSelGrade.forEach((element) {
                                      List<int> lsRet = parseGrade(element);
                                      lsSelectGradeClass.add("${lsRet[0]}-${lsRet[1]}");
                                    });
                                  }
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                }
                              });
                            } else
                              showToast("请选择学科");
                          },
                          child: Container(
                            height: ScreenMgr.setAdapterSize(150.0),
                            margin: EdgeInsets.fromLTRB(
                                ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.grade,
                                  color: Colors.red,
                                  size: 8.0,
                                ),
                                CusText("选择接收人", size: CusFontSize.size_16),
                                Spacer(),
                                lsHaveSelGrade.isEmpty
                                    ? CusText("")
                                    : CusText(
                                        lsHaveSelGrade.length > 1 ? "${lsHaveSelGrade[0]} 等" : "${lsHaveSelGrade[0]}",
                                        size: CusFontSize.size_16,
                                        color: CusColorGrey.grey500,
                                      )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenMgr.setAdapterSize(10.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          child: Divider(
                            height: 1.0,
                            color: CusColorGrey.grey200,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              //minDateTime: DateTime.now().add(Duration(hours: -24 * 1)), //最小值
                              //maxDateTime: DateTime.now(), //最大值
                              initialDateTime: DateTime.now(), //默认日期
//                             dateFormat:'MM'+'月'+' '+'dd'+'日'+' '+'HH时'+'mm分',//显示时间格式
                              dateFormat: 'MM-dd  EEE HH时:mm分',

                              locale: DateTimePickerLocale.zh_cn,
                              pickerMode: DateTimePickerMode.datetime, //选择器种类
                              onCancel: () {},
                              onClose: () {},
                              onChange: (data, i) {
                                print(data);
                              },
                              onConfirm: (data, i) {
                                //print(data);
                                setState(() {
                                  String month = data.month < 10 ? "0${data.month}" : "${data.month}";
                                  String day = data.day < 10 ? "0${data.day}" : "${data.day}";
                                  String hour = data.hour < 10 ? "0${data.hour}" : "${data.hour}";
                                  String min = data.minute < 10 ? "0${data.minute}" : "${data.minute}";
                                  strTime = "$month-$day 周${weekDay[data.weekday - 1]} $hour:$min";

                                  strSelTime = "${data.year}-${month}-${day} ${hour}:${min}";
                                });
                              },
                            );
                          },
                          child: Container(
                            height: ScreenMgr.setAdapterSize(150.0),
                            margin: EdgeInsets.fromLTRB(
                                ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                            child: Row(
                              children: [
                                CusText(
                                  "截止提交时间",
                                  size: CusFontSize.size_16,
                                ),
                                Spacer(),
                                CusText(strTime, color: Colors.grey, size: CusFontSize.size_16)
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenMgr.setAdapterSize(10.0),
                          margin: EdgeInsets.fromLTRB(
                              ScreenMgr.setAdapterSize(30.0), 0.0, ScreenMgr.setAdapterSize(30.0), 0.0),
                          child: Divider(
                            height: 1.0,
                            color: CusColorGrey.grey200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildAssignment()
            ],
          ),
        ));
  }

  //发布作业
  _buildAssignment() {
    return CusPadding(
      Container(
          height: ScreenMgr.setHeight(130.0),
          padding: EdgeInsets.fromLTRB(ScreenMgr.scrWidth * 0.15, 0.0, ScreenMgr.scrWidth * 0.15, 0.0),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () async {
              List<File> lsFile = [];
              if (_lsVideoImg.isNotEmpty) {
                _lsVideoImg.forEach((element) {
                  lsFile.add(element.file);
                });
              }

              await this
                  .provider
                  .getAssignmentReq(_titleController.text, _contentController.text, getSubIdFromSubName(strSelectSub),
                      lsSelectGradeClass, strSelTime,
                      lsFile: lsFile)
                  .then((value) {
                if (value != null) {

                  if (value == "ok") {
                    showToast("发布成功");
                    Navigator.pop(context, "back_to_first");
                  }else showToast("$value");
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Color.fromARGB(255, 58, 158, 255)),
              child: Text(
                "发布作业",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
      t: ScreenMgr.scrHeight * 0.75,
    );
  }

  pickMethod(int index) async {
    if (nFileNum == MAX_IAMGE_VIDEO) return;
    if (assets.isNotEmpty) assets.clear(); //清空
    final List<AssetEntity> result = await pickMethods[index].f(context, assets);
    if (result != null && result.isNotEmpty && result != assets) {
      assets = List<AssetEntity>.from(result);
      nFileNum += assets.length;
      for (int i = 0; i < assets.length; i++) {
        VideoImgParam param = await getVideoImgFromAssetEntityForHomework(assets[i]);
        _lsVideoImg.add(param);
      }
      setState(() {});
    }
  }

  buildVideoImg(int index) {
    return InkWell(
      onTap: () async {
        await preView(index);
      },
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              child: Image.memory(
                _lsVideoImg[index].thumbnail,
                fit: BoxFit.fill,
              )),
          Visibility(
              //视频显示时间
              visible: _lsVideoImg[index].type == 1,
              child: AnimatedPositioned(
                duration: kThemeAnimationDuration,
                bottom: 6.0,
                right: 6.0,
                child: CusText(
                  showVideoTime(_lsVideoImg[index].time),
                  color: Colors.white,
                ),
              )),
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _lsVideoImg.removeAt(index);
                  nFileNum--;
                });
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,
                ),
                child: Container(
                  width: ScreenMgr.setAdapterSize(80.0),
                  height: ScreenMgr.setAdapterSize(80.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //预览
  preView(int index) async {
    List<String> images = [];
    List<bool> localType = [];
    int count = 0;
    for (int i = 0; i < _lsVideoImg.length; i++) {
      var item = _lsVideoImg[i];
      if (item != null && item.type == 0) {
        if (i < index) count++;
        images.add(item.strAddress);
        localType.add(true);
      }
    }
    if (_lsVideoImg[index].type == 0) {
      await Navigator.of(context).push(new FadeRoute(
          page: PhotoViewGalleryScreen(
        images: images, //传入图片list
        index: count, //传入当前点击的图片的index
        heroTag: "$count",
        localType: localType,
      )));
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VideoFullPage(_lsVideoImg[index].strAddress);
      }));
    }
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: MAX_IAMGE_VIDEO - nFileNum,
              selectedAssets: assets,
              requestType: RequestType.image,
            );
          },
        ),
        PickMethodModel(
          (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            final AssetEntity result = await CameraPicker.pickFromCamera(context,
                isAllowRecording: true,
                resolutionPreset: ResolutionPreset.high,
                maximumRecordingDuration: const Duration(seconds: 30));
            List<AssetEntity> ls = [];
            if (result != null) {
              ls.add(result);
            }
            return ls;
          },
        ),
        PickMethodModel(
          (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: MAX_IAMGE_VIDEO - nFileNum,
              selectedAssets: assets,
              requestType: RequestType.video,
            );
          },
        ),
      ];

  getSubIdFromSubName(String name) {
    int subId = 0;
    if ((this.provider.instance?.data?.subjectClass ?? []).isNotEmpty) {
      this.provider.instance.data.subjectClass.forEach((element) {
        if (element.subjectName.compareTo(name) == 0) {
          subId = element.subjectId;
          return;
        }
      });
    }
    return subId;
  }

  //解析年级 班级 一年级1班 得到 1和1
  final grade = ["一", "二", "三", "四", "五", "六"];
  final gradeNum = ["1", "2", "3", "4", "5", "6"];
  parseGrade(String str) {
    List<int> lsGradeClass = [];
    String strTemp = str.substring(0, 1);
    for (int i = 0; i < grade.length; i++) {
      if (grade[i] == strTemp) {
        lsGradeClass.add(int.parse(gradeNum[i]));
        break;
      }
    }
    strTemp = str.substring(3, 4);
    lsGradeClass.add(int.parse(strTemp));
    return lsGradeClass;
  }
} //end_class

class PickMethodModel {
  final Future<List<AssetEntity>> Function(BuildContext context, List<AssetEntity> assets) f;
  PickMethodModel(this.f);
}
