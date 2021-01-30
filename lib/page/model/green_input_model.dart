class GreenInputModel {
  String code;
  String msg;
  Data data;

  GreenInputModel({this.code, this.msg, this.data});

  GreenInputModel.fromJson(Map<String, dynamic> json) {
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
  //Project project;
  StudentList studentList;

  Data({/*this.project, */this.studentList});

  Data.fromJson(Map<String, dynamic> json) {
    //project =
    //json['project'] != null ? new Project.fromJson(json['project']) : null;
    studentList = json['student_list'] != null
        ? new StudentList.fromJson(json['student_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*if (this.project != null) {
      data['project'] = this.project.toJson();
    }*/
    if (this.studentList != null) {
      data['student_list'] = this.studentList.toJson();
    }
    return data;
  }
}

/*class Project {
  String projectsName;
  String stationName;
  String learnCardName;
  String semesterName;

  Project(
      {this.projectsName,
        this.stationName,
        this.learnCardName,
        this.semesterName});

  Project.fromJson(Map<String, dynamic> json) {
    projectsName = json['projects_name'];
    stationName = json['station_name'];
    learnCardName = json['learn_card_name'];
    semesterName = json['semester_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projects_name'] = this.projectsName;
    data['station_name'] = this.stationName;
    data['learn_card_name'] = this.learnCardName;
    data['semester_name'] = this.semesterName;
    return data;
  }
}*/

class StudentList {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  List<InputData> data;

  StudentList(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  StudentList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = new List<InputData>();
      json['data'].forEach((v) {
        data.add(new InputData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InputData {
  int studentId;
  String username;
  int inGrade;
  int inClass;
  int stationId;
  int learnCardId;
  int projectId;
  String gradeClass;
  String isFinish;
  int groupId;

  InputData(
      {this.studentId,
        this.username,
        this.inGrade,
        this.inClass,
        this.stationId,
        this.learnCardId,
        this.projectId,
        this.gradeClass,
        this.isFinish,
        this.groupId});

  InputData.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    username = json['username'];
    inGrade = json['in_grade'];
    inClass = json['in_class'];
    stationId = json['station_id'];
    learnCardId = json['learn_card_id'];
    projectId = json['project_id'];
    gradeClass = json['grade_class'];
    isFinish = json['is_finish'];
    groupId = json['group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['username'] = this.username;
    data['in_grade'] = this.inGrade;
    data['in_class'] = this.inClass;
    data['station_id'] = this.stationId;
    data['learn_card_id'] = this.learnCardId;
    data['project_id'] = this.projectId;
    data['grade_class'] = this.gradeClass;
    data['is_finish'] = this.isFinish;
    data['group_id'] = this.groupId;
    return data;
  }
}
