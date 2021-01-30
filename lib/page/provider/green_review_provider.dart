//绿评口令

import 'package:videochat_package/constants/base/base_provider.dart';
import '../model/green_review_model.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:dio/dio.dart';
import '../common/common_param.dart';

class GreenReviewProvider extends BaseProvider<GreenReviewModel> {
  Future<void> getReviewReq(String strPwd) async {
    try {
      Response resp =
      await Constants.httpTeacherToken.postRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}project_token", params: {"command": strPwd});
      if (resp != null) {
        Map data= new Map<String, dynamic>.from(resp.data);
        if (data != null) setData(GreenReviewModel.fromJson(data));
      }
    } catch (e) {
      print("$e");
    }
  }

  bool isOK() {
    return instance != null && instance.msg == "ok";
  }

  int get  projectId=>instance.data.id;
}
