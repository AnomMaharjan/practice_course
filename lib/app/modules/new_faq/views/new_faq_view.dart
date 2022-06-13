import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/utils/string.dart';
import '../controllers/new_faq_controller.dart';

class NewFaqView extends GetView<NewFaqController> {
  final NewFaqController _newFaqController = Get.put(NewFaqController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _newFaqController.initialize(context);
    return Scaffold(
      backgroundColor: GLOBAL_THEME_COLOR,
      appBar: Platform.isAndroid
          ? AppBar(
              elevation: 0,
              toolbarHeight: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: GLOBAL_THEME_COLOR,
                  statusBarBrightness: Brightness.dark),
            )
          : null,
      body: GetBuilder<NewFaqController>(builder: (_) {
        return _.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator.adaptive())
            : ListView(
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      splashRadius: 1,
                      padding: const EdgeInsets.only(left: 18, top: 27),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios),
                      color: const Color(0xff8BC34C),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        '''The FAQ's''',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 334,
                        width: 331,
                        margin: const EdgeInsets.only(top: 15, bottom: 27),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/faq_test_image.png'))),
                      ),
                      Column(
                        children: List.generate(
                          _newFaqController.faq.length,
                          (index) => CustomFaqExpansinoTile(
                            title: _newFaqController.faq[index].question,
                            contents: _newFaqController.faq[index].answer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
      }),
    );
  }
}

class CustomFaqExpansinoTile extends StatelessWidget {
  const CustomFaqExpansinoTile({
    Key key,
    @required this.title,
    @required this.contents,
  }) : super(key: key);
  final String title, contents;

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;
    return Obx(
      () => Column(
        children: [
          Divider(
            color: Colors.white,
            thickness: 0.08,
          ),
          ExpansionTile(
            onExpansionChanged: (bool press) => isExpanded.value = press,
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            trailing: !isExpanded.value
                ? SvgPicture.asset('assets/svgs/plus_icon.svg')
                : const Padding(
                    padding: EdgeInsets.only(bottom: 18.0),
                    child: Icon(Icons.minimize, color: Colors.white),
                  ),
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Container(
                width: Get.width,
                padding: const EdgeInsets.only(left: 17, bottom: 25, right: 20),
                color: Colors.white,
                child: Html(data: contents),
                // Text(
                //   HtmlParser.parseHTML(contents).toString(),
                //   style: TextStyle(fontSize: 16, height: 2),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
