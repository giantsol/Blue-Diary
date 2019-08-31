
class WeekMemo {

  final String dateString;
  final int index;
  final String content;

  const WeekMemo(this.dateString, this.index, {
    this.content = '',
  });

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateString,
      'which': index,
      'content': content,
    };
  }

}