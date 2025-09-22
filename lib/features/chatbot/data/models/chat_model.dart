class Chat {
  String? text;
  String? question;
  String? chatId;
  String? chatMessageId;
  bool? isStreamValid;
  String? sessionId;
  String? memoryType;
  String? userId;
  String? courseId;

  Chat({
    this.text,
    this.question,
    this.chatId,
    this.chatMessageId,
    this.isStreamValid,
    this.sessionId,
    this.memoryType,
    this.userId,
    this.courseId
  });

  Chat.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    question = json['question'];
    chatId = json['chatId'];
    chatMessageId = json['chatMessageId'];
    isStreamValid = (json['isStreamValid'] == 1) ? true : false;
    sessionId = json['sessionId'];
    memoryType = json['memoryType'];
    userId = json['userId'];
    courseId = json ['courseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['question'] = question;
    data['chatId'] = chatId;
    data['chatMessageId'] = chatMessageId;
    data['isStreamValid'] = isStreamValid == true ? 1 : 0;
    data['sessionId'] = sessionId;
    data['memoryType'] = memoryType;
    data['userId'] = userId;
    data['courseId'] = courseId;
    return data;
  }
}