
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/CategoryPicker.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/presentation/day/DayBloc.dart';
import 'package:todo_app/presentation/day/DayState.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';
import 'package:todo_app/presentation/widgets/ToDoEditorTextField.dart';

class DayScreen extends StatefulWidget {
  final DateTime date;

  DayScreen({
    @required this.date,
  });

  @override
  State createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DayBloc _bloc;
  ScrollController _toDoScrollController;

  @override
  void initState() {
    super.initState();
    _bloc = DayBloc(widget.date);
    _toDoScrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _toDoScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(DayState state) {
      if (state.scrollToBottomEvent) {
        SchedulerBinding.instance.addPostFrameCallback((duration) {
          if (_toDoScrollController.hasClients) {
            _toDoScrollController.position.jumpTo(
              _toDoScrollController.position.maxScrollExtent,
            );
          }
        });
      }

      if (state.scrollToToDoListEvent) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_toDoScrollController.hasClients) {
            final double targetPixel = state.isMemoExpanded ? 170 : 70;
            if (_toDoScrollController.position.pixels < targetPixel) {
              _toDoScrollController.position.animateTo(
                targetPixel,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        });
      }

    return WillPopScope(
      onWillPop: () async => _bloc.onWillPopScope(),
      child: SafeArea(
        child: Material(
          child: Scaffold(
            floatingActionButton: state.isFabVisible ? _FAB(
              bloc: _bloc,
            ) : null,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _Header(
                      bloc: _bloc,
                      title: state.title,
                    ),
                    Expanded(
                      child: state.toDoRecords.length == 0 ? _EmptyToDoListView(
                        bloc: _bloc,
                        dayMemo: state.dayMemo,
                      ) : _ToDoListView(
                        bloc: _bloc,
                        dayMemo: state.dayMemo,
                        toDoRecords: state.toDoRecords,
                        scrollController: _toDoScrollController,
                      ),
                    ),
                  ],
                ),
                // 키보드 위 입력창
                state.editorState == EditorState.HIDDEN ? const SizedBox.shrink()
                  : state.editorState == EditorState.SHOWN_TODO ? _ToDoEditorContainer(
                  bloc: _bloc,
                  editingToDoRecord: state.editingToDoRecord,
                ) : _CategoryEditorContainer(
                  bloc: _bloc,
                  allCategories: state.allCategories,
                  editingCategory: state.editingCategory,
                  categoryPickers: state.categoryPickers,
                  selectedPickerIndex: state.selectedPickerIndex,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FAB extends StatelessWidget {
  final DayBloc bloc;

  _FAB({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Image.asset('assets/ic_plus.png'),
      backgroundColor: AppColors.PRIMARY,
      splashColor: AppColors.PRIMARY_DARK,
      onPressed: () => bloc.onAddToDoClicked(context),
    );
  }
}

class _Header extends StatelessWidget {
  final DayBloc bloc;
  final String title;

  _Header({
    @required this.bloc,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/ic_back_arrow.png'),
          ),
          onTap: () => bloc.onBackArrowClicked(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.TEXT_BLACK,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyToDoListView extends StatelessWidget {
  final DayBloc bloc;
  final DayMemo dayMemo;

  _EmptyToDoListView({
    @required this.bloc,
    @required this.dayMemo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DayMemo(
          bloc: bloc,
          dayMemo: dayMemo,
        ),
        Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Text(
            'TODO',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.TEXT_BLACK,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '기록이 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.TEXT_BLACK_LIGHT,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _DayMemo extends StatelessWidget {
  final DayBloc bloc;
  final DayMemo dayMemo;

  _DayMemo({
    @required this.bloc,
    @required this.dayMemo,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = dayMemo.isExpanded;
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 6, right: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.PRIMARY,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'MEMO',
                    style: TextStyle(
                      color: AppColors.TEXT_WHITE,
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      child: isExpanded ? Image.asset('assets/ic_collapse.png') : Image.asset('assets/ic_expand.png'),
                    ),
                    behavior: HitTestBehavior.translucent,
                    onTap: () => bloc.onDayMemoCollapseOrExpandClicked(),
                  ),
                )
              ],
            ),
            isExpanded ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: SizedBox(
                height: 93,
                child: DayMemoTextField(
                  text: dayMemo.text,
                  hintText: dayMemo.hint,
                  onChanged: (s) => bloc.onDayMemoTextChanged(s),
                ),
              ),
            ) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _ToDoListView extends StatelessWidget {
  final DayBloc bloc;
  final DayMemo dayMemo;
  final List<ToDoRecord> toDoRecords;
  final ScrollController scrollController;

  _ToDoListView({
    @required this.bloc,
    @required this.dayMemo,
    @required this.toDoRecords,
    @required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: toDoRecords.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _DayMemo(
            bloc: bloc,
            dayMemo: dayMemo,
          );
        } else if (index == 1) {
          return Padding(
            padding: EdgeInsets.only(left: 18, top: 20, bottom: 12),
            child: Text(
              'TODO',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.TEXT_BLACK,
              ),
            ),
          );
        } else {
          final realIndex = index - 2;
          return _ToDoItem(
            bloc: bloc,
            toDoRecord: toDoRecords[realIndex],
            isLast: realIndex == toDoRecords.length - 1,
          );
        }
      },
    );
  }
}

class _ToDoItem extends StatelessWidget {
  final DayBloc bloc;
  final ToDoRecord toDoRecord;
  final bool isLast;

  _ToDoItem({
    @required this.bloc,
    @required this.toDoRecord,
    @required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final toDo = toDoRecord.toDo;
    final category = toDoRecord.category;
    return Column(
      children: <Widget>[
        _ToDoItemDivider(),
        InkWell(
          child: Dismissible(
            key: Key(toDo.key),
            direction: DismissDirection.endToStart,
            background: _ToDoItemDismissibleBackground(),
            onDismissed: (direction) => bloc.onToDoRecordDismissed(toDoRecord),
            child: Row(
              children: <Widget>[
                SizedBox(width: 18,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _CategoryThumbnail(
                    category: category,
                    width: 36,
                    height: 36,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 36),
                Expanded(
                  child: category.id == Category.ID_DEFAULT ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      toDo.text,
                      style: toDo.isDone ? TextStyle(
                        fontSize: 14,
                        color: AppColors.TEXT_BLACK_LIGHT,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.TEXT_BLACK_LIGHT,
                        decorationThickness: 2,
                      ) : TextStyle(
                        fontSize: 14,
                        color: AppColors.TEXT_BLACK,
                      ),
                    ),
                  ) : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          toDo.text,
                          style: toDo.isDone ? TextStyle(
                            fontSize: 14,
                            color: AppColors.TEXT_BLACK_LIGHT,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.TEXT_BLACK_LIGHT,
                            decorationThickness: 2,
                          ) : TextStyle(
                            fontSize: 14,
                            color: AppColors.TEXT_BLACK,
                          ),
                        ),
                        SizedBox(height: 2,),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.TEXT_BLACK_LIGHT,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                toDo.isDone ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 19),
                  child: Image.asset('assets/ic_check.png'),
                ) : Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 14),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.TEXT_BLACK_LIGHT,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                    customBorder: CircleBorder(),
                    onTap: () => bloc.onToDoCheckBoxClicked(toDo),
                  ),
                ),
              ],
            )
          ),
          onTap: () => bloc.onToDoRecordItemClicked(toDoRecord),
        ),
        isLast ? _ToDoItemDivider() : const SizedBox.shrink(),
        isLast ? const SizedBox(height: 96) : const SizedBox.shrink(),
      ],
    );
  }
}

class _ToDoItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        height: 1,
        color: AppColors.DIVIDER,
      ),
    );
  }
}

class _ToDoItemDismissibleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.SECONDARY,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 21, bottom: 16),
          child: Image.asset('assets/ic_trash.png'),
        ),
      ),
    );
  }
}

class _CategoryThumbnail extends StatelessWidget {
  final Category category;
  final double width;
  final double height;
  final double fontSize;

  _CategoryThumbnail({
    @required this.category,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final type = category.thumbnailType;
    switch (type) {
      case CategoryThumbnailType.IMAGE:
        return _ImageCategoryThumbnail(
          imagePath: category.imagePath,
          width: width,
          height: height
        );
      default:
        return _ColorCategoryThumbnail(
          fillColor: category.fillColor,
          borderColor: category.borderColor,
          initial: category.initial,
          width: width,
          height: height,
          fontSize: fontSize,
        );
    }
  }
}

class _ImageCategoryThumbnail extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  _ImageCategoryThumbnail({
    @required this.imagePath,
    @required this.width,
    @required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(imagePath)),
        )
      ),
    );
  }
}

class _ColorCategoryThumbnail extends StatelessWidget {
  final Color fillColor;
  final Color borderColor;
  final String initial;
  final double width;
  final double height;
  final double fontSize;

  _ColorCategoryThumbnail({
    @required this.fillColor,
    @required this.borderColor,
    @required this.initial,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isFill = fillColor != Category.COLOR_INVALID;
    return Container(
      width: width,
      height: height,
      decoration: isFill ? BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
      ) : BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            color: isFill ? AppColors.TEXT_WHITE : AppColors.TEXT_BLACK,
          ),
        ),
      ),
    );
  }
}

class _ToDoEditorContainer extends StatelessWidget {
  final DayBloc bloc;
  final ToDoRecord editingToDoRecord;

  _ToDoEditorContainer({
    @required this.bloc,
    @required this.editingToDoRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.DIVIDER, AppColors.DIVIDER.withAlpha(0)]
              )
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.DIVIDER,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ToDoEditor(
                  bloc: bloc,
                  editingToDoRecord: editingToDoRecord,
                ),
                _ToDoEditorCategoryButton(
                  bloc: bloc,
                  categoryName: editingToDoRecord.category.name,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ToDoEditor extends StatelessWidget {
  final DayBloc bloc;
  final ToDoRecord editingToDoRecord;

  _ToDoEditor({
    @required this.bloc,
    @required this.editingToDoRecord,
  });

  @override
  Widget build(BuildContext context) {
    final category = editingToDoRecord.category;
    final toDo = editingToDoRecord.toDo;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: _CategoryThumbnail(
            category: category,
            width: 24,
            height: 24,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ToDoEditorTextField(
              text: toDo.text,
              hintText: editingToDoRecord.isDraft ? '작업 추가' : '작업 수정' ,
              onChanged: (s) => bloc.onEditingToDoTextChanged(s),
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                editingToDoRecord.isDraft ? '추가' : '수정',
                style: TextStyle(
                  fontSize: 14,
                  color: toDo.text.length > 0 ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
                ),
              ),
            ),
            onTap: toDo.text.length > 0 ? () => bloc.onToDoEditingDone() : null,
          ),
        )
      ],
    );
  }
}

class _ToDoEditorCategoryButton extends StatelessWidget {
  final DayBloc bloc;
  final String categoryName;

  _ToDoEditorCategoryButton({
    @required this.bloc,
    @required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => bloc.onEditorCategoryButtonClicked(),
        child: Container(
          padding: const EdgeInsets.all(5),
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: AppColors.PRIMARY,
          ),
          child: Text(
            '카테고리: $categoryName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.TEXT_WHITE,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryEditorContainer extends StatelessWidget {
  final DayBloc bloc;
  final List<Category> allCategories;
  final Category editingCategory;
  final List<CategoryPicker> categoryPickers;
  final int selectedPickerIndex;

  _CategoryEditorContainer({
    @required this.bloc,
    @required this.allCategories,
    @required this.editingCategory,
    @required this.categoryPickers,
    @required this.selectedPickerIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppColors.SCRIM,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _CategoryEditorCategoryList(
                  bloc: bloc,
                  allCategories: allCategories,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.DIVIDER_DARK,
                ),
                Column(
                  children: <Widget>[
                    _CategoryEditor(
                      bloc: bloc,
                      category: editingCategory,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: <Widget>[
                          _ChoosePhotoButton(
                            bloc: bloc,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 28,
                              child: ListView.builder(
                                itemCount: categoryPickers.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final categoryPicker = categoryPickers[index];
                                  return _CategoryPickerItem(
                                    bloc: bloc,
                                    item: categoryPicker,
                                    isSelected: index == selectedPickerIndex,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ),
      ],
    );
  }
}

class _CategoryEditorCategoryList extends StatelessWidget {
  final DayBloc bloc;
  final List<Category> allCategories;

  _CategoryEditorCategoryList({
    @required this.bloc,
    @required this.allCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 138,
        child: ListView.builder(
          itemCount: allCategories.length,
          itemBuilder: (context, index) {
            final category = allCategories[index];
            return Column(
              children: <Widget>[
                index == 0 ? SizedBox(height: 4,) : Container(),
                InkWell(
                  onTap: () => bloc.onCategoryEditorCategoryClicked(category),
                  onLongPress: () => bloc.onCategoryEditorCategoryLongClicked(context, category),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 8,),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: _CategoryThumbnail(
                          category: category,
                          width: 24,
                          height: 24,
                          fontSize: 14),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: AppColors.TEXT_BLACK,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: AppColors.DIVIDER,
                  ),
                ),
                index == allCategories.length - 1 ? SizedBox(height: 4,) : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoryEditor extends StatelessWidget {
  final DayBloc bloc;
  final Category category;

  _CategoryEditor({
    @required this.bloc,
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final addButtonEnabled = category.name.length > 0;
    final modifyButtonEnabled = category.id != Category.ID_DEFAULT && category.name.length > 0;
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: _CategoryThumbnail(
              category: category,
              width: 24,
              height: 24,
              fontSize: 14
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ToDoEditorTextField(
                text: category.name,
                hintText: '카테고리 이름 입력',
                onChanged: (s) => bloc.onEditingCategoryTextChanged(s),
              ),
            ),
          ),
          InkWell(
            onTap: addButtonEnabled ? bloc.onCreateNewCategoryClicked : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                '새로 생성',
                style: TextStyle(
                  fontSize: 14,
                  color: addButtonEnabled ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
                ),
                strutStyle: StrutStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: modifyButtonEnabled ? bloc.onModifyCategoryClicked : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                '수정',
                style: TextStyle(
                  fontSize: 14,
                  color: modifyButtonEnabled ? AppColors.SECONDARY : AppColors.TEXT_BLACK_LIGHT,
                ),
                strutStyle: StrutStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoosePhotoButton extends StatelessWidget {
  final DayBloc bloc;

  _ChoosePhotoButton({
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, top: 2, right: 10, bottom: 2),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => bloc.onChoosePhotoClicked(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: AppColors.PRIMARY,
          ),
          child: Text(
            '사진선택',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.TEXT_WHITE,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPickerItem extends StatelessWidget {
  final DayBloc bloc;
  final CategoryPicker item;
  final bool isSelected;

  _CategoryPickerItem({
    @required this.bloc,
    @required this.item,
    @required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final checkAssetName = item.isFillType ? 'assets/ic_check_white.png' : 'assets/ic_check_black.png';
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => bloc.onCategoryPickerSelected(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Container(
          width: 24,
          height: 24,
          decoration: item.isFillType ? BoxDecoration(
            shape: BoxShape.circle,
            color: item.color,
          ) : BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: item.color,
              width: 2,
            ),
          ),
          child: isSelected ? Image.asset(checkAssetName) : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
