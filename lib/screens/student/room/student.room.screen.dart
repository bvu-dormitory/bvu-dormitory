import 'dart:developer';
import 'dart:ui';

import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/invoices/add/rooms.detail.invoices.add.screen.dart';
import 'package:bvu_dormitory/screens/student/room/invoices/detail/student.invoices.detail.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bvu_dormitory/app/app.controller.dart';
import 'package:bvu_dormitory/app/constants/app.colors.dart';
import 'package:bvu_dormitory/models/invoice.dart';
import 'package:bvu_dormitory/repositories/invoice.repository.dart';
import 'package:bvu_dormitory/screens/student/home/student.home.controller.dart';
import 'package:bvu_dormitory/models/room.dart';
import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/repositories/room.repository.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'members/student.members.screen.dart';
import 'student.room.controller.dart';

class StudentRoomScreen extends BaseScreen<StudentRoomController> {
  StudentRoomScreen({Key? key, String? previousPageTitle})
      : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: false);

  late final Student student;

  @override
  StudentRoomController provideController(BuildContext context) {
    return StudentRoomController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_room,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    student = context.read<StudentHomeController>().student;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );

    return SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roomHeader(),
              Flexible(
                child: _roomBody(student),
              ),
            ],
          ),
        ));
  }

  _roomHeader() {
    _appNameSection() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset('lib/assets/icons/buildings.png', width: 20),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.app_name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('lib/assets/icons/user.png'),
          ),
        ],
      );
    }

    _nameSection() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<Room>(
                  future: RoomRepository.loadRoomFromRef(student.room!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SelectableText(
                        AppLocalizations.of(context)!.admin_manage_room + ' ' + snapshot.data!.name + ".",
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      );
                    }

                    return const CupertinoActivityIndicator(radius: 10);
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        AppLocalizations.of(context)!.admin_manage_welcome + ' ' + student.fullName,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('👋', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
          // const CircleAvatar(
          //   backgroundColor: Colors.amber,
          //   radius: 20,
          //   backgroundImage: AssetImage('lib/assets/icons/default-user.png'),
          // ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image(
          image: Image.asset('lib/assets/kytucxa-new.jpeg').image,
          fit: BoxFit.cover,
          height: 230,
          width: double.infinity,
          alignment: Alignment.topRight,
        ),
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 20, right: 20, bottom: 125),
            decoration: BoxDecoration(
              gradient: AppColor.mainAppBarGradientColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 20,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _appNameSection(),
                const SizedBox(height: 20),
                _nameSection(),
              ],
            ),
          ),
        ),

        // Invoice card
        Positioned(
          left: 0,
          right: 0,
          bottom: -70,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: _roomCurrentInvoice(),
          ),
        ),
      ],
    );
  }

  _roomBody(Student student) {
    final controller = context.read<StudentRoomController>();

    return FutureBuilder<Room>(
      future: RoomRepository.loadRoomFromRef(student.room!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          controller.room = snapshot.data!;

          return Container(
            padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Flexible(
                //       child: _roomRepairCard(snapshot.data!),
                //     ),
                //     const SizedBox(width: 40),
                //     Flexible(
                //       child: _roomActiveMembers(snapshot.data!),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 50),
                _roomBodyMenuGroups(snapshot.data!),
              ],
            ),
          );
        }

        return const CupertinoActivityIndicator(radius: 10);
      },
    );
  }

  _roomBodyMenuGroups(Room room) {
    final controller = context.read<StudentRoomController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        controller.menuGroups.length,
        (index) => Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: controller.menuGroups[index],
        ),
      ),
    );
  }

  _roomCurrentInvoice() {
    final controller = context.read<StudentRoomController>();

    _invoiceCard(Room room, Invoice? invoice) {
      return CupertinoButton(
        onPressed: () {
          if (invoice != null) {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => AdminRoomsDetailInvoicesAddScreen(
                room: room,
                invoice: invoice,
                previousPageTitle: AppLocalizations.of(context)!.admin_manage_room + ' ' + room.name,
                student: student,
              ),
            ));
          }
        },
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.student_invoice_current,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (invoice != null) ...{
                    SelectableText(
                      "${AppLocalizations.of(context)!.admin_manage_invoice_month(invoice.month)} - ${invoice.year}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  }
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: SelectableText(
                    NumberFormat('#,###').format(invoice?.total ?? 0) + ' đ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..shader = context.read<AppController>().appThemeMode == ThemeMode.light
                            ? AppColor.mainAppBarGradientColor.createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))
                            : AppColor.secondaryAppBarGradientColor
                                .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.75),
          width: 0.5,
        ),
        boxShadow: [
          if (context.read<AppController>().appThemeMode == ThemeMode.light) ...{
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              blurRadius: 24,
              offset: const Offset(0, 5),
            ),
          },
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: 0,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: HexColor('#C996CC').withOpacity(0.75),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 25.0,
                sigmaY: 25.0,
              ),
              child: FutureBuilder<Room>(
                future: RoomRepository.loadRoomFromRef(student.room!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final theRoom = snapshot.data!;

                    return StreamBuilder<Invoice?>(
                      stream: InvoiceRepository.getLastestInvoiceInRoom(snapshot.data!.reference!),
                      builder: (context, snapshot) {
                        // log(snapshot.toString());

                        if (snapshot.hasData) {
                          final theInvoice = snapshot.data!;
                          return _invoiceCard(theRoom, theInvoice);
                        }

                        if (snapshot.hasError) {
                          log(snapshot.error.toString());

                          // no previous invoices
                          if (snapshot.error.runtimeType == StateError) {
                            if ((snapshot.error as StateError).message == "No element") {
                              return _invoiceCard(theRoom, null);
                            }
                          }

                          controller.showSnackbar(snapshot.error.toString(), const Duration(seconds: 5), () {});
                        }

                        return const CupertinoActivityIndicator(radius: 10);
                      },
                    );
                  }

                  return const CupertinoActivityIndicator(radius: 10);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ignored
  _roomRepairCard(Room room) {
    final controller = context.read<StudentRoomController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.admin_manage_repair,
          style: TextStyle(
            color: AppColor.textColor(context.read<AppController>().appThemeMode),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                width: 0.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '0',
              style: TextStyle(
                color: HexColor('#81B214'),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _roomActiveMembers(Room room) {
    final controller = context.read<StudentRoomController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.student_active_members,
          style: TextStyle(
            color: AppColor.textColor(context.read<AppController>().appThemeMode),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => StudentMembersScreen(
                  previousPageTitle: controller.title,
                  room: room,
                ),
              ),
            );
          },
          padding: EdgeInsets.zero,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.secondaryBackgroundColor(context.read<AppController>().appThemeMode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor.borderColor(context.read<AppController>().appThemeMode),
                width: 0.5,
              ),
            ),
            alignment: Alignment.center,
            child: FutureBuilder<int>(
              future: RoomRepository.getActiveStudentsQuantity(room.reference!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  log('active students in this room: ' + snapshot.data.toString());

                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      color: HexColor('#81B214'),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString());
                }

                return const CupertinoActivityIndicator(radius: 10);
              },
            ),
          ),
        ),
      ],
    );
  }
}
