// import 'dart:ui';
// import 'package:card_swiper/card_swiper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
// import 'package:task2/presentation/home_screen/home_screen/model/coupon_model.dart';
// import '../../../../core/custom_snackbar.dart';
// import '../../../authentication_screens/sign_up_screen/auth_service/auth_service.dart';
// import '../../../points_screen/cubit/earned_points_cubit.dart';
// import '../../../cart/view/cart_screen.dart';
// import '../../recommendation/view/recommendation_screen.dart';
// import '../../home_detail_screen/view/home_detail_screen.dart';
// import '../model/recommendation_model.dart';
// import '../../pick_location/pick_location_screen.dart';
// import '../../../profile/user_profile.dart';

// class HomeScreen extends StatefulWidget {
//   final bool showSnackbar;
//   final DateTime? selectedDate;
//   final String? selectedStartTime;
//   final String? selectedEndTime;
//   const HomeScreen({
//     super.key,
//     this.showSnackbar = false,
//     this.selectedDate,
//     this.selectedStartTime, 
//     this.selectedEndTime,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final String _locationText = "Tap to set location";
//   String? _yourLocation;
//   String avatarUrl = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchAvatar();
//   }

//   Future<void> fetchAvatar() async {
//     final firebase_auth.FirebaseAuth firebaseAuth =
//         firebase_auth.FirebaseAuth.instance;
//     final supabase.SupabaseClient supabaseClient =
//         supabase.Supabase.instance.client;

//     firebase_auth.User? firebaseUser = firebaseAuth.currentUser;
//     final supabase.User? supabaseUser = supabaseClient.auth.currentUser;

//     if (firebaseUser == null && supabaseUser == null) {
//       return;
//     }

//     String userId = firebaseUser?.uid ?? supabaseUser!.id;

//     try {
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(userId)
//               .get();

//       if (userDoc.exists) {
//         setState(() {
//           avatarUrl =
//               userDoc['avatarUrl'] ?? AuthService.getRandomAvatarUrl(userId);
//         });
//       } else {
//         print("usr not exist");
//       }
//     } catch (e) {
//       print("error fetching avatar: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;
//     return Scaffold(
//       backgroundColor: const Color(0xff090D14),
//       body: SingleChildScrollView(
//         child: Column( 
//           children: [
//             SafeArea(
//               child: SizedBox(
//                 height: size.height * 0.45,
//                 width: double.infinity,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       top: -5,
//                       child: SvgPicture.asset(
//                         'assets/home_assets/blur.svg',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
//                         child: Container(color: Colors.transparent),
//                       ),
//                     ),
//                     Positioned(
//                       right: padding,
//                       top: padding * 0.1,
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder:
//                                       (context) => const ShoppingCartScreen(),
//                                 ),
//                               );
//                             },
//                             child: SvgPicture.asset(
//                               "assets/home_assets/cart.svg",
//                               height: size.width * 0.12,
//                             ),
//                           ),
//                           SizedBox(width: padding),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => UserProfile(),
//                                 ),
//                               );
//                             },
//                             child: CircleAvatar(
//                               backgroundImage:
//                                   avatarUrl.isNotEmpty
//                                       ? NetworkImage(avatarUrl)
//                                       : AssetImage(
//                                         'assets/home_assets/pfp.png',
//                                       ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       top: size.height * 0.05,
//                       left: 0,
//                       right: 0,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Image.asset(
//                             "assets/home_assets/bulb.png",
//                             height:
//                                 size.width * (size.height < 600 ? 0.12 : 0.15),
//                           ),
//                           SizedBox(
//                             height:
//                                 size.height < 600
//                                     ? size.height * 0.005
//                                     : size.height * 0.01,
//                           ),
//                           Text(
//                             "My Rewards Points",
//                             style: GoogleFonts.urbanist(
//                               color: Colors.white,
//                               fontSize:
//                                   fontSize * (size.height < 600 ? 1.2 : 1.4),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(
//                             height:
//                                 size.height < 600
//                                     ? size.height * 0.001
//                                     : size.height * 0.005,
//                           ),
//                           Text(
//                             "Earned Points",
//                             style: GoogleFonts.urbanist(
//                               color: Colors.white,
//                               fontSize:
//                                   fontSize * (size.height < 600 ? 0.8 : 0.9),
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.01),
//                           BlocBuilder<EarnedPointsCubit, int>(
//                             builder: (context, state) {
//                               return Text(
//                                 "$state",
//                                 style: GoogleFonts.urbanist(
//                                   color: Colors.white,
//                                   fontSize:
//                                       fontSize * (size.height < 600 ? 2.5 : 3),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               );
//                             },
//                           ),
//                           SizedBox(height: size.height * 0.02),
//                           SizedBox(
//                             height: size.height * 0.12,
//                             width: size.width,
//                             child: Swiper(
//                               itemCount: 3,
//                               itemBuilder:
//                                   (context, index) => CouponContainer(
//                                     coupon: CouponModel(
//                                       code: codes[index].code,
//                                     ),
//                                   ),
//                               axisDirection: AxisDirection.down,
//                               scrollDirection: Axis.vertical,
//                               itemHeight:
//                                   size.height *
//                                   (size.height < 600 ? 0.07 : 0.09),
//                               itemWidth: size.width * 1,
//                               loop: true,
//                               autoplay: true,
//                               duration: 1000,
//                               layout: SwiperLayout.STACK,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: size.height * 0.02),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//               child: GestureDetector(
//                 onTap: () async {
//                   final selectedLocation = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PickLocationScreen(),
//                     ),
//                   );

//                   if (selectedLocation != null && selectedLocation is String) {
//                     setState(() {
//                       _yourLocation = selectedLocation;
//                     });
//                   }
//                 },

//                 child: Container(
//                   padding: EdgeInsets.all(padding),
//                   decoration: BoxDecoration(
//                     color: Color(0xff161C25),
//                     borderRadius: BorderRadius.circular(42),
//                     border: Border.all(color: Color(0xff202938)),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(padding),
//                         decoration: BoxDecoration(
//                           color: Color(0xff2D3748),
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xff202938),
//                             width: 2,
//                           ),
//                         ),
//                         child: SvgPicture.asset(
//                           "assets/home_assets/pin.svg",
//                           fit: BoxFit.scaleDown,
//                         ),
//                       ),
//                       SizedBox(width: size.width * 0.03),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Your Location",
//                               style: GoogleFonts.urbanist(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: fontSize * 0.9,
//                               ),
//                             ),
//                             SizedBox(height: size.height * 0.001),
//                             Text(
//                               _yourLocation ?? _locationText,
//                               style: GoogleFonts.urbanist(
//                                 color: Colors.white60,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                               maxLines: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                       // const Spacer(),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 15),
//                           child: Icon(
//                             Icons.arrow_forward_ios,
//                             color: Color(0xff3579DD),
//                             size: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: size.height * 0.01),
//             RecommendationsWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CouponContainer extends StatelessWidget {
//   final CouponModel coupon;

//   const CouponContainer({super.key, required this.coupon});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.04;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: padding * 2),
//       child: Container(
//         height: size.height * 0.15,
//         padding: EdgeInsets.symmetric(
//           vertical: padding * 0.01,
//           horizontal: padding * 1.5,
//         ),
//         decoration: BoxDecoration(
//           color: const Color(0xff0ECCB3),
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset(
//               "assets/home_assets/star.svg",
//               width: size.width * 0.08,
//             ),
//             SizedBox(width: size.width * 0.02),
//             Expanded(
//               flex: 5,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Coupons",
//                     style: GoogleFonts.urbanist(
//                       color: Colors.black,
//                       fontSize: fontSize * 1.2,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Apply ${coupon.code} for discount",
//                     style: GoogleFonts.urbanist(
//                       color: Colors.black,
//                       fontSize: fontSize * 1,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Clipboard.setData(ClipboardData(text: coupon.code));
//                 showCustomSnackbar(
//                   context,
//                   "Coupon code copied",
//                   Colors.green.shade600,
//                 );
//               },
//               child: SvgPicture.asset(
//                 "assets/home_assets/arrow.svg",
//                 width: size.width * 0.07,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RecommendationsWidget extends StatefulWidget {
//   const RecommendationsWidget({super.key});

//   @override
//   State<RecommendationsWidget> createState() => _RecommendationsWidgetState();
// }

// class _RecommendationsWidgetState extends State<RecommendationsWidget> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.04;
//     double fontSize = size.width * 0.045;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: size.height * 0.02),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: padding),
//           child: Row(
//             children: [
//               Text(
//                 "Recommended for you",
//                 style: GoogleFonts.urbanist(
//                   color: Colors.white,
//                   fontSize: fontSize * 1.1,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => RecommendationScreen(items: items),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   "See All",
//                   style: GoogleFonts.urbanist(
//                     color: const Color(0xff3579DD),
//                     fontWeight: FontWeight.bold,
//                     fontSize: fontSize * 0.9,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: size.height * 0.02),
//         SizedBox(
//           height: size.height * 0.3,
//           child: NotificationListener<ScrollNotification>(
//             onNotification: (ScrollNotification notification) {
//               setState(() {});
//               return true;
//             },
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: EdgeInsets.symmetric(horizontal: padding),
//               scrollDirection: Axis.horizontal,
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 double parallaxOffset = 0;
//                 if (_scrollController.hasClients) {
//                   final itemWidth = size.width * 0.7 + padding;
//                   final itemPosition = itemWidth * index;
//                   final distanceFromCenter =
//                       itemPosition - _scrollController.offset;
//                   parallaxOffset = distanceFromCenter * 0.1;
//                 }
//                 final item = items[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomeDetailScreen(item: item),
//                       ),
//                     );
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(right: padding),
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: SizedBox(
//                                 height: size.height * 0.2,
//                                 width: size.width * 0.7,
//                                 child: OverflowBox(
//                                   maxWidth: size.width * 0.9,
//                                   maxHeight: size.height * 0.24,
//                                   alignment: Alignment.center,
//                                   child: Transform.translate(
//                                     offset: Offset(parallaxOffset, 0),
//                                     child: Hero(
//                                       tag: 'image${item.title}',
//                                       child: Image.asset(
//                                         item.image,
//                                         fit: BoxFit.cover,
//                                         width: size.width * 0.9,
//                                         height: size.height * 0.24,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (items[index].isSuperstar)
//                               Positioned(
//                                 top: 10,
//                                 right: 10,
//                                 child: superStar(size),
//                               ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.01),
//                       SizedBox(
//                         width: size.width * 0.7,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: padding * 0.5,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       items[index].title,
//                                       style: GoogleFonts.urbanist(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: fontSize * 0.85,
//                                       ),
//                                     ),
//                                     SizedBox(height: size.height * 0.005),
//                                     Row(
//                                       children: [
//                                         SvgPicture.asset(
//                                           "assets/home_assets/rating.svg",
//                                           height: size.width * 0.045,
//                                           width: size.width * 0.045,
//                                         ),
//                                         SizedBox(width: size.width * 0.02),
//                                         Text(
//                                           items[index].rating,
//                                           style: GoogleFonts.urbanist(
//                                             color: Colors.white70,
//                                             fontSize: fontSize * 0.75,
//                                           ),
//                                         ),
//                                         SizedBox(width: size.width * 0.01),
//                                         Text(
//                                           "(${items[index].reviews})",
//                                           style: GoogleFonts.urbanist(
//                                             color: Colors.white70,
//                                             fontSize: fontSize * 0.7,
//                                           ),
//                                         ),
//                                         SizedBox(width: size.width * 0.01),
//                                         Text(
//                                           "${items[index].distance} away",
//                                           style: GoogleFonts.urbanist(
//                                             color: Colors.white70,
//                                             fontSize: fontSize * 0.7,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   SizedBox(height: size.height * 0.005),
//                                   Text(
//                                     'AED ${items[index].price}',
//                                     style: GoogleFonts.urbanist(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: fontSize * 1.1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Widget superStar(Size size) {
//   return Container(
//     padding: EdgeInsets.symmetric(
//       horizontal: size.width * 0.02,
//       vertical: size.height * 0.005,
//     ),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [const Color(0xff3579DD), const Color(0xff3DFF51)],
//       ),
//       borderRadius: BorderRadius.circular(42),
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SvgPicture.asset(
//           "assets/home_assets/crown.svg",
//           height: size.width * 0.04,
//         ),
//         SizedBox(width: size.width * 0.01),
//         Text(
//           "Superstar Stuff",
//           style: GoogleFonts.urbanist(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: size.width * 0.03,
//           ),
//         ),
//       ],
//     ),
//   );
// }
