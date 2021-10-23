import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          AppLocalizations.of(context)
                  ?.admin_manage_rooms_detail_images_maximum ??
              "admin_manage_rooms_detail_images_maximum",
          style: AppStyles.menuGroupTextStyle,
        ),
        // Expanded(child: _gridImages(context)),
      ],
    );
  }

  _gridImages(BuildContext context) {
    // return
    //  Consumer(builder: (context, controller, child) {
    //   return GridView.builder(
    //   gridDelegate:
    //       const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //       itemCount: controller.,
    //   itemBuilder: (context, index) {
    //     return _gridImageItem(index);
    //   },
    // );
    // },);
  }

  _gridImageItem(int index) {
    return CupertinoContextMenu(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {},
          child: Text('Xóa'),
        ),
      ],
      child: const Image(image: AssetImage('lib/assets/2805830.jpg')),
    );
  }
}
