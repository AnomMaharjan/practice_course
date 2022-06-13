import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/utils/string.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';

import '../controllers/setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  final SettingPageController _settingPageController =
      Get.put(SettingPageController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _settingPageController.initialize(context);
    double itemHeight;
    var size = MediaQuery.of(context).size;
    if (size.height > 684 && size.height < 896) {
      itemHeight = (size.height - kToolbarHeight - 24) / 3.5 + 18;
    } else if (size.height < 684) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.8;
    } else if (size.height >= 896 && size.height < 926) {
      itemHeight = (size.height - kToolbarHeight - 24) / 4;
    } else {
      itemHeight = (size.height - kToolbarHeight - 24) / 4.2;
    }
    Future<bool> _onWillLogout() {
      return showDialog(
            context: context,
            builder: (context) => Obx(
              () => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: _settingPageController.loading.value
                    ? Container(
                        height: 150,
                        width: 300,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Text('Are you sure you want to logout?'),
                actions: _settingPageController.loading.value
                    ? null
                    : <Widget>[
                        new TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No',
                                style: TextStyle(color: GLOBAL_GREEN_COLOR))),
                        new TextButton(
                          onPressed: () {
                            _settingPageController.onLogOut();
                          },
                          child: new Text('Yes',
                              style: TextStyle(color: GLOBAL_GREEN_COLOR)),
                        ),
                      ],
              ),
            ),
          ) ??
          false;
    }

    return Scaffold(
        bottomNavigationBar: BottomNavBar(
          from: 0,
        ),
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: [
            Container(
              height: itemHeight * 2,
              width: size.width,
              decoration: BoxDecoration(
                color: Color(0xff13253A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            ListView(
              children: [
                Stack(
                  children: [
                    // TopCard(),
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      padding: EdgeInsets.only(top: 16, left: 24, right: 24),
                      decoration: BoxDecoration(
                        color: Color(0xfff2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                        ? 3
                                        : 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: (1 / 0.95),
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  _settingPageController.settingList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: _settingPageController
                                              .settingList[index][1] ==
                                          "logout"
                                      ? () {
                                          _onWillLogout();
                                        }
                                      : _settingPageController
                                          .settingList[index][2],
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 8,
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 1,
                                          offset: Offset(1, 4),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        size.height > 684
                                            ? SizedBox(
                                                height: 20,
                                              )
                                            : SizedBox(
                                                height: 16,
                                              ),
                                        SizedBox(
                                          height: 69,
                                          child: SvgPicture.asset(
                                            _settingPageController
                                                .settingList[index][0],
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        size.height > 684
                                            ? SizedBox(
                                                height: 5,
                                              )
                                            : SizedBox(
                                                height: 14,
                                              ),
                                        Text(
                                          _settingPageController
                                              .settingList[index][1]
                                              .toUpperCase(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        size.height > 684
                            ? SizedBox(height: 28)
                            : SizedBox(height: 20),
                        Center(
                          child: Container(
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/logo_slogan.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
