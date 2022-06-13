import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class CustomFaqExpansinoTile extends StatelessWidget {
  CustomFaqExpansinoTile({
    Key key,
    @required this.title,
    @required this.contents,
  }) : super(key: key);
  final String title, contents;
  final GlobalKey expansionTile = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    RxBool isExpanded = false.obs;
    return Obx(
      () => Column(
        children: [
          const Divider(color: Colors.white, thickness: 0.08),
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
                padding: const EdgeInsets.only(left: 17, bottom: 0, right: 20),
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
