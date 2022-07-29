class MessageModel {
  String? dateTime;
  String? senderId;
  String? recieverId;
  String? text;

  MessageModel({
    this.dateTime,
    this.recieverId,
    this.senderId,
    this.text,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    recieverId = json['recieverId'];
    senderId = json['senderId'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'recieverId': recieverId,
      'senderId': senderId,
      'text': text,
    };
  }
}
