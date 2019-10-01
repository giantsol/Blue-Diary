
import 'package:todo_app/data/AppDatabase.dart';

class Category {
  static const ID_NONE = -1;
  static const INVALID_COLOR = 0;

  static String createWhereQuery() => '${AppDatabase.COLUMN_ID} = ?';

  static List<dynamic> createWhereArgs(Category category) => [
    category.id,
  ];

  static Category fromDatabase(Map<String, dynamic> map) {
    return Category(
      id: map[AppDatabase.COLUMN_ID] ?? -1,
      name: map[AppDatabase.COLUMN_NAME] ?? '',
      fillColor: map[AppDatabase.COLUMN_FILL_COLOR] ?? INVALID_COLOR,
      borderColor: map[AppDatabase.COLUMN_BORDER_COLOR] ?? INVALID_COLOR,
      imagePath: map[AppDatabase.COLUMN_IMAGE_PATH] ?? '',
    );
  }

  final int id;
  final String name;
  final int fillColor;
  final int borderColor;
  final String imagePath;

  String get initial => name[0];
  bool get isDefault => id == ID_NONE;
  bool get isImageType => imagePath.length > 0;
  bool get isBorderType => borderColor != INVALID_COLOR;
  bool get isFillType => fillColor != INVALID_COLOR;

  const Category({
    this.id = ID_NONE,
    this.name = '',
    this.fillColor = INVALID_COLOR,
    this.borderColor = INVALID_COLOR,
    this.imagePath = '',
  });

  Map<String, dynamic> toDatabase() {
    return {
      AppDatabase.COLUMN_ID: id,
      AppDatabase.COLUMN_NAME: name,
      AppDatabase.COLUMN_FILL_COLOR: fillColor,
      AppDatabase.COLUMN_BORDER_COLOR: borderColor,
      AppDatabase.COLUMN_IMAGE_PATH: imagePath,
    };
  }
}