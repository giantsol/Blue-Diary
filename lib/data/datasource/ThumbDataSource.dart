
abstract class ThumbDataSource {
  Future<void> removeThumbedUpUid(String uid);
  Future<void> addThumbedUpUid(String uid);
  Future<bool> isThumbedUpUid(String uid);
}