
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Delegators.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/Utils.dart';
import 'package:todo_app/domain/entity/HomeChildScreenItem.dart';
import 'package:todo_app/domain/entity/ViewLayoutInfo.dart';
import 'package:todo_app/presentation/home/HomeBloc.dart';
import 'package:todo_app/presentation/home/HomeState.dart';
import 'package:todo_app/presentation/pet/PetScreen.dart';
import 'package:todo_app/presentation/ranking/RankingScreen.dart';
import 'package:todo_app/presentation/settings/SettingsScreen.dart';
import 'package:todo_app/presentation/week/WeekScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin implements WeekBlocDelegator,
  SettingsBlocDelegator, RankingBlocDelegator {
  HomeBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final GlobalKey _petViewTabKey = GlobalKey();
  int _currentSeedAddedAnimationNumber;
  AnimationController _seedAddedAnimationController;

  final _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _bloc = HomeBloc(context);

    _seedAddedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        debugPrint('onMessage: $message');
        _bloc.onFirebaseMessageArrivedWhenForeground(context, message);
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        debugPrint('onLaunch: $message');
        return;
      },
      onResume: (Map<String, dynamic> message) {
        debugPrint('onResume: $message');
        return;
      },
      onBackgroundMessage: _backgroundMessageHandler,
    );
  }

  static Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final data = message['data'];
      debugPrint('background message data: $data');
    } else if (message.containsKey('notification')) {
      final notification = message['notification'];
      debugPrint('background message notification: $notification');
    }

    return;
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

  @override
  void dispose() {
    _seedAddedAnimationController.dispose();

    super.dispose();
    _bloc.dispose();
  }

  Widget _buildUI(HomeState state) {
    final petViewTabPosition = ViewLayoutInfo.create(
      _petViewTabKey.currentContext?.findRenderObject(),
      offset: Offset(0, -MediaQuery.of(context).padding.top)
    );

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      _ChildScreen(
                        childScreenKey: state.currentChildScreenKey,
                        weekBlocDelegator: this,
                        settingsBlocDelegator: this,
                        rankingBlocDelegator: this,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
                _BottomNavigationBar(
                  bloc: _bloc,
                  childScreenItems: state.childScreenItems,
                  petViewTabKey: _petViewTabKey,
                ),
              ],
            ),
            petViewTabPosition.isValid ? Positioned(
              left: petViewTabPosition.left,
              right: petViewTabPosition.right,
              top: petViewTabPosition.top,
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                  parent: _seedAddedAnimationController,
                  curve: Interval(0, 0.1, curve: Curves.ease),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
                    parent: _seedAddedAnimationController,
                    curve: Interval(0.8, 1, curve: Curves.ease),
                  )),
                  child: SlideTransition(
                    position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1)).animate(CurvedAnimation(
                      parent: _seedAddedAnimationController,
                      curve: Curves.ease,
                    )),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3,),
                        child: Text(
                          '+ $_currentSeedAddedAnimationNumber',
                          style: TextStyle(
                            color: AppColors.TEXT_WHITE,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ): const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  void showBottomSheet(void Function(BuildContext) builder, {
    void Function() onClosed
  }) {
    Utils.showBottomSheet(_scaffoldKey.currentState, builder, onClosed: onClosed);
  }

  @override
  void showSnackBar(String text, Duration duration) {
    Utils.showSnackBar(_scaffoldKey.currentState, text, duration);
  }

  @override
  void addBottomNavigationItemClickedListener(void Function(String key) listener) {
    _bloc.addBottomNavigationItemClickedListener(listener);
  }

  @override
  void removeBottomNavigationItemClickedListener(void Function(String key) listener) {
    _bloc.removeBottomNavigationItemClickedListener(listener);
  }

  @override
  void showSeedAddedAnimation(int number) {
    setState(() {
      _currentSeedAddedAnimationNumber = number;
    });

    _seedAddedAnimationController.reset();
    _seedAddedAnimationController.forward();
  }
}

class _ChildScreen extends StatelessWidget {
  final String childScreenKey;
  final WeekBlocDelegator weekBlocDelegator;
  final SettingsBlocDelegator settingsBlocDelegator;
  final RankingBlocDelegator rankingBlocDelegator;

  _ChildScreen({
    @required this.childScreenKey,
    @required this.weekBlocDelegator,
    @required this.settingsBlocDelegator,
    @required this.rankingBlocDelegator,
  });

  @override
  Widget build(BuildContext context) {
    switch (childScreenKey) {
      case HomeChildScreenItem.KEY_RECORD:
        return WeekScreen(
          weekBlocDelegator: weekBlocDelegator,
        );
      case HomeChildScreenItem.KEY_PET:
        return PetScreen();
      case HomeChildScreenItem.KEY_RANKING:
        return RankingScreen(
          rankingBlocDelegator: rankingBlocDelegator,
        );
      case HomeChildScreenItem.KEY_SETTINGS:
        return SettingsScreen(
          settingsBlocDelegator: settingsBlocDelegator,
        );
      default:
        return Container();
    }
  }
}

class _BottomNavigationBar extends StatelessWidget {
  final HomeBloc bloc;
  final List<HomeChildScreenItem> childScreenItems;
  final Key petViewTabKey;

  _BottomNavigationBar({
    @required this.bloc,
    @required this.childScreenItems,
    @required this.petViewTabKey,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 55,
        ),
        color: AppColors.BACKGROUND_WHITE,
        child: Row(
          children: List.generate(childScreenItems.length, (index) {
            final item = childScreenItems[index];
            return _BottomNavigationItem(
              key: item.key == HomeChildScreenItem.KEY_PET ? petViewTabKey : null,
              bloc: bloc,
              item: item,
            );
          }),
        ),
      )
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  final HomeBloc bloc;
  final HomeChildScreenItem item;

  _BottomNavigationItem({
    Key key,
    @required this.bloc,
    @required this.item,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context).getBottomNavigationTitle(item.key);
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => bloc.onBottomNavigationItemClicked(item.key),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: Image.asset(item.iconPath),
                  ),
                  SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: item.titleColor,
                      fontSize: 14,
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
