//布置作业选择的 学科 学生
import 'package:teacher/page/common/common_param.dart';
import 'package:videochat_package/constants/constants.dart';
import 'package:videochat_package/constants/customMgr/httpMgr.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:dio/dio.dart';
import '../model/grade_class_model.dart';
import 'package:videochat_package/constants/base/base_provider.dart';
import 'dart:io';

class GradeClassProvider extends BaseProvider<GradeClassModel> {
  Future<void> getGradeClassSubStuReq() async {
    try {
      Response resp = await Constants.httpTeacherToken
          .getRequest("${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}subject_with_class", params: {});
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        GradeClassModel gradeClass = GradeClassModel.fromJson(mpData);
        this.setData(gradeClass);
      }
    } catch (e) {
      print("$e");
    }
  }

//布置作业
  Future<String> getAssignmentReq(String title,String content,int subId, List<String> lsGradeClass,String endTime,{List<File> lsFile}) async {
    Map<String, dynamic> mpFormData = await HttpMgr().getFormDataMap(lsFile, {
      "home_work_title": title,
      "home_work_content": content,
      "subject_id":subId,
      "grade_class": lsGradeClass,
      "end_time": endTime,
    });

    FormData formData=FormData.fromMap(mpFormData);

    try {
      Response resp = await Constants.httpTeacherToken.postRequest(
          "${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}home_work_create",
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
