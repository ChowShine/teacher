//绿评口令

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher/page/common/opration_file.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import '../common/common_func.dart';
import '../common/common_param.dart';
import 'green_input_page.dart';
import '../provider/green_review_provider.dart';
import '../model/green_review_model.dart';
import 'package:provider/provider.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:videochat_package/constants/customMgr/spMgr.dart';
import 'dart:io';
import 'package:videochat_package/constants/customMgr/dirMgr.dart';
import 'package:videochat_package/constants/customMgr/fileMgr.dart';

class GreenReviewPage extends StatefulWidget {
  @override
  _GreenReviewPageState createState() => _GreenReviewPageState();
}

class _GreenReviewPageState extends State<GreenReviewPage> {
  final TextEditingController _textEditController = new TextEditingController();
  GreenReviewProvider provider = GreenReviewProvider();
  SpMgr sp;
  double leftPad = ScreenMgr.scrWidth / 6;
  StateSetter mySetState;
  String strSp = "";
  Timer _timer;

  bool isRead = true;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      sp = await SpMgr.getInstance();
      strSp = sp.getString("$g_strTeacherName");
      if (strSp.isNotEmpty) {
        //_textEditController.text = strSp;
      }
    });

    _timer = Timer.periodic(Duration(milliseconds: 300), (timer) async {
      if (isRead) {
        if (g_lsSave.length > 0) {
          VideoImgParam param = g_lsSave[0];
          isRead = false;
          await uploadOne(param, () {
            isRead = true;
            g_lsSave.removeAt(0);
          });
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer.isActive) {
      _timer.cancel();
    }
    Constants.log.v("dispose", tag: "页面取消");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ChangeNotifierProvider<BaseProvider<GreenReviewModel>>(
      create: (_) => provider,
      child: Consumer<BaseProvider<GreenReviewModel>>(
        builder: (_, provider, child) => SingleChildScrollView(
          child: Container(
            height: ScreenMgr.scrHeight - ScreenMgr.bottomBarHeight - ScreenMgr.appBarHeight,
            child: Stack(
              children: [
                Container(
                  width: ScreenMgr.scrWidth,
                  height: ScreenMgr.scrHeight * 0.52,
                  child: func_buildImageAsset("fs_green_bk.png", fit: BoxFit.fill),
                ),
                Container(
                  child: CusPadding(
                    Column(
                      children: [
                        StatefulBuilder(builder: (_, mysetState) {
                          this.mySetState = mysetState;
                          return Container(
                              height: ScreenMgr.setHeight(130.0),
                              padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(100.0)),
                                  color: Colors.white),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(left: leftPad, bottom: ScreenMgr.setAdapterSize(8.0)),
                                    child: TextField(
                                      keyboardType: TextInputType.phone,
                                      controller: _textEditController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                        hintText: "请输入考官口令",
                                        hintStyle: TextStyle(color: Colors.black87, fontSize: CusFontSize.size_16),
                                      ),
                                      onSubmitted: (value) async {
                                        await openDoor();
                                      },
                                      onChanged: (value) {
                                        this.mySetState(() {
                                          if (value.isEmpty)
                                            leftPad = ScreenMgr.scrWidth / 6;
                                          else
                                            leftPad = ScreenMgr.scrWidth * 0.24;
                                        });
                                      },
                                    ),
                                  ))
                                ],
                              ));
                        }),
                        VSpacer(ScreenMgr.setAdapterSize(80.0)),
                        Container(
                            height: ScreenMgr.setHeight(130.0),
                            alignment: Alignment.center,
                            child: TouchCallBack(
                              onPressed: () async {
                                await openDoor();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Color.fromARGB(255, 88, 158, 255)),
                                child: Text(
                                  "芝麻开门",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )),
                      ],
                    ),
                    t: ScreenMgr.scrHeight * 0.5,
                    l: ScreenMgr.scrWidth * 0.1,
                    r: ScreenMgr.scrWidth * 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDoor() async {
    await this.provider.getReviewReq(_textEditController.text).then((value) async {
      if (this.provider.isOK()) {
        sp.setString("$g_strTeacherName", _textEditController.text);

        gProjectInfo.nProjectId = this.provider.projectId;
        gProjectInfo.nSubjectId = this.provider.instance?.data?.subjectId ?? 0;
        gProjectInfo.nStationId = this.provider.instance?.data?.stationId ?? 0;
        gProjectInfo.nLearnCardId = this.provider.instance?.data?.learnCardId ?? 0;
        gProjectInfo.semesterName = this.provider.instance?.data?.semesterName ?? "";
        gProjectInfo.projectsName = this.provider.instance?.data?.projectsName ?? "";
        gProjectInfo.stationName = this.provider.instance?.data?.stationName ?? "";
        gProjectInfo.learnCardName = this.provider.instance?.data?.learnCardName ?? "";

        this.provider.setData(null);
        //打开数据库
        await OpDataBase.openDataBase("teacher2_${gProjectInfo.nProjectId}.sdb"); //以 g_nProjectId为唯一标识打开表
        g_lsAllSStuId.clear();
        mp_VideoImgParam.clear();
        g_lsAllSStuId = await OpDataBase.getAllStuId();
        await OpDataBase.getVideoImgParam();

        RouteMgr().push(context, InputPage());
      } else {
        showToast("口令错误，请重新输入");
      }
    });
  }
} //end class
