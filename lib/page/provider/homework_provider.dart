//作业列表
import 'package:videochat_package/constants/base/base_provider.dart';
import 'package:videochat_package/constants/constants.dart';
import '../common/common_param.dart';
import '../model/homework_model.dart';
import 'package:dio/dio.dart';
import 'package:videochat_package/constants/token/teacher_token.dart';

class HomeWorkProvider extends BaseListProvider<DataInfo> {

  List<String> lsClass=[];
  String strGradeClass="";

  initData(){
    if(lsClass.isNotEmpty) lsClass.clear();
    strGradeClass="";
    this.init();
  }

  //请求作业列表
  Future<void> getHomeWorkReq({int grade_id=0,int class_id=0}) async {
    try {
      Response resp = await Constants.httpTeacherToken
          .getRequest("${gnNetType == 0 ? URL.API_ADDRESS : URLIntranet.API_ADDRESS}home_work_list", params: {
        "limit": this.limit,
        "page": this.page,
        "grade_id": grade_id,
        "class_id": class_id,
      });
      if (resp != null) {
        Map mpData = new Map<String, dynamic>.from(resp.data);
        strGradeClass=HomeWorkModel.fromJson(mpData)?.data?.gradeClass??"";
        lsClass=HomeWorkModel.fromJson(mpData)?.data?.classes??[];
        List<DataInfo> lsDataInfo=HomeWorkModel.fromJson(mpData)?.data?.homeWorkList?.data;
        if(lsDataInfo!=null&&lsDataInfo.isNotEmpty){
          this.addAll(lsDataInfo);
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
    notifyListeners();
  }
}
