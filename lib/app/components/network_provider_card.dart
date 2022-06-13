import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/modules/add_credit_page/views/add_credit_page_view.dart';
import 'package:q4me/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:q4me/app/modules/service_page/views/service_page_view.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/widgets/addVodafoneAlert.dart';

class NetworkCard extends StatelessWidget {
  final String imageName, networkName, phoneNumber, username, status, openTime;
  final int componentId, nextPageId;
  final List ivrComponents;
  final String questionTitle;
  final List optionsList;
  final HomepageController _homepageController = Get.put(HomepageController());
  final SharedPreferencesManager _sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  NetworkCard({
    Key key,
    @required this.imageName,
    @required this.networkName,
    @required this.status,
    this.openTime,
    this.username,
    this.componentId,
    this.phoneNumber,
    this.ivrComponents,
    this.questionTitle,
    this.optionsList,
    this.nextPageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: optionsList.length == 0
          ? null
          : _sharedPreferencesManager.getBool("isCreditZero")
              ? () {
                  showAlertDialog();
                }
              : () {
                  if (status == "false") {
                    null;
                  } else if (_sharedPreferencesManager
                          .getBool("permissionAllowed") ==
                      false) {
                    locator<AnalyticsService>().logEvent(
                          "${networkName.replaceAll(' ', '_')}_clicked",
                          "${networkName.replaceAll(' ', '_')} clicked");
                    Get.to(
                        () => ServicePageView(
                              imageName: imageName,
                              from: 0,
                              ivrComponents: ivrComponents,
                              componentId: componentId,
                            ),
                        arguments: {
                          "componentId": componentId,
                          "nextPageId": nextPageId
                        },
                        transition: Transition.noTransition);
                  } else if (!_sharedPreferencesManager
                      .getBool("isCreditZero")) {
                    if (status == "true" &&
                        !_homepageController.phones.contains(phoneNumber)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addVodafoneDialog(
                              context,
                              networkName,
                              phoneNumber,
                              imageName,
                              componentId,
                              ivrComponents,
                              questionTitle,
                              optionsList,
                              nextPageId);
                        },
                      );
                    } else if (status == "true" &&
                        _homepageController.phones.contains(phoneNumber)) {
                      locator<AnalyticsService>().logEvent(
                          "${networkName.replaceAll(' ', '_')}_clicked",
                          "${networkName.replaceAll(' ', '_')} clicked");
                      Get.to(
                        () => ServicePageView(
                          imageName: imageName,
                          from: 0,
                          ivrComponents: ivrComponents,
                          componentId: componentId,
                        ),
                        arguments: {
                          "componentId": componentId,
                          "nextPageId": nextPageId
                        },
                      );
                    }
                  }
                },
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: status == "true" ? Color(0xffffffff) : Color(0xfff2f2f2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: status != "true"
              ? [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    offset: Offset(1, 4),
                  )
                ]
              : [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    offset: Offset(1, 4),
                  )
                ],
        ),
        width: 140,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 2),
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                      color: status == "true"
                          ? Color(0xff8BC34C)
                          : Colors.grey.withOpacity(0.4),
                      shape: BoxShape.circle),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 65,
                  width: 80,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: Config.baseUrl + imageName,
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage("assets/images/logo_slogan.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                status == "true"
                    ? AutoSizeText(
                        "$networkName",
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )
                    : AutoSizeText(
                        openTime,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )
                // int.parse(hours) == 12
                //     ? AutoSizeText(
                //         "Opens ${int.parse(hours)}:$mins pm",
                //         style: TextStyle(
                //           fontSize: 14,
                //           // height: 1.2,
                //           fontWeight: FontWeight.w600,
                //         ),
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         textAlign: TextAlign.center,
                //       )
                //     : int.parse(hours) < 12
                //         ? AutoSizeText(
                //             "Opens ${int.parse(hours)}:$mins am",
                //             style: TextStyle(
                //               fontSize: 14,
                //               // height: 1.2,
                //               fontWeight: FontWeight.w600,
                //             ),
                //             maxLines: 2,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.center,
                //           )
                //         : AutoSizeText(
                //             "Opens ${int.parse(hours) - 12}:$mins pm",
                //             style: TextStyle(
                //               fontSize: 14,
                //               // height: 1.2,
                //               fontWeight: FontWeight.w600,
                //             ),
                //             maxLines: 2,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.center,
                //           )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog() {
  Widget okButton = MaterialButton(
    child: Text("YES", style: TextStyle(color: Color(0xff8BC34C))),
    onPressed: () {
      Get.back();
      Get.to(() => AddCreditPageView(), transition: Transition.noTransition);
    },
  );
  Widget cancelButton = MaterialButton(
    child: Text("NO", style: TextStyle(color: Color(0xff8BC34C))),
    onPressed: () {
      Get.back();
    },
  );
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    title: Text("Do you want to topup?"),
    content: Text("Are you sure you want to recharge your account?"),
    actions: [okButton, cancelButton],
  );
  showDialog(
    context: Get.overlayContext,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
