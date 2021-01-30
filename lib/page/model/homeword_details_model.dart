//作业详情

class HomeWorkDetailsModel {
  String code;
  String msg;
  Data data;

  HomeWorkDetailsModel({this.code, this.msg, this.data});

  HomeWorkDetailsModel.fromJson(Map<String, dynamic> json) {
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
  HomeWorkRelease homeWorkRelease;
  List<Files> files;
  List<AlreadySend> already;
  List<NoneSend> none;

  Data({this.homeWorkRelease, this.files, this.already, this.none});

  Data.fromJson(Map<String, dynamic> json) {
    homeWorkRelease = json['home_work_release'] != null
        ? new HomeWorkRelease.fromJson(json['home_work_release'])
        : null;
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    if (json['already'] != null) {
      already = new List<AlreadySend>();
      json['already'].forEach((v) {
        already.add(new AlreadySend.fromJson(v));
      });
    }
    if (json['none'] != null) {
      none = new List<NoneSend>();
      json['none'].forEach((v) {
        none.add(new NoneSend.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.homeWorkRelease != null) {
      data['home_work_release'] = this.homeWorkRelease.toJson();
    }
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    if (this.already != null) {
      data['already'] = this.already.map((v) => v.toJson()).toList();
    }
    if (this.none != null) {
      data['none'] = this.none.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HomeWorkRelease {
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
  String username;
  String gradeClass;

  HomeWorkRelease(
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
        this.name,this.username,this.gradeClass});

  HomeWorkRelease.fromJson(Map<String, dynamic> json) {
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
    username=json['username'];
    gradeClass=json['grade_class'];
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
    data['username']=this.username;
    data['grade_class']=this.gradeClass;
    return data;
  }
}

class Files {
  int id;
  int msgId;
  int receiveType;
  String address;
  int isDownload;
  String createTime;
  int schoolId;
  String fileName;
  String size;

  Files(
      {this.id,
        this.msgId,
        this.receiveType,
        this.address,
        this.isDownload,
        this.createTime,
        this.schoolId,
        this.fileName,
        this.size});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msgId = json['msg_id'];
    receiveType = json['receive_type'];
    address = json['address'];
    isDownload = json['is_download'];
    createTime = json['create_time'];
    schoolId = json['school_id'];
    fileName = json['file_name'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['msg_id'] = this.msgId;
    data['receive_type'] = this.receiveType;
    data['address'] = this.address;
    data['is_download'] = this.isDownload;
    data['create_time'] = this.createTime;
    data['school_id'] = this.schoolId;
    data['file_name'] = this.fileName;
    data['size'] = this.size;
    return data;
  }
}

class AlreadySend {
  int homeWorkStudentId;
  String username;
  int homeWorkId;
  int studentId;
  int scoreId;
  String head;
  String scoreName;

  AlreadySend(
      {this.homeWorkStudentId,
        this.username,
        this.homeWorkId,
        this.studentId,
        this.scoreId,
        this.head,
        this.scoreName});

  AlreadySend.fromJson(Map<String, dynamic> json) {
    homeWorkStudentId = json['home_work_student_id'];
    username = json['username'];
    homeWorkId = json['home_work_id'];
    studentId = json['student_id'];
    scoreId = json['score_id'];
    head = json['head'];
    scoreName = json['score_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_work_student_id'] = this.homeWorkStudentId;
    data['username'] = this.username;
    data['home_work_id'] = this.homeWorkId;
    data['student_id'] = this.studentId;
    data['score_id'] = this.scoreId;
    data['head'] = this.head;
    data['score_name'] = this.scoreName;
    return data;
  }
}

class NoneSend {
  String username;
  String head;

  NoneSend({this.username, this.head});

  NoneSend.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    head = json['head'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['head'] = this.head;
    return data;
  }
}

