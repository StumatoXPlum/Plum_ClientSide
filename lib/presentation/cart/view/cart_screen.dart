// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:task2/presentation/cart/cubit/cart_cubit.dart';
// import 'package:task2/presentation/cart/model/cart_model.dart';
// import 'package:task2/presentation/history_screen/cubit/order_history_cubit.dart';
// import 'package:task2/presentation/payment/view/payment_screen.dart';

// class ShoppingCartScreen extends StatelessWidget {
//   const ShoppingCartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;

//     return Scaffold(
//       backgroundColor: const Color(0xff090D14),
//       body: BlocBuilder<CartCubit, List<CartItem>>(
//         builder: (context, cartItems) {
//           double totalPrice = context.read<CartCubit>().getTotalPrice();
//           bool isCartEmpty = cartItems.isEmpty;

//           return SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(padding),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: SvgPicture.asset(
//                           'assets/sign_up_assets/back.svg',
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.03),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: padding),
//                         child: Text(
//                           "Shopping Cart",
//                           style: GoogleFonts.urbanist(
//                             color: Colors.white,
//                             fontSize: fontSize * 1.2,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: size.height * 0.02),
//                 if (isCartEmpty) ...[
//                   Expanded(
//                     child: Center(
//                       child: Column(
//                         children: [
//                           SvgPicture.asset("assets/empty_state/empty_cart.svg"),
//                           SizedBox(height: size.height * 0.01),
//                           Text(
//                             "Cart empty",
//                             style: GoogleFonts.urbanist(
//                               color: Colors.white,
//                               fontSize: fontSize,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.01),
//                           Text(
//                             "Your cart is empty.",
//                             style: GoogleFonts.urbanist(
//                               color: Colors.white70,
//                               fontSize: fontSize * 0.75,
//                             ),
//                           ),
//                           Text(
//                             "Start adding items to enjoy shopping!",
//                             style: GoogleFonts.urbanist(
//                               color: Colors.white70,
//                               fontSize: fontSize * 0.75,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ] else ...[
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: padding * 0.5,
//                           horizontal: padding,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color(0xff1E1C16),
//                           border: Border.all(
//                             color: Color(0xffE09C35),
//                             width: 0.4,
//                           ),
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.info,
//                               color: Color(0xffE09C35),
//                               size: 18,
//                             ),
//                             SizedBox(width: size.width * 0.02),
//                             Text(
//                               "Product more than 2 days are automatically lost",
//                               style: GoogleFonts.urbanist(
//                                 color: Color(0xffE09C35),
//                                 fontSize: fontSize * 0.65,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: cartItems.length,
//                       itemBuilder: (context, index) {
//                         final item = cartItems[index];
//                         return CartItemTile(item: item);
//                       },
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//                     child: Text(
//                       "Order Summary",
//                       style: GoogleFonts.urbanist(
//                         color: Colors.white,
//                         fontSize: fontSize,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           vertical: padding,
//                           horizontal: padding,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Color(0xff161C25),

//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         child: Row(
//                           children: [
//                             SvgPicture.asset(
//                               'assets/home_assets/promo.svg',
//                               fit: BoxFit.scaleDown,
//                               colorFilter: ColorFilter.mode(
//                                 Color(0xff3579DD),
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             SizedBox(width: size.width * 0.02),
//                             Text(
//                               "Add promos before you order",
//                               style: GoogleFonts.urbanist(
//                                 color: Colors.white,
//                                 fontSize: fontSize * 0.7,
//                               ),
//                             ),
//                             Spacer(),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Color(0xff3579DD),
//                               size: 12,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
//                     child: Container(
//                       padding: EdgeInsets.all(padding),
//                       color: const Color(0xff090D14),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "items",
//                                 style: GoogleFonts.urbanist(
//                                   color: Colors.grey,
//                                   fontSize: fontSize,
//                                 ),
//                               ),
//                               Text(
//                                 "AED ${totalPrice.toStringAsFixed(2)}",
//                                 style: GoogleFonts.urbanist(
//                                   color: Colors.white,

//                                   fontSize: fontSize,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Divider(color: Colors.grey, thickness: 0.1),
//                   SizedBox(height: size.height * 0.01),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xff3579DD),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: padding * 1),
//                     ),
//                     onPressed: () {
//                       final cartCubit = context.read<CartCubit>();
//                       final orderHistoryCubit =
//                           context.read<OrderHistoryCubit>();

//                       orderHistoryCubit.addOrder(cartCubit.state);
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PaymentScreen(),
//                         ),
//                       );
//                     },
//                     child: Center(
//                       child: Text(
//                         "Proceed to Pay",
//                         style: GoogleFonts.urbanist(
//                           fontSize: fontSize,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class CartItemTile extends StatelessWidget {
//   final CartItem item;

//   const CartItemTile({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.045;

//     return Container(
//       margin: EdgeInsets.symmetric(
//         vertical: padding * 0.1,
//         horizontal: padding,
//       ),
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(
//               item.image,
//               width: size.width * 0.2,
//               height: size.height * 0.1,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(width: size.width * 0.04),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: GoogleFonts.urbanist(
//                     color: Colors.white,
//                     fontSize: fontSize,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: size.height * 0.004),
//                 SizedBox(
//                   width: size.width * 0.5,
//                   child: Text(
//                     item.description,
//                     style: GoogleFonts.urbanist(
//                       color: Colors.grey,
//                       fontSize: fontSize * 0.75,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ),
//                 SizedBox(height: size.height * 0.01),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "AED ${item.price}",
//                       style: GoogleFonts.urbanist(
//                         color: Colors.white,
//                         fontSize: fontSize * 0.85,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Flexible(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: padding * 0.3,
//                               vertical: padding * 0.2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xff161C25),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     context.read<CartCubit>().updateQuantity(
//                                       item.name,
//                                       item.quantity - 1,
//                                       context,
//                                     );
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(3),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.remove,
//                                       color: Color(0xff3579DD),
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: size.width * 0.02),
//                                 Text(
//                                   "${item.quantity}",
//                                   style: GoogleFonts.urbanist(
//                                     color: Colors.white,
//                                     fontSize: fontSize,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(width: size.width * 0.02),
//                                 GestureDetector(
//                                   onTap: () {
//                                     context.read<CartCubit>().updateQuantity(
//                                       item.name,
//                                       item.quantity + 1,
//                                       context,
//                                     );
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(3),
//                                     decoration: const BoxDecoration(
//                                       color: Colors.black,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.add,
//                                       color: Color(0xff3579DD),
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
