import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/components/network_provider_card.dart';
import 'package:q4me/app/modules/call_ended/views/call_ended_view.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/service/analytics_service.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import 'package:q4me/widgets/user_stats_components.dart';
import '../controllers/homepage_controller.dart';

class HomepageView extends GetView<HomepageController> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final HomepageController _homepageController = Get.put(HomepageController());
  final BottomNavBar bottomNavBar = BottomNavBar();
  String code;
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    double itemHeight;

    var size = MediaQuery.of(context).size;
    print("height: " + size.height.toString());
    print("width: " + size.width.toString());
    if (size.height > 684 && size.height < 896) {
      itemHeight = (size.height - kToolbarHeight - 24) / 3.6 + 22;
    } else if (size.height < 684) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.9 + 8;
    } else if (size.height >= 896 && size.height < 926) {
      itemHeight = (size.height - kToolbarHeight - 24) / 3.9;
    } else {
      itemHeight = (size.height - kToolbarHeight - 24) / 4;
    }

    final double itemWidth = size.width / 2;

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(
          from: 0,
        ),
        backgroundColor: const Color(0xfff2f2f2),
        resizeToAvoidBottomInset: true,
        key: _scaffoldState,
        body: GetBuilder<HomepageController>(
          initState: _homepageController.initialize(context),
          builder: (_) => RefreshIndicator(
            onRefresh: () {
              return Future.delayed(
                const Duration(seconds: 1),
                () {
                  _homepageController.onRefresh();
                  _homepageController.onRefresh();
                },
              );
            },
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _homepageController.scrollController,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(
                  [
                    SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            height: itemHeight * 1.6,
                            width: size.width,
                            decoration: const BoxDecoration(
                              color: Color(0xff13253A),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                          ),
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 180),
                                    decoration: BoxDecoration(
                                      color: Color(0xfff2f2f2),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 12,
                                          left: 24,
                                          right: 24,
                                          bottom: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment
                                          //           .spaceBetween,
                                          //   children: [
                                          //     Flexible(
                                          //       flex: 2,
                                          //       child: Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .end,
                                          //         children: [
                                          //           Flexible(
                                          //             flex: 1,
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .end,
                                          //               children: [
                                          //                 const Text(
                                          //                     'Sort by:  ',
                                          //                     style: TextStyle(
                                          //                         fontWeight: FontWeight.w600,
                                          //                         color: GLOBAL_THEME_COLOR)),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //           Flexible(
                                          //             flex: 1,
                                          //             child:
                                          //                 Container(
                                          //               width: 130,
                                          //               child:
                                          //                   GestureDetector(
                                          //                 onTap:
                                          //                     () {
                                          //                   _homepageController
                                          //                       .scrollController
                                          //                       .animateTo(
                                          //                     _homepageController
                                          //                         .scrollController
                                          //                         .position
                                          //                         .minScrollExtent,
                                          //                     duration:
                                          //                         Duration(milliseconds: 10),
                                          //                     curve:
                                          //                         Curves.fastOutSlowIn,
                                          //                   );
                                          //                   _homepageController
                                          //                       .dialogue(context);
                                          //                 },
                                          //                 child:
                                          //                     Row(
                                          //                   children: [
                                          //                     Text(
                                          //                       _homepageController.itemValue,
                                          //                       style:
                                          //                           TextStyle(fontWeight: FontWeight.w600, color: GLOBAL_THEME_COLOR),
                                          //                     ),
                                          //                     Icon(
                                          //                       Icons.arrow_drop_down,
                                          //                       color:
                                          //                           GLOBAL_THEME_COLOR,
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           SizedBox(
                                          //             height: 48,
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          _homepageController.filteredList ==
                                                  null
                                              ? Container(
                                                  height: Get.height * 0.8,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                )
                                              : GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: MediaQuery
                                                                    .of(context)
                                                                .orientation ==
                                                            Orientation
                                                                .landscape
                                                        ? 3
                                                        : 2,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5,
                                                    childAspectRatio:
                                                        (itemWidth /
                                                            itemHeight),
                                                  ),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: _homepageController
                                                      .filteredList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return NetworkCard(
                                                      openTime:
                                                          _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .newOpenTime,
                                                      status:
                                                          _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .status
                                                              .toString(),
                                                      imageName:
                                                          _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .image,
                                                      networkName:
                                                          _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .title,
                                                      phoneNumber: _homepageController
                                                                  .filteredList[
                                                                      index]
                                                                  .phoneNumber ==
                                                              null
                                                          ? ""
                                                          : _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .phoneNumber,
                                                      componentId:
                                                          _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .id,
                                                      questionTitle: _homepageController
                                                                  .filteredList[
                                                                      index]
                                                                  .firstPage ==
                                                              null
                                                          ? ""
                                                          : _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .firstPage
                                                              .title,
                                                      optionsList: _homepageController
                                                                  .filteredList[
                                                                      index]
                                                                  .firstPage ==
                                                              null
                                                          ? []
                                                          : _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .firstPage
                                                              .displayButton,
                                                      nextPageId: _homepageController
                                                                  .filteredList[
                                                                      index]
                                                                  .firstPage ==
                                                              null
                                                          ? null
                                                          : _homepageController
                                                              .filteredList[
                                                                  index]
                                                              .firstPage
                                                              .id,
                                                    );
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: Get.width * 0.05,
                                            right: Get.width * 0.05,
                                            top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 75,
                                                  width: 55,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/logo_slogan.png'),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            UserStatComponent()
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      searchBar(),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.05,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        controller: _homepageController.searchController,
        autofocus: false,
        maxLines: 1,
        onTap: () => locator<AnalyticsService>()
            .logEvent("search_bar_clicked", "clicked search bar"),
        style: TextStyle(
          color: Colors.black,
        ),
        onChanged: (value) {
          _homepageController.searchText = value;

          _homepageController.searchComponent(_homepageController.searchText);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.lightBlueAccent,
          hintText: 'Search',
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
