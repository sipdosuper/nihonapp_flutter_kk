class SendMail {
  final String from;
  final String to;
  final String subject; 
  final String text;

  SendMail({
    required this.from,
    required this.to,
    required this.subject,
    required this.text,
  });

  // Chuyển từ JSON sang Object (factory constructor)
  factory SendMail.fromJson(Map<String, dynamic> json) {
    return SendMail(
      from: json['from'],
      to: json['to'],
      subject: json['subject'], 
      text: json['text'],
    );
  }

  // Chuyển từ Object sang JSON (để gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'subject': subject, 
      'text': text,
    };
  }
}
