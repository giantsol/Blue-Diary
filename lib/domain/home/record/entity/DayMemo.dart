class DayMemo {

  final String dateString;
  final String content;

  const DayMemo(this.dateString, this.content);

  DayMemo getModified({
    String dateString,
    String content,
  }) {
    return DayMemo(
      dateString ?? this.dateString,
      content ?? this.content,
    );
  }

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateString,
      'content': content,
    };
  }

}