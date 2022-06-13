import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
import 'package:q4me/app/modules/setting_page/views/setting_page_view.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import '../controllers/init_page_controller.dart';

class InitPageView extends GetView<InitPageController> {
  final InitPageController initPageController = Get.put(InitPageController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Future<bool> _onWillPop() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: new Text('Are you sure you want to exit?'),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes',
                      style: TextStyle(
                          color: Color(0xff8BC34C),
                          fontWeight: FontWeight.bold)),
                ),
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No',
                      style: TextStyle(
                          color: Color(0xff8BC34C),
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          body: Obx(() => initPageController.currentIndex.value == 1
              ? SettingPageView()
              : HomepageView()),
          bottomNavigationBar: BottomNavBar(
            from: 0,
          ),
        ),
      ),
    );
  }
}
