
class ToDo {

  final String dateString;
  final int index;
  final String content;
  final bool isDone;

  const ToDo(this.dateString, this.index, {
    this.content = '',
    this.isDone = false,
  });

  Map<String, dynamic> toDatabaseFormat() {
    return {
      'date_string': dateString,
      'which': index,
      'content': content,
      'isDone': isDone ? 1 : 0,
    };
  }

}