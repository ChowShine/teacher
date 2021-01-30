//登录页面

import '../common/common_param.dart';
import 'package:teacher/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import 'package:oktoast/oktoast.dart';
import 'package:videochat_package/utilities/bugly_update.dart';
import 'package:videochat_package/events/login_success_event.dart';
import '../common/common_func.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/customMgr/spMgr.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController nameController = new TextEditingController(); //用户名
  final TextEditingController pwdController = new TextEditingController(); //密码

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () async {
      SpMgr sp = await SpMgr.getInstance();
      String strUserName = sp.getString("username");
      String strPsw = sp.getString("psw");
      setState(() {
        if (strUserName != null && strUserName.isNotEmpty) nameController.text = strUserName;
        if (strPsw != null && strPsw.isNotEmpty) pwdController.text = strPsw;
      });
    });

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
        body: SingleChildScrollView(
      child: Container(
          child: Stack(
        children: [
          Image.asset(
            "${Constants.strImagesDir}fs_app_bk.png",
            width: ScreenMgr.scrWidth,
            height: ScreenMgr.scrHeight,
            fit: BoxFit.fill,
          ),
          CusPadding(
            //登录logo
            Center(
              child: Container(
                alignment: Alignment.center,
                width: ScreenMgr.setAdapterSize(200.0),
                height: ScreenMgr.setAdapterSize(200.0),
                child: func_buildImageAsset(
                  "login_logo.png",
                ),
              ),
            ),
            t: ScreenMgr.scrHeight * 0.2,
            b: ScreenMgr.scrHeight * 0.65,
          ),
          CusPadding(
            Container(
                height: ScreenMgr.scrHeight * 0.55,
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  children: [
                    Container(
                        height: ScreenMgr.setHeight(130.0),
                        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(100.0)), color: Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(bottom: ScreenMgr.setAdapterSize(8.0)),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.perm_identity),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  hintText: "请输入用户名",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: CusFontSize.size_16),
                                ),
                                onSubmitted: (value) async {
                                  await onLogin();
                                },
                              ),
                            ))
                          ],
                        )),
                    VSpacer(
                      ScreenMgr.setAdapterSize(50.0),
                    ),
                    Container(
                        height: ScreenMgr.setHeight(130.0),
                        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(100.0)), color: Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(bottom: ScreenMgr.setAdapterSize(8.0)),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: pwdController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                  hintText: "请输入密码",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: CusFontSize.size_16),
                                ),
                                obscureText: true,
                                onSubmitted: (str) async {
                                  await onLogin();
                                },
                              ),
                            ))
                          ],
                        )),
                    VSpacer(
                      ScreenMgr.setAdapterSize(50.0),
                    ),
                    Container(
                        height: ScreenMgr.setHeight(130.0),
                        margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                        //padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        alignment: Alignment.center,
                        child: TouchCallBack(
                          onPressed: () async {
                            await onLogin();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  ScreenMgr.setAdapterSize(100.0),
                                ),
                                color: Color.fromARGB(255, 185, 213, 252)),
                            child: CusText(
                              "登录",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    VSpacer(
                      ScreenMgr.setAdapterSize(60.0),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: ScreenMgr.setAdapterSize(60.0),
                      child: CusText(
                        "登录即代表同意《用户协议》和《隐私政策》",
                        color: Colors.white,
                        size: CusFontSize.size_12,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: ScreenMgr.setAdapterSize(120.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          HSpacer(
                            ScreenMgr.setAdapterSize(70.0),
                          ),
                          StatefulBuilder(builder: (_, mysetState) {
                            netTypeSetState = mysetState;
                            return Checkbox(
                              value: gnNetType == 0 ? false : true,
                              onChanged: (value) {
                                gnNetType = !value ? 0 : 1;
                                netTypeSetState(() {
                                  Future.delayed(Duration.zero, () async {
                                    SpMgr sp = await SpMgr.getInstance();
                                    sp.setString("netType", gnNetType.toString());
                                  });
                                });
                              },
                            );
                          }),
                          CusText(
                            "使用内网",
                            color: Colors.blue,
                            size: CusFontSize.size_13,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            t: ScreenMgr.scrHeight * 0.45,
          ),
          CusPadding(
            //顶部云朵
            Container(
              alignment: Alignment.center,
              height: ScreenMgr.setAdapterSize(400.0),
              width: ScreenMgr.scrWidth,
              child: Image.asset(
                "${Constants.strImagesDir}fs_cloud_bk.png",
                color: Colors.white,
                fit: BoxFit.fitWidth,
              ),
            ),
            t: ScreenMgr.setAdapterSize(40.0),
          ),
        ],
      )),
    ));
  }

  StateSetter netTypeSetState;

  onLogin() async {
    if (nameController.text.isEmpty || pwdController.text.isEmpty) {
      showToast("用户名和密码不能为空");
    } else {
      g_strTeacherName = "${nameController.text}";
      String strUserName = "${nameController.text}";
      String strPsw = "${pwdController.text}";
      SpMgr sp = await SpMgr.getInstance();
      await sp.setString("username", strUserName);
      await sp.setString("psw", strPsw);
      TeacherAuthenticationService.netType = gnNetType;
      await TeacherAuthenticationService.loginPostToken(nameController.text, pwdController.text);
      if (TeacherAuthenticationService.isAuthenticated()) {

        //先判断是否需要升级
        String strOldVer=sp.getString("$VERSION");
        String strNewVer=TeacherAuthenticationService.version;
        if(strOldVer==""){//第一次安装
          if(parseVersion(g_strVer)<parseVersion(strNewVer)){//本地版本小于后台版本
            BuglyUpdate(context, () {
              sp.setString("$VERSION", strNewVer);
            }).upgrade(TeacherAuthenticationService.version, TeacherAuthenticationService.downLoadUrl, () {});
          }else{
            Constants.httpTeacherToken = TeacherAuthenticationService.getInstance();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> rout) => false);
          }
        }else{//已存储，非第一次安装
          if(parseVersion(strOldVer)<parseVersion(strNewVer)/*&&parseVersion(g_strVer)<parseVersion(strNewVer)*/){
            BuglyUpdate(context, () {
              sp.setString("$VERSION", strNewVer);
            }).upgrade(TeacherAuthenticationService.version, TeacherAuthenticationService.downLoadUrl, () {});
          }else{
            Constants.httpTeacherToken = TeacherAuthenticationService.getInstance();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> rout) => false);
          }
        }
      } else {
        showToast("登录失败,请重新登录");
      }
    }
  }
} //end_class
