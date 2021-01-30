//绿评录入
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';
import '../model/green_input_model.dart';

class GreenInputProvider extends BaseListProvider<InputData> {

  Future<void> getInputReq() async {
    try {
      Response resp = await Constants.httpTeacherToken.getRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}project_list", params: {
        "project_id": gProjectInfo.nProjectId,
        "limit": this.limit,
        "page": this.page,
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        List<InputData> lsInputData=GreenInputModel.fromJson(mpData)?.data?.studentList?.data;
        if(lsInputData!=null&&lsInputData.isNotEmpty){
          this.addAll(lsInputData);
          setPage();
        }else{
          setStateType(LoadType.en_LoadComplete);
        }
        Future.delayed(Duration(milliseconds: 500),(){
          setStateType(LoadType.en_LoadNormal);
        });
      }
    } catch (e) {
      print("$e");
    }
  }
}


class GreenSearchProvider extends BaseListProvider<InputData> {

  Future<void> getSearchReq(String strName) async {
    try {
      Response resp = await Constants.httpTeacherToken.getRequest("${gnNetType==0?URL.API_ADDRESS:URLIntranet.API_ADDRESS}project_list", params: {
        "project_id": gProjectInfo.nProjectId,
        "limit": this.limit,
        "page": this.page,
        "user_name":strName
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        List<InputData> lsInputData=GreenInputModel.fromJson(mpData)?.data?.studentList?.data;
        if(lsInputData!=null&&lsInputData.isNotEmpty){
          this.addAll(lsInputData);
          setPage();
        }else{
          setStateType(LoadType.en_LoadComplete);
        }
        Future.delayed(Duration(milliseconds: 500),(){
          setStateType(LoadType.en_LoadNormal);
        });
      }
    } catch (e) {
      print("$e");
    }
  }
}
