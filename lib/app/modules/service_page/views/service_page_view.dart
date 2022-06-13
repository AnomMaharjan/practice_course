import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/reusable_button.dart';
import '../controllers/service_page_controller.dart';

class ServicePageView extends GetView<ServicePageController> {
  final String imageName;

  final int from;
  final List ivrComponents;
  int ivrComponentId;
  final int componentId;
  final int nextPageId;

  ServicePageView(
      {this.imageName,
      this.from,
      this.ivrComponents,
      this.componentId,
      this.nextPageId});

  final ServicePageController _servicePageController =
      Get.put(ServicePageController());

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _servicePageController.initialize(context);
    return Obx(() => Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: _servicePageController.connecting.value == true
                ? Stack(
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Color(0xff13253A),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: 155,
                                    width: 155,
                                    child: Center(
                                      child: CachedNetworkImage(
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.contain,
                                        imageUrl: Config.baseUrl + imageName,
                                        errorWidget: (context, url, error) =>
                                            Image(
                                          image: AssetImage(
                                              "assets/images/logo_slogan.png"),
                                        ),
                                      ),
                                      // Image(
                                      //     image: NetworkImage(
                                      //       Config.baseUrl + imageName,
                                      //     ),
                                      //     ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  height: 190,
                                  width: 190,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        height: Get.height * 0.2,
                        width: Get.width,
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
                              SizedBox(
                                height: 275,
                                child: TopCard(
                                  height: Get.height * 0.15,
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: Get.height * 0.05),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 130.0,
                                          height: 130.0,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: 70,
                                              width: 70,
                                              child: Center(
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.contain,
                                                  imageUrl: Config.baseUrl +
                                                      imageName,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image(
                                                    image: AssetImage(
                                                        "assets/images/logo_slogan.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // decoration: new BoxDecoration(
                                      //   color: Colors.white,
                                      //   shape: BoxShape.circle,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: Get.height * 0.25),
                                padding: EdgeInsets.only(
                                    top: 16, left: 24, right: 24),
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Obx(
                                      () => _servicePageController
                                                  .pressed.value ==
                                              false
                                          ? service()
                                          : callForMe(),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_servicePageController.pressed.value ==
                                      true) {
                                    _servicePageController.pressed.value =
                                        false; //if call button
                                    print(
                                        "status::: ${_servicePageController.showDynamicPage.value}");
                                  } else {
                                    if (_servicePageController
                                            .pageList.length !=
                                        0) {
                                      if (_servicePageController
                                          .page.dynamicInputStatus) {
                                        _servicePageController
                                            .textEditingControllers
                                            .removeLast();
                                        _servicePageController.dynamicInputSlugs
                                            .removeLast();
                                        _servicePageController.previousPage();
                                      } else {
                                        _servicePageController.previousPage();
                                      }
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                padding: EdgeInsets.only(left: 8),
                                icon: Icon(Icons.arrow_back_ios),
                                color: Color(0xff8BC34C),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: _servicePageController.loading.value
                  ? Color(0xff13253a)
                  : Color(0xfff2f2f2),
            ),
            child: BottomNavBar(
              from: 3,
            ),
          ),
        ));
  }

  Widget callForMe() {
    return Column(
      children: [
        Text(
          'Right, Q4ME!',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff13253A),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Give us the nod and we'll call for \nyou and connect when someone \nanswers",
          style: TextStyle(
            height: 2,
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 60,
        ),
        Obx(() => ReusableButton(
              txt: Text(
                "Call For Me ",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              onPressed: () {
                locator<AnalyticsService>()
                    .logEvent("call_button_clicked", "clicked call button");
                locator<SharedPreferencesManager>()
                    .putString('callTrackerImage', imageName);
                _servicePageController.performCall(
                    componentId: ivrComponentId, imageName: imageName);
              },
              loading:
                  _servicePageController.state == ViewState.Busy ? true : false,
              bgColor: Color(0xff8bc34c),
              txtColor: Colors.white,
            )),
      ],
    );
  }

  Widget service() {
    return Obx(
      () => _servicePageController.busy.value
          ? Container(
              height: Get.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
          : _servicePageController.page == null
              ? Container(
                  height: Get.height * 0.4,
                  child: Center(
                    child: Text('Network not available.'),
                  ),
                )
              : Column(
                  children: [
                    Text(
                      _servicePageController.page.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff13253A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _servicePageController.page.dynamicInputStatus
                        ? SizedBox(height: 0)
                        : SizedBox(height: 30),
                    _servicePageController.page.dynamicInputStatus
                        ? Column(
                            children: [
                              Text("associated with your account",
                                  style: TextStyle(
                                    color: Color(0xff222222),
                                    fontSize: 16,
                                  )),
                              SizedBox(height: 30),
                              dynamicInputField(),
                              SizedBox(
                                height: 40,
                              )
                            ],
                          )
                        : SizedBox(),
                    ListView.builder(
                      itemCount:
                          _servicePageController.page.displayButton.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext ctxt, int index) {
                        onButtonPressed() {
                          if (_servicePageController
                                  .page.displayButton[index].nextPage !=
                              null) {
                            _servicePageController.fetchPage(
                              pageId: _servicePageController
                                  .page.displayButton[index].nextPage["id"],
                              from: 1,
                            );

                            _servicePageController.pageList
                                .add(_servicePageController.page.id);
                          } else {
                            ivrComponentId = _servicePageController
                                .page.displayButton[index].supportComponent.id;
                            from == 1
                                ? null
                                : _servicePageController.pressed.value =
                                    !_servicePageController.pressed.value;
                          }
                        }

                        return new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              onPressed: () {
                                if (_servicePageController
                                    .page.dynamicInputStatus) {
                                  if (_servicePageController
                                      .formKey.currentState
                                      .validate()) {
                                    onButtonPressed();
                                  } else {
                                    return;
                                  }
                                } else {
                                  onButtonPressed();
                                }
                              },
                              color: !_servicePageController
                                      .page.dynamicInputStatus
                                  ? Colors.white
                                  : Color(0xff8bc34c),
                              minWidth: Get.width * 0.76,
                              height: 44,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              child: SizedBox(
                                width: Get.width * 0.75,
                                child: Text(
                                  _servicePageController
                                      .page.displayButton[index].buttonTitle
                                      .toString()
                                      .capitalize,
                                  style: TextStyle(
                                    color: _servicePageController
                                            .page.dynamicInputStatus
                                        ? Colors.white
                                        : Color(0xff8bc34c),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  Widget dynamicInputField() {
    return Form(
      key: _servicePageController.formKey,
      child: _servicePageController.showTextField.value
          ? dynamicInput("eg: Hi this is abc", 14, Color(0xff949594))
          : dynamicInput("eg: 072342689056", 14, Color(0xff949594)),
    );
  }

  Widget dynamicInput(String hintText, double textSize, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: TextFormField(
        controller: _servicePageController.textEditingControllers.last,
        validator: (text) {
          if (text.isEmpty) {
            return 'Field cannot be empty';
          } else if (RegExp(
                  r'^(?=.*?[!@#\$&\+\?\*\|~<>;:{}\\|?/%^\\(\)\[\]\{\}\"\-\_])')
              .hasMatch(
                  _servicePageController.textEditingControllers.last.text)) {
            return 'Input cannot contain special characters.';
          } else
            return null;
        },
        keyboardType: _servicePageController.showTextField.value
            ? TextInputType.text
            : TextInputType.phone,
        maxLength: _servicePageController.showTextField.value ? 2000 : 16,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            counterText: "",
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: textColor),
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
        style: TextStyle(
          fontSize: textSize,
          color: textColor,
        ),
      ),
    );
  }
}
