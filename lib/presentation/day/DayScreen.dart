
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayMemo.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/presentation/day/DayBloc.dart';
import 'package:todo_app/presentation/day/DayState.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';
import 'package:todo_app/presentation/widgets/ToDoEditorTextField.dart';

class DayScreen extends StatefulWidget {
  final DayRecord dayRecord;

  DayScreen({
    Key key,
    this.dayRecord,
  }): super(key: key);

  @override
  State createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DayBloc(widget.dayRecord);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
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
                  editingCategory: state.editingToDoRecord.category,
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

  _ToDoListView({
    @required this.bloc,
    @required this.dayMemo,
    @required this.toDoRecords,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 76),
            child: Column(
              children: List.generate(toDoRecords.length, (index) {
                return _ToDoItem(
                  bloc: bloc,
                  toDoRecord: toDoRecords[index],
                  isLast: index == toDoRecords.length - 1,
                );
              }),
            ),
          )
        ],
      ),
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
                category.isNone ? Padding(
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
                Spacer(),
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
          onTap: () {},
        ),
        isLast ? _ToDoItemDivider() : const SizedBox.shrink(),
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
        height: 2,
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
    final type = category.type;
    switch (type) {
      case CategoryType.IMAGE:
        return _ImageCategoryThumbnail(
          imagePath: category.imagePath,
          width: width,
          height: height
        );
      case CategoryType.BORDER:
        return _BorderCategoryThumbnail(
          color: category.borderColor,
          initial: category.initial,
          width: width,
          height: height,
          fontSize: fontSize,
        );
      case CategoryType.FILL:
        return _FillCategoryThumbnail(
          color: category.fillColor,
          initial: category.initial,
          width: width,
          height: height,
          fontSize: fontSize,
        );
      default:
        return _DefaultCategoryThumbnail(
          width: width,
          height: height,
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
      height: height
    );
  }
}

class _BorderCategoryThumbnail extends StatelessWidget {
  final int color;
  final String initial;
  final double width;
  final double height;
  final double fontSize;

  _BorderCategoryThumbnail({
    @required this.color,
    @required this.initial,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(color),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.TEXT_BLACK,
          ),
        ),
      ),
    );
  }
}

class _FillCategoryThumbnail extends StatelessWidget {
  final int color;
  final String initial;
  final double width;
  final double height;
  final double fontSize;

  _FillCategoryThumbnail({
    @required this.color,
    @required this.initial,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(color),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.TEXT_WHITE,
          ),
        ),
      ),
    );
  }
}

class _DefaultCategoryThumbnail extends StatelessWidget {
  final double width;
  final double height;

  _DefaultCategoryThumbnail({
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.BACKGROUND_GREY,
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
            height: 2,
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
                  categoryName: editingToDoRecord.category.displayName,
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
              hintText: editingToDoRecord.isValid ? '작업 수정' : '작업 추가',
              onChanged: (s) => { },
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                editingToDoRecord.isValid ? '수정' : '추가',
                style: TextStyle(
                  fontSize: 14,
                  color: toDo.text.length > 0 ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
                ),
              ),
            ),
            onTap: toDo.text.length > 0 ? () { } : null,
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
        onTap: () { },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: AppColors.PRIMARY,
          ),
          child: Text(
            '분류: $categoryName',
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

  _CategoryEditorContainer({
    @required this.bloc,
    @required this.allCategories,
    @required this.editingCategory,
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
                  height: 2,
                  color: AppColors.DIVIDER_DARK,
                ),
                Column(
                  children: <Widget>[
                    _CategoryEditor(
                      bloc: bloc,
                      category: editingCategory,
                    )
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
    return SizedBox(
      height: 138,
      child: ListView.builder(
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          return Column(
            children: <Widget>[
              index == 0 ? SizedBox(height: 4,) : Container(),
              Row(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Text(
                      category.displayName,
                      style: TextStyle(
                        color: AppColors.TEXT_BLACK,
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  height: 2,
                  color: AppColors.DIVIDER,
                ),
              ),
              index == allCategories.length - 1 ? SizedBox(height: 4,) : const SizedBox.shrink(),
            ],
          );
        },
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
    return Row(
      children: <Widget>[
        _CategoryThumbnail(
          category: category,
          width: 24,
          height: 24,
          fontSize: 14
        ),
        Expanded(
          child: ToDoEditorTextField(
            text: category.name,
            onChanged: (s) => bloc.onEditingCategoryTextChanged(s),
          ),
        ),
        Text(
          '새로 생성',
          style: TextStyle(
            fontSize: 14,
            color: category.name.length > 0 ? AppColors.PRIMARY : AppColors.TEXT_BLACK_LIGHT,
          ),
        ),
        Text(
          '수정',
          style: TextStyle(
            fontSize: 14,
            color: category.isNone ? AppColors.TEXT_BLACK_LIGHT : AppColors.SECONDARY,
          )
        ),
      ],
    );
  }
}
