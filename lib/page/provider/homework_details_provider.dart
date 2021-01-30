//作业详情
//作业列表
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';
import '../model/homeword_details_model.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';

class HomeWorkDetailsProvider extends BaseProvider<HomeWorkDetailsModel> {

  //请求作业列表
  Future<void> getHomeWorkDetailsReq(int homewordId) async {
    try {
      Response resp = await Constants.httpTeacherToken
          .getRequest("${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}home_work_details", params: {
        "home_work_id": homewordId,
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if(mpData["code"]=="0"&&mpData["msg"]=="ok"){
           this.setData(HomeWorkDetailsModel.fromJson(mpData));
        }else{
          return ;
        }
      }
    } catch (e) {
      print("$e");
    }
    notifyListeners();
  }

}