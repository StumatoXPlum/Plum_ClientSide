// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../home_detail_screen/view/home_detail_screen.dart';
// import '../../home_screen/model/recommendation_model.dart';

// class RecommendationScreen extends StatefulWidget {
//   final List<RecommendationModel> items;
//   const RecommendationScreen({super.key, required this.items});

//   @override
//   State<RecommendationScreen> createState() => _RecommendationScreenState();
// }

// class _RecommendationScreenState extends State<RecommendationScreen>
//     with TickerProviderStateMixin {
//   late List<RecommendationModel> shuffledItems;
//   late List<AnimationController> _controllers;
//   late List<Animation<Offset>> _animations;

//   @override
//   void initState() {
//     super.initState();
//     shuffledItems = List.from(widget.items)..shuffle(Random());
//     _controllers = List.generate(
//       shuffledItems.length,
//       (index) => AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 500),
//       ),
//     );

//     _animations =
//         _controllers.map((controller) {
//           return Tween<Offset>(
//             begin: Offset(1.5, 0), 
//             end: Offset(0, 0), 
//           ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
//         }).toList();
//     Future.delayed(Duration(milliseconds: 300), () {
//       for (int i = 0; i < shuffledItems.length; i++) {
//         Future.delayed(Duration(milliseconds: i * 150), () {
//           if (mounted) {
//             _controllers[i].forward();
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;

//     return Scaffold(
//       backgroundColor: Color(0xff090C15),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               HeaderTwo(),
//               SizedBox(height: size.height * 0.03),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//                   child: ListView.builder(
//                     itemCount: shuffledItems.length,
//                     itemBuilder: (context, index) {
//                       return SlideTransition(
//                         position: _animations[index],
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => HomeDetailScreen(
//                                       item: shuffledItems[index],
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(vertical: padding),
//                             decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.asset(
//                                     shuffledItems[index].image,
//                                     height: 80,
//                                     width: 80,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 SizedBox(width: size.width * 0.03),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         shuffledItems[index].title,
//                                         style: GoogleFonts.urbanist(
//                                           color: Colors.white,
//                                           fontSize: fontSize,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: size.height * 0.01),
//                                       Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             "assets/home_assets/rating.svg",
//                                             height: size.height * 0.02,
//                                             width: size.width * 0.04,
//                                           ),
//                                           SizedBox(width: size.width * 0.01),
//                                           Text(
//                                             shuffledItems[index].rating,
//                                             style: GoogleFonts.urbanist(
//                                               color: Colors.white70,
//                                               fontSize: fontSize * 0.8,
//                                             ),
//                                           ),
//                                           SizedBox(width: size.width * 0.01),
//                                           Text(
//                                             "(${shuffledItems[index].reviews})",
//                                             style: GoogleFonts.urbanist(
//                                               color: Colors.white70,
//                                               fontSize: fontSize * 0.8,
//                                             ),
//                                           ),
//                                           SizedBox(width: size.width * 0.01),
//                                           Text(
//                                             "${shuffledItems[index].distance} away",
//                                             style: GoogleFonts.urbanist(
//                                               color: Colors.white70,
//                                               fontSize: fontSize * 0.8,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HeaderTwo extends StatelessWidget {
//   const HeaderTwo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: SvgPicture.asset("assets/sign_up_assets/back.svg"),
//             ),
//           ),
//           SizedBox(height: size.height * 0.02),
//           Text(
//             "Recommended for you",
//             style: GoogleFonts.urbanist(
//               color: Colors.white,
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: size.height * 0.02),
//           Text(
//             "Our recommendations depend on your search results.",
//             style: GoogleFonts.urbanist(
//               color: Colors.white70,
//               fontSize: fontSize * 0.75,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
