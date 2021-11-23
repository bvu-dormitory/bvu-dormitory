import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:bvu_dormitory/models/user.dart';
import 'package:bvu_dormitory/base/base.screen.dart';
import 'package:provider/src/provider.dart';
import 'package:spannable_grid/spannable_grid.dart';
import 'student.profile.controller.dart';

class StudentProfileDetailScreen extends BaseScreen<StudentProfileDetailController> {
  StudentProfileDetailScreen({
    Key? key,
    String? previousPageTitle,
    required this.student,
  }) : super(key: key, previousPageTitle: previousPageTitle, haveNavigationBar: true);

  final Student student;

  @override
  StudentProfileDetailController provideController(BuildContext context) {
    return StudentProfileDetailController(
      context: context,
      title: AppLocalizations.of(context)!.admin_manage_rooms_detail_students_view_profile,
      student: student,
    );
  }

  @override
  Widget? navigationBarTrailing(BuildContext context) {}

  @override
  Widget body(BuildContext context) {
    final controller = context.read<StudentProfileDetailController>();
    return SafeArea(
        child: Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SpannableGrid(
          // showGrid: true,
          editingOnLongPress: false,
          columns: 4,
          rows: 12,
          spacing: 10.0,
          rowHeight: 115,
          cells: List.generate(
            controller.formFields.length,
            (index) => controller.formFields[index],
          ),
        ),
      ),
    ));
  }
}
