//学生作业详情
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';
import '../model/student_homework_model.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/customMgr/httpMgr.dart';
import 'dart:io';

class StudentHomeWorkProvider extends BaseProvider<StudentHomeWorkDetailsModel> {
  //请求作业列表
  Future<void> getStudentHomeWorkReq(int student_homework_id) async {
    try {
      Response resp = await Constants.httpTeacherToken.getRequest(
          "${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}home_work_student_details",
          params: {
            "home_work_student_id": student_homework_id,
          });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if (mpData['code'] == "0" && mpData['msg'] == "ok") {
          this.setData(StudentHomeWorkDetailsModel.fromJson(mpData));
        }
      }
    } catch (e) {
      print("$e");
    }
    notifyListeners();
  }

  //点评提交
  Future<String> getCommentReq(int student_homework_id, int nScoreId,
      {String strContent, int nTime, List<File> lsfile}) async {
    Map<String, dynamic> mpFormData = await HttpMgr().getFormDataMap(lsfile, {
      "home_work_student_id": student_homework_id,
      "score_id": nScoreId,
      "content": strContent ?? "",
      "voice_time": nTime ?? 0
    });

    FormData formData = FormData.fromMap(mpFormData);

    try {
      Response resp = await Constants.httpTeacherToken.postRequest(
          "${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}home_work_remark_post",
          params: formData);
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if (mpData['code'] == "0" && mpData['msg'] == "ok") {
          return Future.value(mpData['msg']);
        } else
          return Future.value(mpData['msg']);
      }
      return Future.value("请求出错");
    } catch (e) {
      print("$e");
      return Future.value("请求异常");
    }
  }
}
