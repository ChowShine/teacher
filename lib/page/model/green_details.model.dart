class GreenDetailsModel {
  String code;
  String msg;
  Data data;

  GreenDetailsModel({this.code, this.msg, this.data});

  GreenDetailsModel.fromJson(Map<String, dynamic> json) {
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
  Message message;
  Content content;
  List<Address> address;

  Data({this.message, this.content, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String username;
  int inGrade;
  int inClass;
  String stationName;
  String learnCardName;
  String semesterName;
  String projectsName;
  String gradeClass;

  Message(
      {this.username,
        this.inGrade,
        this.inClass,
        this.stationName,
        this.learnCardName,
        this.semesterName,
        this.projectsName,
        this.gradeClass});

  Message.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    inGrade = json['in_grade'];
    inClass = json['in_class'];
    stationName = json['station_name'];
    learnCardName = json['learn_card_name'];
    semesterName = json['semester_name'];
    projectsName = json['projects_name'];
    gradeClass = json['grade_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['in_grade'] = this.inGrade;
    data['in_class'] = this.inClass;
    data['station_name'] = this.stationName;
    data['learn_card_name'] = this.learnCardName;
    data['semester_name'] = this.semesterName;
    data['projects_name'] = this.projectsName;
    data['grade_class'] = this.gradeClass;
    return data;
  }
}

class Content {
  int id;
  int studentId;
  int type;
  String content;
  int score;
  int userId;
  int subjectId;
  String dtime;
  int learnCardId;
  int stationId;
  int projectId;
  int groupId;
  int schoolId;

  Content(
      {this.id,
        this.studentId,
        this.type,
        this.content,
        this.score,
        this.userId,
        this.subjectId,
        this.dtime,
        this.learnCardId,
        this.stationId,
        this.projectId,
        this.groupId,
        this.schoolId});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    type = json['type'];
    content = json['content'];
    score = json['score'];
    userId = json['user_id'];
    subjectId = json['subject_id'];
    dtime = json['dtime'];
    learnCardId = json['learn_card_id'];
    stationId = json['station_id'];
    projectId = json['project_id'];
    groupId = json['group_id'];
    schoolId = json['school_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['type'] = this.type;
    data['content'] = this.content;
    data['score'] = this.score;
    data['user_id'] = this.userId;
    data['subject_id'] = this.subjectId;
    data['dtime'] = this.dtime;
    data['learn_card_id'] = this.learnCardId;
    data['station_id'] = this.stationId;
    data['project_id'] = this.projectId;
    data['group_id'] = this.groupId??1111;
    data['school_id'] = this.schoolId;
    return data;
  }
}

class Address {
  String address;
  int    id;

  Address({this.address,this.id});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    id=json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['id'] = this.id;
    return data;
  }
}
