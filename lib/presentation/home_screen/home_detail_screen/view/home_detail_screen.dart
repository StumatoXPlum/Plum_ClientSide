// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../model/affordable_package_model.dart';
// import '../model/drink_model.dart';
// import '../../../cart/view/cart_screen.dart';
// import '../cubit/booking_cubit.dart';
// import '../cubit/cart_buttons.dart';
// import '../model/booking_model.dart';
// import '../widgets/affordable_package.dart';
// import '../widgets/drink_view.dart';
// import '../widgets/time_date.dart';
// import '../widgets/chip_widget.dart';
// import '../../home_screen/model/recommendation_model.dart';
// import '../../../cart/model/cart_model.dart';
// import '../../../cart/cubit/cart_cubit.dart';

// class HomeDetailScreen extends StatelessWidget {
//   final RecommendationModel item;
//   const HomeDetailScreen({super.key, required this.item});
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartButtonCubit, Map<String, int>>(
//       builder: (context, cartState) {
//         bool hasItemsInCart = cartState.values.any((quantity) => quantity > 0);
//         return BlocBuilder<BookingCubit, BookingState>(
//           builder: (context, bookingState) {
//             return HomeDetailContent(
//               item: item,
//               hasItemsInCart: hasItemsInCart,
//               cartState: cartState,
//               currentView: bookingState.currentView,
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class HomeDetailContent extends StatelessWidget {
//   final RecommendationModel item;
//   final bool hasItemsInCart;
//   final Map<String, int> cartState;
//   final BookingView currentView;

//   const HomeDetailContent({
//     super.key,
//     required this.item,
//     required this.hasItemsInCart,
//     required this.cartState,
//     required this.currentView,
//   });

//   Future<void> openWhatsApp() async {
//     final String phoneNumber = "918421323223";
//     final String message = "Hello! I need help.";

//     try {
//       String whatsappUrl =
//           "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";
//       await launchUrl(
//         Uri.parse(whatsappUrl),
//         mode: LaunchMode.externalApplication,
//       );
//     } catch (e) {
//       print('error:$e');
//       try {
//         final Uri uri = Uri(
//           scheme: 'intent',
//           path: 'send',
//           queryParameters: {'phone': phoneNumber, 'text': message},
//           fragment: 'Intent;package=com.whatsapp;scheme=whatsapp;end',
//         );

//         await launchUrl(uri);
//       } catch (e) {
//         print('Faile: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;
//     return Scaffold(
//       backgroundColor: const Color(0xff090D14),
//       bottomNavigationBar:
//           currentView == BookingView.package
//               ? _buildPackageButtons(context)
//               : (currentView == BookingView.drink
//                   ? _buildDrinkButtons(context)
//                   : null),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Hero(
//                   tag: 'image${item.title}',
//                   child: Image.asset(
//                     item.image,
//                     height: size.height * 0.4,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   left: padding * 2,
//                   top: padding * 4,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: SvgPicture.asset(
//                       'assets/sign_up_assets/back.svg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   right: padding * 2,
//                   top: padding * 4,
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ShoppingCartScreen(),
//                         ),
//                       );
//                     },
//                     child: SvgPicture.asset(
//                       'assets/home_assets/cart.svg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: size.height * 0.02),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.title,
//                         style: GoogleFonts.urbanist(
//                           fontSize: size.width * 0.05,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.01),
//                       Text(
//                         '${item.distance} away',
//                         style: GoogleFonts.urbanist(
//                           fontSize: size.width * 0.045,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   GestureDetector(
//                     onTap: openWhatsApp,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: padding * 1.5,
//                         vertical: padding * 0.8,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Color(0xff3579DD), width: 1),
//                         borderRadius: BorderRadius.circular(42),
//                       ),
//                       child: Text(
//                         "Message",
//                         style: GoogleFonts.urbanist(
//                           fontSize: fontSize * 0.7,
//                           color: Color(0xff3579DD),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: size.height * 0.05),
//             Padding(
//               padding: EdgeInsets.only(left: padding * 1.6),
//               child: Text(
//                 "Book a table",
//                 style: GoogleFonts.urbanist(
//                   fontSize: fontSize,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: size.height * 0.01),
//             BookingWidget(hasItemsInCart: hasItemsInCart),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BookingWidget extends StatelessWidget {
//   final bool hasItemsInCart;

//   const BookingWidget({super.key, required this.hasItemsInCart});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         SizedBox(height: size.height * 0.02),
//         buildNavigationChips(context),
//         SizedBox(height: size.height * 0.02),
//         BlocBuilder<BookingCubit, BookingState>(
//           builder: (context, state) {
//             switch (state.currentView) {
//               case BookingView.dateTime:
//                 return buildDateTimeView(context);
//               case BookingView.package:
//                 return buildPackagesView(context);
//               case BookingView.drink:
//                 return buildDrinkView(context);
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// Widget _buildActionButton(
//   BuildContext context, {
//   required String label,
//   required Color color,
//   required Color textColor,
//   required VoidCallback onTap,
// }) {
//   return Expanded(
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         side: const BorderSide(color: Color(0xff3579DD)),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       ),
//       onPressed: onTap,
//       child: Text(
//         label,
//         style: GoogleFonts.urbanist(color: textColor, fontSize: 16),
//       ),
//     ),
//   );
// }

// Widget _buildPackageButtons(BuildContext context) {
//   return Container(
//     color: const Color(0xff090D14),
//     padding: EdgeInsets.symmetric(
//       vertical: 16,
//       horizontal: MediaQuery.of(context).size.width * 0.05,
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildActionButton(
//           context,
//           label: "Next",
//           color: Colors.transparent,
//           textColor: Color(0xff3579DD),
//           onTap: () {
//             final cartCubit = context.read<CartCubit>();
//             final cartButtonCubit = context.read<CartButtonCubit>();
//             final selectedPackages = cartButtonCubit.state.entries.where(
//               (entry) => entry.value > 0,
//             );
//             for (var entry in selectedPackages) {
//               final package = affordablePackages.firstWhere(
//                 (pkg) => pkg.title == entry.key,
//               );
//               final cartItem = CartItem(
//                 name: package.title,
//                 price: double.parse(
//                   package.price.replaceAll(RegExp(r'[^\d.]'), ''),
//                 ),
//                 quantity: entry.value,
//                 image: package.imageUrl,
//                 description: package.description,
//               );
//               cartCubit.addToCart(cartItem, context);
//             }
//             context.read<BookingCubit>().changeView(BookingView.drink);
//           },
//         ),
//         SizedBox(width: 10),
//         _buildActionButton(
//           context,
//           label: "Clear",
//           color: Color(0xff3579DD),
//           textColor: Colors.white,
//           onTap: () {
//             context.read<CartCubit>().clearCart(context);
//           },
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildDrinkButtons(BuildContext context) {
//   return Container(
//     color: const Color(0xff090D14),
//     padding: EdgeInsets.symmetric(
//       vertical: 16,
//       horizontal: MediaQuery.of(context).size.width * 0.05,
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildActionButton(
//           context,
//           label: "Add to Cart",
//           color: Colors.transparent,
//           textColor: const Color(0xff3579DD),
//           onTap: () {
//             final cartCubit = context.read<CartCubit>();
//             final cartButtonCubit = context.read<CartButtonCubit>();
//             final selectedDrinks =
//                 cartButtonCubit.state.entries
//                     .where((entry) => entry.value > 0)
//                     .toList();
//             if (selectedDrinks.isEmpty) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text("No drinks selected!")));
//               return;
//             }
//             for (var entry in selectedDrinks) {
//               final drink = drinks.firstWhere(
//                 (d) => d.title == entry.key,
//                 orElse:
//                     () => DrinkModel(
//                       title: '',
//                       price: '0',
//                       imageUrl: '',
//                       description: '',
//                     ),
//               );
//               if (drink.title.isNotEmpty) {
//                 final cartItem = CartItem(
//                   name: drink.title,
//                   price: double.parse(
//                     drink.price.replaceAll(RegExp(r'[^\d.]'), ''),
//                   ),
//                   quantity: entry.value,
//                   image: drink.imageUrl,
//                   description: drink.description,
//                 );
//                 cartCubit.addToCart(cartItem, context);
//               }
//             }
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 behavior: SnackBarBehavior.floating,
//                 backgroundColor: Colors.green.shade600,
//                 content: Text(
//                   "Added to cart successfully!",
//                   style: GoogleFonts.urbanist(color: Colors.white),
//                 ),
//               ),
//             );
//           },
//         ),
//         SizedBox(width: 10),
//         _buildActionButton(
//           context,
//           label: "Buy Now",
//           color: const Color(0xff3579DD),
//           textColor: Colors.white,
//           onTap: () {
//             final cartCubit = context.read<CartCubit>();
//             final cartButtonCubit = context.read<CartButtonCubit>();
//             final selectedDrinks =
//                 cartButtonCubit.state.entries
//                     .where((entry) => entry.value > 0)
//                     .toList();
//             if (selectedDrinks.isEmpty) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text("No drinks selected!")));
//               return;
//             }
//             for (var entry in selectedDrinks) {
//               final drink = drinks.firstWhere(
//                 (d) => d.title == entry.key,
//                 orElse:
//                     () => DrinkModel(
//                       title: '',
//                       price: '0',
//                       imageUrl: '',
//                       description: '',
//                     ),
//               );
//               if (drink.title.isNotEmpty) {
//                 final cartItem = CartItem(
//                   name: drink.title,
//                   price: double.parse(
//                     drink.price.replaceAll(RegExp(r'[^\d.]'), ''),
//                   ),
//                   quantity: entry.value,
//                   image: drink.imageUrl,
//                   description: drink.description,
//                 );
//                 cartCubit.addToCart(cartItem, context);
//               }
//             }
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
//             );
//           },
//         ),
//       ],
//     ),
//   );
// }
