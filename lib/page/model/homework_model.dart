//作业列表

class HomeWorkModel {
  String code;
  String msg;
  Data data;

  HomeWorkModel({this.code, this.msg, this.data});

  HomeWorkModel.fromJson(Map<String, dynamic> json) {
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
  List<String> classes;
  String gradeClass;
  HomeWorkList homeWorkList;

  Data({this.classes, this.gradeClass, this.homeWorkList});

  Data.fromJson(Map<String, dynamic> json) {
    classes = json['classes'].cast<String>();
    gradeClass = json['grade_class'];
    homeWorkList = json['home_work_list'] != null
        ? new HomeWorkList.fromJson(json['home_work_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classes'] = this.classes;
    data['grade_class'] = this.gradeClass;
    if (this.homeWorkList != null) {
      data['home_work_list'] = this.homeWorkList.toJson();
    }
    return data;
  }
}

class HomeWorkList {
  int total;
  int perPage;
  int currentPage;
  int lastPage;
  List<DataInfo> data;

  HomeWorkList(
      {this.total, this.perPage, this.currentPage, this.lastPage, this.data});

  HomeWorkList.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['data'] != null) {
      data = new List<DataInfo>();
      json['data'].forEach((v) {
        data.add(new DataInfo.fromJson(v));
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

class DataInfo {
  int id;
  int senderId;
  int subjectId;
  String details;
  int notificationType;
  String dtime;
  int isDelete;
  int isSend;
  int inClass;
  int inGrade;
  String endTime;
  int schoolId;
  String name;
  int count;
  int allCount;

  DataInfo(
      {this.id,
        this.senderId,
        this.subjectId,
        this.details,
        this.notificationType,
        this.dtime,
        this.isDelete,
        this.isSend,
        this.inClass,
        this.inGrade,
        this.endTime,
        this.schoolId,
        this.name,
        this.count,
        this.allCount});

  DataInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    subjectId = json['subject_id'];
    details = json['details'];
    notificationType = json['notification_type'];
    dtime = json['dtime'];
    isDelete = json['is_delete'];
    isSend = json['is_send'];
    inClass = json['in_class'];
    inGrade = json['in_grade'];
    endTime = json['end_time'];
    schoolId = json['school_id'];
    name = json['name'];
    count = json['count'];
    allCount = json['all_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['subject_id'] = this.subjectId;
    data['details'] = this.details;
    data['notification_type'] = this.notificationType;
    data['dtime'] = this.dtime;
    data['is_delete'] = this.isDelete;
    data['is_send'] = this.isSend;
    data['in_class'] = this.inClass;
    data['in_grade'] = this.inGrade;
    data['end_time'] = this.endTime;
    data['school_id'] = this.schoolId;
    data['name'] = this.name;
    data['count'] = this.count;
    data['all_count'] = this.allCount;
    return data;
  }
}


