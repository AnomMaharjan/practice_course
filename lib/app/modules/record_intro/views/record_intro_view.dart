// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:q4me/app/components/top_card.dart';
// import 'package:q4me/app/modules/homepage/views/homepage_view.dart';
// import 'package:q4me/app/widgets/button.dart';
// // import 'package:q4me/app/widgets/music/music_view.dart';
// import '../controllers/record_intro_controller.dart';

// class RecordIntroView extends GetView<RecordIntroController> {
//   final RecordIntroController recordIntroController =
//       Get.put(RecordIntroController());

//   final intStream = StreamController<int>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               TopCard(
//                 topColor: Color.fromRGBO(19, 37, 58, 1),
//                 bottomColor: Color.fromRGBO(19, 37, 58, 0.8),
//               ),
//               Obx(() => recordIntroController.isrecording.value == false
//                   ? Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: Get.height * 0.15),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Record Your\n Own Intro',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                   height: 1.25,
//                                   color: Colors.white),
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Text(
//                               'This is what will play to the call\ncentre person who answers.',
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 12),
//                               textAlign: TextAlign.center,
//                             )
//                           ],
//                         ),
//                       ),
//                     )
//                   : Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: Get.height * 0.15),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Check your sound',
//                               style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(
//                               """It's important the cell centre person \nknows who you are\n so check it's recorded \nnice and clear!""",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 14),
//                               textAlign: TextAlign.center,
//                             )
//                           ],
//                         ),
//                       ),
//                     ))
//             ],
//           ),
//           SizedBox(
//             height: Get.height * 0.03,
//           ),
//           SizedBox(
//             height: 40,
//           ),
//           Obx(
//             () => recordIntroController.isrecording.value == false
//                 ? Column(
//                     children: [
//                       Text(
//                         'We suggest:',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       SizedBox(
//                         height: 60,
//                       ),
//                       Text(
//                         "\"Hi, it's John here,\n How are you\"?",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       SizedBox(height: Get.height * 0.1),
//                       Button(
//                         onClick: () {
//                           recordIntroController.isrecording.value =
//                               !recordIntroController.isrecording.value;
//                         },
//                         child: Icon(
//                           Icons.mic_none_outlined,
//                           size: 24,
//                           color: Colors.white,
//                         ),
//                         buttonShape: CircleBorder(),
//                         buttonColor: Colors.lightGreen,
//                         padding: EdgeInsets.all(20),
//                       ),
//                       SizedBox(
//                         height: 14,
//                       ),
//                       Text(
//                         'Tap the mic to record',
//                         style: TextStyle(fontSize: 14),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   )
//                 : Column(
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       recordIntroController.ispaused.value == false
//                           ? SizedBox(
//                               height: 100,
//                               width: Get.width * 0.9,
//                             )
//                           // child: MusicComponent(),)
//                           : Center(
//                               child: SizedBox(
//                                 width: 330,
//                                 height: 100,
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: List.generate(
//                                     19,
//                                     (index) => Container(
//                                       width: 6,
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey,
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       height: 10,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: 10,
//                             width: 10,
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text("00.00.55")
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //   children: List.generate(
//                       //       recordIntroController.data_queue.length,
//                       //       (index) => Container(
//                       //             color: Colors.black,
//                       //             height: 10,
//                       //             width: 2,
//                       //           )),
//                       // ),
//                       // StreamBuilder(
//                       //   stream: intStream.stream,
//                       //   builder: (BuildContext context,
//                       //       AsyncSnapshot<dynamic> snapshot) {
//                       //     if (!snapshot.hasData) {
//                       //       return Container(
//                       //         height: 10,
//                       //         width: 3,
//                       //         color: Colors.red,
//                       //       );
//                       //     }
//                       //     return Container(
//                       //       height: 10,
//                       //       width: 3,
//                       //       color: Colors.red,
//                       //     );
//                       //   },
//                       // ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Button(
//                             onClick: () {},
//                             child: Icon(
//                               Icons.play_arrow,
//                               size: 20,
//                               color: Colors.black,
//                             ),
//                             buttonShape: CircleBorder(),
//                             buttonColor: Colors.white,
//                             padding: EdgeInsets.all(8),
//                           ),
//                           Stack(
//                             alignment: AlignmentDirectional.center,
//                             children: [
//                               FadeTransition(
//                                 opacity:
//                                     recordIntroController.animationController,
//                                 child: Container(
//                                   height: 100,
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.lightGreen.shade200
//                                         .withOpacity(0.6),
//                                   ),
//                                 ),
//                               ),
//                               AnimatedOpacity(
//                                 opacity: recordIntroController.ispaused.value ==
//                                         false
//                                     ? 1.0
//                                     : 0.0,
//                                 duration: Duration(milliseconds: 2000),
//                                 child: Container(
//                                   height: 84,
//                                   width: 84,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.lightGreen.shade200,
//                                   ),
//                                 ),
//                               ),
//                               recordIntroController.ispaused.value == false
//                                   ? Button(
//                                       onClick: () {
//                                         recordIntroController.ispaused.value =
//                                             !recordIntroController
//                                                 .ispaused.value;
//                                       },
//                                       child: Icon(
//                                         Icons.pause,
//                                         size: 24,
//                                         color: Colors.white,
//                                       ),
//                                       buttonShape: CircleBorder(),
//                                       buttonColor: Colors.lightGreen,
//                                       padding: EdgeInsets.all(20),
//                                     )
//                                   : Button(
//                                       onClick: () {
//                                         recordIntroController.ispaused.value =
//                                             !recordIntroController
//                                                 .ispaused.value;
//                                       },
//                                       child: Icon(
//                                         Icons.mic,
//                                         size: 24,
//                                         color: Colors.white,
//                                       ),
//                                       buttonShape: CircleBorder(),
//                                       buttonColor: Colors.lightGreen,
//                                       padding: EdgeInsets.all(20),
//                                     ),
//                             ],
//                           ),
//                           Button(
//                             onClick: () {
//                               Get.to(() => HomepageView());
//                               // showDialog(
//                               //     context: context,
//                               //     builder: (context) {
//                               //       return contactAlertDialog(context);
//                               //     });
//                             },
//                             child: Icon(
//                               Icons.stop,
//                               size: 20,
//                               color: Colors.black,
//                             ),
//                             buttonShape: CircleBorder(),
//                             buttonColor: Colors.white,
//                             padding: EdgeInsets.all(8),
//                           ),
//                           SizedBox(),
//                         ],
//                       ),
//                     ],
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
