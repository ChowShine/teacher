
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';

class FileProvider extends BaseProvider<List<String>> {
  static Future<bool> postSaveReq(
    int student_id,
    int nScore,
      int msg_id,
      int project_id,
      int subject_id,
      int station_id,
      int learn_card_id
  ) async {
    try {
      Response resp = await Constants.httpTeacherToken.postRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}project_save", params: {
        "project_id": project_id,
        "student_id": student_id,
        "msg_id": msg_id,
        "score": nScore,
        "subject_id": subject_id,
        "station_id": station_id,
        "learn_card_id": learn_card_id
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        if (mpData["code"] == "0") {
          //成功
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      print("$e");
      return false;
    }
  }

}
