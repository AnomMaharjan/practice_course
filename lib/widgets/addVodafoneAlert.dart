import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:q4me/app/modules/service_page/views/service_page_view.dart';

Widget addVodafoneDialog(
    BuildContext context,
    String name,
    String phoneNumber,
    String imageName,
    int componentId,
    List ivrComponents,
    String questionTitle,
    List optionsList,
    int nextPageId) {
  final HomepageController _homepageController = Get.put(HomepageController());

  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    backgroundColor: Colors.white,
    child:
        LayoutBuilder(builder: (BuildContext ctx, BoxConstraints constraints) {
      if (name.length > 10) {
        return Container(
          height: 330,
          child: alertContact(
              name,
              context,
              imageName,
              _homepageController,
              phoneNumber,
              componentId,
              ivrComponents,
              questionTitle,
              optionsList,
              nextPageId),
        );
      } else {
        return Container(
          height: 300,
          child: alertContact(
              name,
              context,
              imageName,
              _homepageController,
              phoneNumber,
              componentId,
              ivrComponents,
              questionTitle,
              optionsList,
              nextPageId),
        );
      }
    }),
  );
}

Column alertContact(
    String name,
    BuildContext context,
    String imageName,
    HomepageController _homepageController,
    String phoneNumber,
    int componentId,
    List ivrComponents,
    String questionTitle,
    List optionsList,
    int nextPageID) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 8, right: 8),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Add $name",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff13253A)),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "To Contacts",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff13253A),
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Divider(
                  indent: Get.width * 0.24,
                  endIndent: Get.width * 0.24,
                  color: Color(0xff8BC34C),
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            "Allow access to your contacts in order to save $name as a contact.This way you'll know who's calling when we connect you.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      SizedBox(
        height: 16,
      ),
      Divider(
        height: 2,
        thickness: 1,
      ),
      IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(
                    () => ServicePageView(
                      imageName: imageName,
                      from: 0,
                      ivrComponents: ivrComponents,
                      componentId: componentId,
                    ),
                    arguments: {
                      "componentId": componentId,
                      "nextPageId": nextPageID
                    },
                  );
                },
                child: Text(
                  'Decline',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff13253A)),
                ),
                elevation: 1,
              ),
            ),
            VerticalDivider(
              thickness: 1,
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _homepageController.saveContactInPhone(name, phoneNumber);
                  Get.to(
                    () => ServicePageView(
                      imageName: imageName,
                      from: 0,
                      ivrComponents: ivrComponents,
                      componentId: componentId,
                    ),
                    arguments: {
                      "componentId": componentId,
                      "nextPageId": nextPageID
                    },
                  );
                  print(_homepageController.phones);
                },
                child: Text(
                  'Accept',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xff8BC34C)),
                ),
              ),
            )
          ],
        ),
      )
    ],
  );
}
