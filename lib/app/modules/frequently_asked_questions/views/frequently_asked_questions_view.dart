import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q4me/app/components/top_card.dart';
import 'package:q4me/constants/enum.dart';
import 'package:q4me/widgets/bottom_nav_bar.dart';
import '../controllers/frequently_asked_questions_controller.dart';

class FrequentlyAskedQuestionsView
    extends GetView<FrequentlyAskedQuestionsController> {
  final FrequentlyAskedQuestionsController _frequentlyAskedQuestionsController =
      Get.put(FrequentlyAskedQuestionsController());
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    _frequentlyAskedQuestionsController.initialize(context);
    double itemHeight;
    var size = MediaQuery.of(context).size;

    if (size.height > 684 && size.height < 896) {
      itemHeight = (size.height - kToolbarHeight - 24) / 3.5 + 18;
    } else if (size.height < 684) {
      itemHeight = (size.height - kToolbarHeight - 24) / 2.8 - 3;
    } else if (size.height >= 896 && size.height < 926) {
      itemHeight = (size.height - kToolbarHeight - 24) / 4;
    } else {
      itemHeight = (size.height - kToolbarHeight - 24) / 4.2;
    }
    return Scaffold(
      bottomNavigationBar: BottomNavBar(from: 3),
      resizeToAvoidBottomInset: false,
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
                  TopCard(height: Get.height * 0.35),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 47, left: Get.width * 0.1),
                        child: SizedBox(
                          width: Get.width * 0.8,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Frequently Asked\nQuestions:',
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      searchBar(),
                    ],
                  ),
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
                    child: Obx(
                      () => _frequentlyAskedQuestionsController.state ==
                              ViewState.Busy
                          ? Container(
                              height: Get.height * 0.6,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _frequentlyAskedQuestionsController
                                  .faqs.length,
                              itemBuilder: (context, index) {
                                return tileExpansion(
                                  title: _frequentlyAskedQuestionsController
                                      .faqs[index]['question'],
                                  paragraph: _frequentlyAskedQuestionsController
                                      .faqs[index]['answer'],
                                );
                              },
                            ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(left: 8),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios),
                    color: Color(0xff8BC34C),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
      ),
      width: Get.width * 0.8,
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.1,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: TextFormField(
        autofocus: false,
        maxLines: 1,
        style: TextStyle(
          color: Colors.black,
        ),
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

class tileExpansion extends StatelessWidget {
  final String title;
  final String paragraph;
  const tileExpansion({
    Key key,
    @required this.title,
    @required this.paragraph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Color(0xfff2f2f2),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            offset: Offset(1, 4),
          )
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Color(0xff8BC34C),
        ),
        child: ExpansionTile(
          iconColor: Color(0xff8BC34C),
          textColor: Color(0xff13253A),
          title: Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 10.0),
              child: ListTile(
                title: Text(
                  paragraph,
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
