
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/Category.dart';
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
    return SafeArea(
      child: Material(
        child: Scaffold(
          floatingActionButton: state.stickyInputState == StickyInputState.HIDDEN ? FloatingActionButton(
            child: Image.asset('assets/ic_plus.png'),
            backgroundColor: AppColors.primary,
            splashColor: AppColors.primaryDark,
            onPressed: () => _bloc.onAddToDoClicked(),
          ) : null,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildHeader(state),
                  Expanded(
                    child: state.toDoRecords.length == 0 ? _buildEmptyToDosView(state) : _buildToDosView(state),
                  ),
                ],
              ),
              // 키보드 위 Sticky 입력창
              state.stickyInputState == StickyInputState.HIDDEN ? Container()
              : state.stickyInputState == StickyInputState.SHOWN_TODO ? _buildStickyEditorForToDo(state)
              : _buildStickyEditorForCategory(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DayState state) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/ic_back_arrow.png'),
          ),
          onTap: () => _bloc.onBackArrowClicked(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            state.title,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.textBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyToDosView(DayState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDayMemo(state),
        Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Text(
            'TODO',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textBlack,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '기록이 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textBlackLight,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDayMemo(DayState state) {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 6, right: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
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
                      color: AppColors.textWhite,
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
                      child: Image.asset('assets/ic_collapse.png'),
                    ),
                    onTap: () => _bloc.onDayMemoCollapseOrExpandClicked(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: SizedBox(
                height: 93,
                child: DayMemoTextField(
                  text: state.memoText,
                  hintText: state.memoHint,
                  onChanged: (s) => _bloc.onDayMemoTextChanged(s),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToDosView(DayState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDayMemo(state),
          Padding(
            padding: EdgeInsets.only(left: 18, top: 20),
            child: Text(
              'TODO',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textBlack,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 76),
            child: Column(
              children: List.generate(state.toDoRecords.length, (index) {
                return _buildToDo(state.toDoRecords[index], index == state.toDoRecords.length - 1);
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToDo(ToDoRecord toDoRecord, bool isLast) {
    final toDo = toDoRecord.toDo;
    final category = toDoRecord.category;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
        ),
        InkWell(
          child: Dismissible(
            key: Key(toDo.key),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColors.secondary,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 21, bottom: 16),
                  child: Image.asset('assets/ic_trash.png'),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 18,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _buildCategoryThumbnail(category, 36, 36, 18),
                ),
                SizedBox(width: 36),
                category.isDefault ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    toDo.text,
                    style: toDo.isDone ? TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlackLight,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.textBlackLight,
                      decorationThickness: 2,
                    ) : TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack,
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
                          color: AppColors.textBlackLight,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.textBlackLight,
                          decorationThickness: 2,
                        ) : TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlack,
                        ),
                      ),
                      SizedBox(height: 2,),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textBlackLight,
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
                            color: AppColors.textBlackLight,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                    customBorder: CircleBorder(),
                    onTap: () => _bloc.onToDoCheckBoxClicked(toDo),
                  ),
                ),
              ],
            )
          ),
          onTap: () {},
        ),
        isLast ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
        ) : Container(),
      ],
    );
  }

  Widget _buildCategoryThumbnail(Category category, double width, double height, double fontSize) {
    if (category == null) {
      return _buildDefaultCategoryThumbnail(width, height);
    } else {
      return category.isImageType ? _buildImageCategoryThumbnail(category, width, height)
        : category.isBorderType ? _buildBorderCategoryThumbnail(category, width, height, fontSize)
        : category.isFillType ? _buildFillCategoryThumbnail(category, width, height, fontSize)
        : _buildDefaultCategoryThumbnail(width, height);
    }
  }

  Widget _buildImageCategoryThumbnail(Category category, double width, double height) {
    return Container(
      width: width,
      height: height,
    );
  }

  Widget _buildBorderCategoryThumbnail(Category category, double width, double height, double fontSize) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(category.borderColor),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          category.initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }

  Widget _buildFillCategoryThumbnail(Category category, double width, double height, double fontSize) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(category.fillColor),
      ),
      child: Center(
        child: Text(
          category.initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultCategoryThumbnail(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundGrey,
      ),
    );
  }

  Widget _buildStickyEditorForToDo(DayState state) {
    final editingToDoRecord = state.editingToDoRecord;
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
                colors: [AppColors.divider, AppColors.divider.withAlpha(0)]
              )
            ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      child: _buildCategoryThumbnail(editingToDoRecord?.category, 24, 24, 14),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ToDoEditorTextField(
                          text: editingToDoRecord?.toDo != null ? editingToDoRecord.toDo.text : '',
                          hintText: editingToDoRecord == null ? '작업 추가' : '작업 수정',
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
                            editingToDoRecord == null ? '추가' : '수정',
                            style: TextStyle(
                              fontSize: 14,
                              color: state.toDoEditorText.length > 0 ? AppColors.primary : AppColors.textBlackLight,
                            ),
                          ),
                        ),
                        onTap: state.toDoEditorText.length > 0 ? () { } : null,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 10),
                  child: GestureDetector(
                    onTap: () { },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: AppColors.primary,
                      ),
                      child: Text(
                        '분류: ${editingToDoRecord?.category?.name ?? '없음'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStickyEditorForCategory(DayState state) {
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
                SizedBox(
                  height: 138,
                  child: ListView.builder(
                    itemCount: state.allCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.allCategories[index];
                      return Column(
                        children: <Widget>[
                          index == 0 ? SizedBox(height: 4,) : Container(),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 8,),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: _buildCategoryThumbnail(category, 24, 24, 14),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  category.isDefault ? '없음' : category.name,
                                  style: TextStyle(
                                    color: AppColors.textBlack,
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
                              color: AppColors.divider,
                            ),
                          ),
                          index == state.allCategories.length - 1 ? SizedBox(height: 4,) : Container(),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: AppColors.DIVIDER_DARK,
                ),
              ],
            ),
          )
        ),
      ],
    );
  }
}
