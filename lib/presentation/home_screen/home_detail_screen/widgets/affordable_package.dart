// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../cubit/cart_buttons.dart';
// import '../model/affordable_package_model.dart';
// import 'quantity_control.dart';

// Widget buildPackagesView(BuildContext context) {
//   final Size size = MediaQuery.of(context).size;
//   double padding = size.width * 0.03;
//   double fontSize = size.width * 0.05;
//   return BlocBuilder<CartButtonCubit, Map<String, int>>(
//     builder: (context, cartState) {
//       print("Cart State: $cartState");
//       bool hasItemsInCart = cartState.values.any((quantity) => quantity > 0);
//       return Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(padding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Available Packages',
//                     style: GoogleFonts.urbanist(
//                       color: Colors.white,
//                       fontSize: fontSize,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.only(bottom: hasItemsInCart ? 80 : 0),
//                     itemCount: affordablePackages.length,
//                     itemBuilder: (context, index) {
//                       final package = affordablePackages[index];
//                       return PackageItem(package: package);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// class PackageItem extends StatelessWidget {
//   final AffordablePackageModel package;

//   const PackageItem({super.key, required this.package});

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     double padding = size.width * 0.03;
//     double fontSize = size.width * 0.05;

//     return Container(
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: size.width * 0.2,
//             height: size.height * 0.1,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset(
//                 package.imageUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(Icons.restaurant, color: Colors.white);
//                 },
//               ),
//             ),
//           ),
//           SizedBox(width: size.width * 0.03),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 package.title,
//                 style: GoogleFonts.urbanist(
//                   color: Colors.white,
//                   fontSize: fontSize * 1,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               Text(
//                 package.price,
//                 style: GoogleFonts.urbanist(
//                   color: Colors.grey,
//                   fontSize: fontSize * 0.8,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           QuantityControl(category: package.title),
//         ],
//       ),
//     );
//   }
// }
