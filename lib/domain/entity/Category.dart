
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/data/AppDatabase.dart';

class Category {
  static const ID_DEFAULT = -1;
  static const ID_NEW = -2;
  static const COLOR_DEFAULT = AppColors.BACKGROUND_GREY;
  static const COLOR_INVALID = const Color(0x00000000);

  static String createWhereQuery() => '${AppDatabase.COLUMN_ID} = ?';

  static List<dynamic> createWhereArgs(int id) => [
    id,
  ];

  static Category fromDatabase(Map<String, dynamic> map) {
    return Category(
      id: map[AppDatabase.COLUMN_ID] ?? -1,
      name: map[AppDatabase.COLUMN_NAME] ?? '',
      fillColor: map[AppDatabase.COLUMN_FILL_COLOR] != null ? Color(map[AppDatabase.COLUMN_FILL_COLOR]) : COLOR_INVALID,
      borderColor: map[AppDatabase.COLUMN_BORDER_COLOR] != null ? Color(map[AppDatabase.COLUMN_BORDER_COLOR]) : COLOR_INVALID,
      imagePath: map[AppDatabase.COLUMN_IMAGE_PATH] ?? '',
    );
  }

  final int id;
  final String name;
  final Color fillColor;
  final Color borderColor;
  final String imagePath;

  String get initial {
    if (id == ID_DEFAULT && fillColor == COLOR_DEFAULT) {
      return '';
    } else {
      return name.isEmpty ? '' : name[0];
    }
  }
  CategoryThumbnailType get thumbnailType {
    if (imagePath.length > 0) {
      return CategoryThumbnailType.IMAGE;
    } else if (borderColor != COLOR_INVALID) {
      return CategoryThumbnailType.BORDER;
    } else {
      return CategoryThumbnailType.FILL;
    }
  }

  const Category({
    this.id = ID_DEFAULT,
    this.name = '없음',
    this.fillColor = COLOR_DEFAULT,
    this.borderColor = COLOR_INVALID,
    this.imagePath = '',
  });

  Category buildNew({
    int id,
    String name,
    Color fillColor,
    Color borderColor,
    String imagePath,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toDatabase() {
    if (id == ID_DEFAULT) {
      return null;
    } else if (id == ID_NEW) {
      return {
        AppDatabase.COLUMN_NAME: name,
        AppDatabase.COLUMN_FILL_COLOR: fillColor.value,
        AppDatabase.COLUMN_BORDER_COLOR: borderColor.value,
        AppDatabase.COLUMN_IMAGE_PATH: imagePath,
      };
    } else {
      return {
        AppDatabase.COLUMN_ID: id,
        AppDatabase.COLUMN_NAME: name,
        AppDatabase.COLUMN_FILL_COLOR: fillColor.value,
        AppDatabase.COLUMN_BORDER_COLOR: borderColor.value,
        AppDatabase.COLUMN_IMAGE_PATH: imagePath,
      };
    }
  }
}

enum CategoryThumbnailType {
  IMAGE,
  BORDER,
  FILL
}