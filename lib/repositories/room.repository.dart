import 'package:bvu_dormitory/base/base.firestore.repo.dart';

class RoomRepository extends FireStoreRepository {
  RoomRepository() : super(collectionPath: 'buildings');
}
