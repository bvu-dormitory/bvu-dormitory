import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/constants/app.styles.dart';
import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/images/rooms.detail.images.controller.dart';

class AdminRoomsDetailImagesBody extends StatefulWidget {
  const AdminRoomsDetailImagesBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminRoomsDetailImagesBodyState();
}

class _AdminRoomsDetailImagesBodyState
    extends State<AdminRoomsDetailImagesBody> {
  late AdminRoomsDetailImagesController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch<AdminRoomsDetailImagesController>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tối đa 5 ảnh.',
          style: AppStyles.menuGroupTextStyle,
        ),
      ],
    );
  }
}
