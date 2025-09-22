class Certificates {
  String? certificateId;
  List<String>? courseId;
  String? courseName;
  String? certificateUrl;
  String? issuedOn;
  String? expiredOn;
  String? certificateFile;

  Certificates({
    this.certificateId,
    this.courseId,
    this.courseName,
    this.certificateUrl,
    this.issuedOn,
    this.expiredOn,
    this.certificateFile
  });

  Certificates.fromJson(Map<String, dynamic> json) {
    certificateId = json['certificate_id'];
    courseId = json['course_id'].cast<String>();
    courseName = json['course_name'];
    certificateUrl = json['certificate_url'];
    issuedOn = json['issued_on'];
    expiredOn = json['expired_on'];
    certificateFile = json['certificate_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['certificate_id'] = certificateId;
    data['course_id'] = courseId;
    data['course_name'] = courseName;
    data['certificate_url'] = certificateUrl;
    data['issued_on'] = issuedOn;
    data['expired_on'] = expiredOn;
    data['certificate_file'] = certificateFile;
    return data;
  }
}