
class Note {
  String title;
  String story;
  String date;
  Note({
    required this.title,
    required this.story,
    required this.date,
  });

  Map<String, String> toJson() => {
        'title': title,
        'story': story,
        'date': date,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(title: json['title'], story: json['story'], date: json['date']);
  }
}
