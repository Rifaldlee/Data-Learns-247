class QP {
  const QP._();

  static Map<String, String> detailArticleQP({required String id}) => {'id': id };
  static Map<String, String> detailCourseQP({required String id}) => {'id': id };
  static Map<String, String> lessonQP({required String id}) => {'id': id };
  static Map<String, String> searchQP({required String query}) => {'q': query };
}