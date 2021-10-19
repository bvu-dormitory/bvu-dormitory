import 'package:bvu_dormitory/screens/admin/manage/rooms/detail/rooms.detail.controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRoomsDetailImages extends StatefulWidget {
  const AdminRoomsDetailImages({Key? key}) : super(key: key);

  @override
  _AdminRoomsDetailImagesState createState() => _AdminRoomsDetailImagesState();
}

class _AdminRoomsDetailImagesState extends State<AdminRoomsDetailImages> {
  late AdminRoomsDetailController controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<AdminRoomsDetailController>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider.builder(
          carouselController: controller.carouselController,
          itemCount: 3,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: 240,
              height: 200,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            enableInfiniteScroll: false,
            autoPlay: true,
          ),
        ),
      ],
    );
  }
}
