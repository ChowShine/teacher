//我的页面
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videochat_package/library/flustars.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import 'package:videochat_package/constants/cache_pic.dart';
import '../common/common_func.dart';
import '../common/common_param.dart';
import 'package:videochat_package/constants/customMgr/datetimeMgr.dart';
import 'package:flutter/services.dart';
import 'my_set_page.dart';
import './my_modify_pwd_page.dart';
import '../login_page/login_page.dart';
import 'package:videochat_package/constants/customMgr/spMgr.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String strUserName = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  StateSetter mySetState;
  StateSetter myNetSetState;
  _buildBody() {
    return Container(
      color: CusColorGrey.grey100,
      child: Stack(
        children: <Widget>[
          Container(
              child: Image.asset(
            "${Constants.strImagesDir}fs_my_bk.png",
            fit: BoxFit.fill,
            width: ScreenMgr.scrWidth,
            height: ScreenMgr.scrHeight * 0.4,
          )),
          Container(
            height: ScreenMgr.scrHeight * 0.4,
            color: Colors.transparent,
            child: RepaintBoundary(
              child: TouchCallBack(
                onPressed: () async {

                },
                child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        VSpacer(
                          ScreenMgr.scrHeight * 0.1,
                          color: Colors.transparent,
                        ),
                        RepaintBoundary(
                          child: StatefulBuilder(builder: (_, myState) {
                            this.mySetState = myState;
                            return ClipOval(child: func_buildImageAsset("fs_teacher_head.png",dScale: 3.0),);
                          }),
                        ),
                        CusText(
                          "$g_strTeacherName",
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                          size: 18.0,
                        ),
                        CusText(
                          "",
                          color: Colors.white,
                          size: CusFontSize.size_16,
                        ),
                        Spacer(),
                      ],
                    )),
              ),
            ),
          ),
          CusPadding(
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                children: <Widget>[
                  Container(
                      height: ScreenMgr.setAdapterSize(320.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: TouchCallBack(
                                onPressed: () async{

                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "${Constants.strImagesDir}fs_my_todo.png",
                                        scale: 3.0,
                                      ),
                                      VSpacer(
                                        ScreenMgr.setAdapterSize(30.0),
                                        color: Colors.transparent,
                                      ),
                                      CusText(
                                        "待办",
                                        size: CusFontSize.size_17,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: TouchCallBack(
                                onPressed: () {},
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "${Constants.strImagesDir}fs_my_notice.png",
                                        scale: 3.0,
                                      ),
                                      VSpacer(
                                        ScreenMgr.setAdapterSize(30.0),
                                        color: Colors.transparent,
                                      ),
                                      CusText(
                                        "通知",
                                        size: CusFontSize.size_17,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      )),
                  Container(height: ScreenMgr.setAdapterSize(50), color: Colors.grey[100]),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            RouteMgr().push(context, CommonSetPage());
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            height: ScreenMgr.setAdapterSize(130.0),
                            child: Row(
                              children: [
                                func_buildImageAsset("fs_my_set.png"),
                                HSpacer(
                                  ScreenMgr.setAdapterSize(60.0),
                                ),
                                CusText(
                                  "设置",
                                  size: CusFontSize.size_17,
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                        ),
                        InkWell(
                          onTap: () {
                            RouteMgr().push(context, ModifyPasswordPage());
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            height: ScreenMgr.setAdapterSize(130.0),
                            child: Row(
                              children: [
                                func_buildImageAsset("fs_my_pwd.png"),
                                HSpacer(
                                  ScreenMgr.setAdapterSize(60.0),
                                ),
                                CusText(
                                  "修改密码",
                                  size: CusFontSize.size_17,
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            height: ScreenMgr.setAdapterSize(130.0),
                            child: Row(
                              children: [
                                func_buildImageAsset("fs_my_more.png"),
                                HSpacer(
                                  ScreenMgr.setAdapterSize(60.0),
                                ),
                                CusText(
                                  "更多",
                                  size: CusFontSize.size_17,
                                )
                              ],
                            ),
                          ),
                        ),
                       /* Divider(
                          height: 1.0,
                        ),
                        InkWell(
                          onTap: () {
                            myNetSetState(() {
                              nNetType = (nNetType + 1) % 2;
                              gnNetType = nNetType;
                              Future.delayed(Duration.zero, () async {
                                SpMgr sp = await SpMgr.getInstance();
                                sp.setString("netType", gnNetType.toString());
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            height: ScreenMgr.setAdapterSize(130.0),
                            child: Row(
                              children: [
                                func_buildImageAsset("fs_my_more.png"),
                                HSpacer(
                                  ScreenMgr.setAdapterSize(60.0),
                                ),
                                CusText(
                                  "网络类型",
                                  size: CusFontSize.size_17,
                                ),
                                Spacer(),
                                StatefulBuilder(builder: (_, netSetState) {
                                  myNetSetState = netSetState;
                                  return CusText(
                                    nNetType == 0 ? "外网" : "内网",
                                    size: CusFontSize.size_16,
                                    color: Colors.green,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),*/
                        Divider(
                          height: 1.0,
                        ),
                        InkWell(
                          onTap: () async {
                            //exit(0);
                            //await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => new LoginPage()),
                                (Route<dynamic> rout) => false);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            height: ScreenMgr.setAdapterSize(130.0),
                            child: Row(
                              children: [
                                func_buildImageAsset("fs_my_exit.png"),
                                HSpacer(
                                  ScreenMgr.setAdapterSize(60.0),
                                ),
                                CusText(
                                  "退出登录",
                                  size: CusFontSize.size_17,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
            t: ScreenUtil.getInstance().screenHeight * 0.3,
          ),
          CusPadding(
              Container(
                padding: EdgeInsets.only(left: ScreenMgr.setAdapterSize(50.0)),
                height: ScreenMgr.setAdapterSize(150.0),
                width: ScreenMgr.scrWidth * 0.4,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    Image.asset(
                      "${Constants.strImagesDir}fs_my_date_bk.png",
                      scale: 3.0,
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(left: ScreenMgr.setAdapterSize(35.0), top: ScreenMgr.setAdapterSize(6.0)),
                        child: CusText(
                          "${transDateTime(DateTime.now())} ${DateTimeMgr().getWeekDay(DateTime.now().toString())}",
                          color: Colors.white,
                          size: CusFontSize.size_13,
                        ))
                  ],
                ),
              ),
              t: ScreenMgr.setAdapterSize(60.0)),
        ],
      ),
    );
  }

} //end class
