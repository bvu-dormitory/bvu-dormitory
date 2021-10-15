import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/screens/admin/manage/manage.controller.dart';
import 'package:bvu_dormitory/screens/admin/manage/widgets/manage.menu.dart';
import 'package:bvu_dormitory/screens/admin/manage/widgets/manage.search.dart';
import 'package:bvu_dormitory/services/repositories/user.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AdminManageScreen extends StatefulWidget {
  AdminManageScreen({Key? key}) : super(key: key);

  @override
  _AdminManageScreenState createState() => _AdminManageScreenState();
}

class _AdminManageScreenState extends State<AdminManageScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageController(context: _),
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    elevation: 3,
                    expandedHeight: 150,
                    centerTitle: false,
                    titleSpacing: 30,
                    // leading: Icon(Icons.menu),
                    title: StreamBuilder<AppUser?>(
                      stream: UserRepository.getCurrentFireStoreUserStream(),
                      builder: (context, snapshot) => Text(
                        "Xin chào, ${snapshot.data?.name}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // stretch: true,
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.light,
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/2805830.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.topLeft,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
            body: Container(
              color: Colors.grey.withOpacity(0.15),
              child: Column(
                children: [
                  Expanded(
                    child: AdminManageMenu(),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
