
import 'package:todo_app/domain/entity/RankingUserInfo.dart';

class RankingUserInfosEvent {
  final List<RankingUserInfo> rankingUserInfos;
  final bool hasMore;

  const RankingUserInfosEvent({
    this.rankingUserInfos = const [],
    this.hasMore = false,
  });
}