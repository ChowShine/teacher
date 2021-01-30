import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:oktoast/oktoast.dart';
import 'package:videochat_package/pages/component/touch_callback.dart';
import '../common/common_param.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:dio/dio.dart';
import '../login_page/login_page.dart';
import 'package:videochat_package/constants/customMgr/spMgr.dart';

class ModifyPasswordPage extends StatefulWidget {
  @override
  ModifyPasswordState createState() => ModifyPasswordState();
}

class ModifyPasswordState extends State<ModifyPasswordPage> {
  double _fontSize;

  TextEditingController _inputOldPwd = new TextEditingController();
  TextEditingController _inputNewPwd = new TextEditingController();
  TextEditingController _inputCheckPwd = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _fontSize = Constants.FontSize;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _builAppBar(),
      body: _buildBody(),
    );
  }

  Widget _builAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        '修改密码',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0.0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  Widget _buildBody() {
    var borderRadius = BorderRadius.all(
      Radius.circular(ScreenMgr.setAdapterSize(20)),
    );
    var marginContain = EdgeInsets.fromLTRB(0, 0, 0, ScreenMgr.setAdapterSize(30));
    var paddingContain = EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(60), 0.0, ScreenMgr.setAdapterSize(60), 0.0);
    return SingleChildScrollView(
      child: Container(
        height: ScreenMgr.scrHeight-kToolbarHeight-ScreenMgr.statusBarHeight,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.white,
        ),
        padding: paddingContain,
        width: ScreenMgr.scrWidth,
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenMgr.setAdapterSize(200.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: ScreenMgr.setAdapterSize(20),
                  ),
                  Text(
                    "旧密码",
                    style: TextStyle(
                      color: Colors.black,
                        fontSize: CusFontSize.size_17,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  HSpacer(ScreenMgr.setAdapterSize(120.0),),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextField(
                        controller: _inputOldPwd,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入旧的密码"
                        ),  onSubmitted: (value)async{
                        await modifPwd();
                      },

                      ),
                    ),
                  ),
                ],
              ),
            ),
            VSpacer(1.0,color: CusColorGrey.grey200,),
            Container(
              height: ScreenMgr.setAdapterSize(200.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: ScreenMgr.setAdapterSize(20),
                  ),
                  Text(
                    "新密码",
                    style: TextStyle(
                      color: Colors.black,
                        fontSize: CusFontSize.size_17,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  HSpacer(ScreenMgr.setAdapterSize(120.0),),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextField(
                        controller: _inputNewPwd,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入新的密码"
                        ),
                        onSubmitted: (value)async{
                          await modifPwd();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            VSpacer(1.0,color: CusColorGrey.grey200,),
           Container(
                height: ScreenMgr.setAdapterSize(200.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenMgr.setAdapterSize(20),
                    ),
                    Text(
                      "确认密码",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: CusFontSize.size_17,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    HSpacer(ScreenMgr.setAdapterSize(60.0),),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextField(
                          controller: _inputCheckPwd,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请再次输入新的密码"
                          ),
                          onSubmitted: (value)async{
                            await modifPwd();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            VSpacer(1.0,color: CusColorGrey.grey200,),

             Container(
               height: ScreenMgr.setAdapterSize(200.0),
               alignment: Alignment.center,
               child: CusText("系统默认初始密码为:123456，请及时修改，以免被盗",size: CusFontSize.size_14,color: Color.fromARGB(255, 214, 134, 134),),
             ),
             Expanded(child: Container(),),

              Container(
                height: ScreenMgr.setAdapterSize(130.0),
                padding: EdgeInsets.fromLTRB(ScreenMgr.setAdapterSize(80.0), 0.0, ScreenMgr.setAdapterSize(80.0), 0.0),
                alignment: Alignment.center,
                child: TouchCallBack(
                  onPressed: () async {
                    await modifPwd();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: ScreenMgr.setHeight(120.0),
                    decoration: BoxDecoration(
                     color: Color.fromARGB(255, 58, 158, 255),
                      borderRadius: BorderRadius.circular(ScreenMgr.setAdapterSize(100.0),)
                    ),
                    child: Text(
                      '确认修改',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            VSpacer(ScreenMgr.setAdapterSize(100.0)),


          ],
        ),
      ),
    );
  }

  /////////////////////////////////////////////////
  modifPwd()async{

    if (_inputOldPwd.text.isEmpty || _inputNewPwd.text.isEmpty || _inputCheckPwd.text.isEmpty) {
      showToast('密码不能为空，请输入');
    } else if (_inputNewPwd.text != _inputCheckPwd.text) {
      showToast("两次新密码不一致，请重新输入");
    } else {
      await getModifyPwdReq(_inputOldPwd.text,_inputNewPwd.text).then((value) {
        if(value=="ok"){
          showToast("修改密码成功");
          //Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => new LoginPage()), (Route<dynamic> rout) => false);

        }else{
          showToast(value);
        }
      });

    }
  }

  /////////////////////////////////////////////////
  Future<String> getModifyPwdReq(String oldPwd,String newPwd) async {
    try {
      Response resp = await Constants.httpTeacherToken.postRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}change_password", params: {
        "now_password": oldPwd,
        "new_password": newPwd,
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if(mpData["msg"]=="ok"){
          //成功重新保存登录用户名
          SpMgr sp = await SpMgr.getInstance();
          await sp.setString("username", g_strTeacherName);
          await sp.setString("psw", newPwd);
          return "ok";
        }else{
          return mpData["msg"];
        }
      }else{
        return "请求出错";
      }
    } catch (e) {
      print("$e");
    }
  }

}
