import 'package:bvu_dormitory/screens/admin/manage/manage.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminManageMenu extends StatefulWidget {
  AdminManageMenu({Key? key}) : super(key: key);

  @override
  _AdminManageMenuState createState() => _AdminManageMenuState();
}

class _AdminManageMenuState extends State<AdminManageMenu> {
  late AdminManageController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminManageController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: GridView.count(
        padding: EdgeInsets.only(top: 15),
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: MediaQuery.of(context).size.width / 400,
        children: List.generate(
          controller.menuItems.length,
          (index) => _menuItem(controller.menuItems[index]),
        ),
      ),
    );
  }

  _menuItem(ManageIconItem item) {
    return CupertinoButton(
      onPressed: () {
        Navigator.pushNamed(context, item.routeName);
      },
      child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            // color: Colors.grey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  item.iconPath,
                  height: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: Offset(2, 5),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              Text(
                item.title,
                // 'Abc',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
