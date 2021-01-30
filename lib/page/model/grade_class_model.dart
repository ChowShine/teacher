class GradeClassModel {
  String code;
  String msg;
  Data data;

  GradeClassModel({this.code, this.msg, this.data});

  GradeClassModel.fromJson(Map<String, dynamic> json) {
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
  List<GradeClass> gradeClass;
  List<Subjects> subjects;
  List<SubjectClass> subjectClass;

  Data({this.gradeClass, this.subjects, this.subjectClass});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['grade_class'] != null) {
      gradeClass = new List<GradeClass>();
      json['grade_class'].forEach((v) {
        gradeClass.add(new GradeClass.fromJson(v));
      });
    }
    if (json['subjects'] != null) {
      subjects = new List<Subjects>();
      json['subjects'].forEach((v) {
        subjects.add(new Subjects.fromJson(v));
      });
    }
    if (json['subject_class'] != null) {
      subjectClass = new List<SubjectClass>();
      json['subject_class'].forEach((v) {
        subjectClass.add(new SubjectClass.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gradeClass != null) {
      data['grade_class'] = this.gradeClass.map((v) => v.toJson()).toList();
    }
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    if (this.subjectClass != null) {
      data['subject_class'] = this.subjectClass.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GradeClass {
  int gradeId;
  int classId;
  String gradeClass;
  List<Students> students;

  GradeClass({this.gradeId, this.classId, this.gradeClass, this.students});

  GradeClass.fromJson(Map<String, dynamic> json) {
    gradeId = json['grade_id'];
    classId = json['class_id'];
    gradeClass = json['grade_class'];
    if (json['students'] != null) {
      students = new List<Students>();
      json['students'].forEach((v) {
        students.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grade_id'] = this.gradeId;
    data['class_id'] = this.classId;
    data['grade_class'] = this.gradeClass;
    if (this.students != null) {
      data['students'] = this.students.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  int studentId;
  String studentName;
  String head;

  Students({this.studentId, this.studentName, this.head});

  Students.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    studentName = json['student_name'];
    head = json['head'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['student_name'] = this.studentName;
    data['head'] = this.head;
    return data;
  }
}

class Subjects {
  int subjectId;
  String subjectName;

  Subjects({this.subjectId, this.subjectName});

  Subjects.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    return data;
  }
}

class SubjectClass {
  int subjectId;
  String subjectName;
  List<GradeClass2> gradeClass;

  SubjectClass({this.subjectId, this.subjectName, this.gradeClass});

  SubjectClass.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    if (json['grade_class'] != null) {
      gradeClass = new List<GradeClass2>();
      json['grade_class'].forEach((v) {
        gradeClass.add(new GradeClass2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    if (this.gradeClass != null) {
      data['grade_class'] = this.gradeClass.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GradeClass2 {//为了区分学科对应的 班级
  int gradeId;
  int classId;
  String gradeClass;

  GradeClass2({this.gradeId, this.classId, this.gradeClass});

  GradeClass2.fromJson(Map<String, dynamic> json) {
    gradeId = json['grade_id'];
    classId = json['class_id'];
    gradeClass = json['grade_class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grade_id'] = this.gradeId;
    data['class_id'] = this.classId;
    data['grade_class'] = this.gradeClass;
    return data;
  }
}
