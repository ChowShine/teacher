class GreenReviewModel {
  String code;
  String msg;
  Data data;

  GreenReviewModel({this.code, this.msg, this.data});

  GreenReviewModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String projectsName;
  int stationId;
  String projectsToken;
  int isGroup;
  int schoolId;
  String stationName;
  int learnCardId;
  int subjectId;
  int classId;
  String learnCardName;
  int semesterId;
  int gradeId;
  int totalNum;
  String semesterName;

  Data(
      {this.id,
        this.projectsName,
        this.stationId,
        this.projectsToken,
        this.isGroup,
        this.schoolId,
        this.stationName,
        this.learnCardId,
        this.subjectId,
        this.classId,
        this.learnCardName,
        this.semesterId,
        this.gradeId,
        this.totalNum,
      this.semesterName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectsName = json['projects_name'];
    stationId = json['station_id'];
    projectsToken = json['projects_token'];
    isGroup = json['is_group'];
    schoolId = json['school_id'];
    stationName = json['station_name'];
    learnCardId = json['learn_card_id'];
    subjectId = json['subject_id'];
    classId = json['class_id'];
    learnCardName = json['learn_card_name'];
    semesterId = json['semester_id'];
    gradeId = json['grade_id'];
    totalNum = json['total_num'];
    semesterName=json['semester_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['projects_name'] = this.projectsName;
    data['station_id'] = this.stationId;
    data['projects_token'] = this.projectsToken;
    data['is_group'] = this.isGroup;
    data['school_id'] = this.schoolId;
    data['station_name'] = this.stationName;
    data['learn_card_id'] = this.learnCardId;
    data['subject_id'] = this.subjectId;
    data['class_id'] = this.classId;
    data['learn_card_name'] = this.learnCardName;
    data['semester_id'] = this.semesterId;
    data['grade_id'] = this.gradeId;
    data['total_num'] = this.totalNum;
    data['semester_name']=this.semesterName;
    return data;
  }
}
