class StudentHomeWorkDetailsModel {
  String code;
  String msg;
  Data data;

  StudentHomeWorkDetailsModel({this.code, this.msg, this.data});

  StudentHomeWorkDetailsModel.fromJson(Map<String, dynamic> json) {
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
  Information information;
  List<Score> score;
  List<Files> files;
  RemarkFiles remarkFiles;

  Data({this.information, this.score, this.files, this.remarkFiles});

  Data.fromJson(Map<String, dynamic> json) {
    information = json['information'] != null
        ? new Information.fromJson(json['information'])
        : null;
    if (json['score'] != null) {
      score = new List<Score>();
      json['score'].forEach((v) {
        score.add(new Score.fromJson(v));
      });
    }
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    remarkFiles = json['remark_files'] != null
        ? new RemarkFiles.fromJson(json['remark_files'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.information != null) {
      data['information'] = this.information.toJson();
    }
    if (this.score != null) {
      data['score'] = this.score.map((v) => v.toJson()).toList();
    }
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    if (this.remarkFiles != null) {
      data['remark_files'] = this.remarkFiles.toJson();
    }
    return data;
  }
}

class Information {
  int id;
  int studentId;
  int homeWorkId;
  String content;
  String dtime;
  int isRemark;
  String remark;
  int scoreId;
  String remarkTime;
  String username;
  int inGrade;
  int inClass;
  String head;
  String gradeClass;

  Information(
      {this.id,
        this.studentId,
        this.homeWorkId,
        this.content,
        this.dtime,
        this.isRemark,
        this.remark,
        this.scoreId,
        this.remarkTime,
        this.username,
        this.inGrade,
        this.inClass,
        this.head,
        this.gradeClass});

  Information.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    homeWorkId = json['home_work_id'];
    content = json['content'];
    dtime = json['dtime'];
    isRemark = json['is_remark'];
    remark = json['remark'];
    scoreId = json['score_id'];
    remarkTime = json['remark_time'];
    username = json['username'];
    inGrade = json['in_grade'];
    inClass = json['in_class'];
    head = json['head'];
    gradeClass = json['grade_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['home_work_id'] = this.homeWorkId;
    data['content'] = this.content;
    data['dtime'] = this.dtime;
    data['is_remark'] = this.isRemark;
    data['remark'] = this.remark;
    data['score_id'] = this.scoreId;
    data['remark_time'] = this.remarkTime;
    data['username'] = this.username;
    data['in_grade'] = this.inGrade;
    data['in_class'] = this.inClass;
    data['head'] = this.head;
    data['grade_class'] = this.gradeClass;
    return data;
  }
}

class Score {
  int id;
  String scoreName;

  Score({this.id, this.scoreName});

  Score.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scoreName = json['score_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['score_name'] = this.scoreName;
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

class RemarkFiles {
  int remarkFilesId;
  String address;
  String voiceTime;

  RemarkFiles({this.remarkFilesId, this.address, this.voiceTime});

  RemarkFiles.fromJson(Map<String, dynamic> json) {
    remarkFilesId = json['remark_files_id'];
    address = json['address'];
    voiceTime = json['voice_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark_files_id'] = this.remarkFilesId;
    data['address'] = this.address;
    data['voice_time'] = this.voiceTime;
    return data;
  }
}
