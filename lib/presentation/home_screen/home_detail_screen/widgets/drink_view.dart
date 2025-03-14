// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../cubit/cart_buttons.dart';
// import '../model/drink_model.dart';
// import 'quantity_control.dart';

// Widget buildDrinkView(BuildContext context) {
//   final Size size = MediaQuery.of(context).size;
//   double padding = size.width * 0.03;
//   double fontSize = size.width * 0.05;

//   return BlocBuilder<CartButtonCubit, Map<String, int>>(
//     builder: (context, cartState) {
//       return Padding(
//         padding: EdgeInsets.all(padding),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Available Drinks',
//               style: GoogleFonts.urbanist(
//                 color: Colors.white,
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: size.height * 0.02),

//             Flexible(
//               fit: FlexFit.loose,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.only(bottom: 60),
//                 itemCount: drinks.length,
//                 itemBuilder: (context, index) {
//                   final drink = drinks[index];
//                   return _buildDrinkItem(context, drink);
//                 },
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _buildDrinkItem(BuildContext context, DrinkModel drinks) {
//   final Size size = MediaQuery.of(context).size;
//   double padding = size.width * 0.03;
//   double fontSize = size.width * 0.05;

//   return Container(
//     padding: EdgeInsets.all(padding),
//     decoration: BoxDecoration(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Row(
//       children: [
//         Container(
//           width: size.width * 0.2,
//           height: size.height * 0.1,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.asset(
//               drinks.imageUrl,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(Icons.restaurant, color: Colors.white);
//               },
//             ),
//           ),
//         ),
//         SizedBox(width: size.width * 0.03),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               drinks.title,
//               style: GoogleFonts.urbanist(
//                 color: Colors.white,
//                 fontSize: fontSize * 1,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//               maxLines: 2,
//             ),
//             Text(
//               drinks.price,
//               style: GoogleFonts.urbanist(
//                 color: Colors.grey,
//                 fontSize: fontSize * 0.8,
//               ),
//             ),
//           ],
//         ),
//         Spacer(),
//         QuantityControl(category: drinks.title),
//       ],
//     ),
//   );
// }
