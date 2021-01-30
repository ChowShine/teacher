import '../model/green_details.model.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';

class GreenDetailsProvider extends BaseProvider<GreenDetailsModel> {
  Future<void> getDetailsReq(int nProjectId,int nStudentId) async {
    try {
      Response resp = await Constants.httpTeacherToken.getRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}project_details", params: {
        "project_id": nProjectId,
        "student_id": nStudentId,
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        GreenDetailsModel greenDetailsModel=GreenDetailsModel.fromJson(mpData);

        this.setData(greenDetailsModel);
      }
    } catch (e) {
      print("$e");
    }

  }


  Future<String> delImageOrVideoReq(int fileId)async{
    try {
      Response resp = await Constants.httpTeacherToken.postRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}del_upload", params: {
        "file_id":fileId
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        return mpData["msg"];
      }
    } catch (e) {
      print("$e");
      return "$e";
    }
  }
}
