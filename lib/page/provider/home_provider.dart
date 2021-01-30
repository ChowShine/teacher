//首页

import 'package:teacher/page/common/common_param.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/base/base_provider.dart';

class HomeModel{

}

class HomeProvider extends BaseProvider<HomeModel>{
  //请求首页数据
  String teacherName="";
  String lastLoginTime="";
  String schoolName="";
  Future<void> getHomeReq() async {
    try {
      Response resp = await Constants.httpTeacherToken.getRequest(
          "${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}index",
          params: {

          });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if (mpData['code'] == "0" && mpData['msg'] == "ok"&&mpData['data']!=null) {
          teacherName=mpData['data']['user_name']??"";
          lastLoginTime=mpData['data']['last_login_time']??"";
          schoolName=mpData['data']['school_name']??"";
        }
      }
    } catch (e) {
      print("$e");
    }
    notifyListeners();

  }


}