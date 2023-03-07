class Event {
  final int id;
  final int chatId;
  final String content;
  final bool isImage;
  final DateTime changeTime;
  final String? category;

  const Event({
    required this.id,
    required this.chatId,
    required this.content,
    required this.isImage,
    required this.changeTime,
    required this.category,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      chatId: map['chatId'],
      content: map['content'],
      isImage: map['isImage'],
      changeTime: map['changeTime'],
      category: map['category'],
    );
  } 

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'id': id,
      'chatId': chatId,
      'content': content,
      'isImage': isImage,
      'changeTime': changeTime,
      'category': category,
    };
  }
}