import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/core/custom_widgets/neopop_button.dart';
import 'package:task2/presentation/ticket/cubit/ticket_cubit.dart';
import '../../apple_pay_animation/apple_pay.dart';
import '../cubit/payment_cubit.dart';
import '../../ticket/model/ticket_model.dart';
import '../../wallet/wallet_screen.dart';

class PaymentScreen extends StatelessWidget {
  final TicketModel ticket;
  const PaymentScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xff090D14),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset("assets/sign_up_assets/back.svg"),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "Payment Method",
                    style: GoogleFonts.urbanist(
                      fontSize: fontSize * 1.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const WalletScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(42),
                          border: Border.all(color: Color(0xff202938)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                color: Color(0xff2D3748),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xff202938),
                                  width: 2,
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/payment_assets/wallet.svg",
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Wallet",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Available balance : AED 183.43",
                                  style: GoogleFonts.urbanist(
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff3579DD),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    "Other Method",
                    style: GoogleFonts.urbanist(
                      fontSize: fontSize * 1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  PaymentMethod(
                    iconPath: "assets/payment_assets/master.svg",
                    label: "MasterCard",
                  ),
                  SizedBox(height: size.height * 0.02),
                  PaymentMethod(
                    iconPath: "assets/payment_assets/paypal.svg",
                    label: "Paypal",
                  ),
                  SizedBox(height: size.height * 0.02),
                  PaymentMethod(
                    iconPath: "assets/payment_assets/stripe.svg",
                    label: "Stripe",
                  ),
                  SizedBox(height: size.height * 0.02),
                  PaymentMethod(
                    iconPath: "assets/payment_assets/apl_pay.svg",
                    label: "Apple Pay",
                  ),
                  SizedBox(height: size.height * 0.02),
                  buildDebitCard(context),
                  SizedBox(height: size.height * 0.05),
                  Divider(color: Colors.grey, thickness: 0.1),
                  SizedBox(height: size.height * 0.01),
                  NeopopButton(
                    buttonText: "Proceed to Payment",
                    onTap: () async {
                      final paymentSuccessful =
                          await Navigator.push<bool>(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) => ApplePayScreen(ticket: ticket),
                            ),
                          ) ??
                          false;
                      if (paymentSuccessful) {
                        final userId =
                            Supabase.instance.client.auth.currentUser?.id;
                        if (userId != null) {
                          final ticketWithUser = ticket.copyWith(
                            userId: userId,
                          );
                          final ticketData = ticketWithUser.toJson();
                          ticketData.remove('id');
                          try {
                            await Supabase.instance.client
                                .from('bookings')
                                .insert(ticketData);
                            if (context.mounted) {
                              await context.read<TicketCubit>().fetchTickets();
                            }
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => const PaymentSuccessDialog(),
                              );
                              await Future.delayed(const Duration(seconds: 3));
                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              }
                            }
                          } catch (e) {
                            print("Booking failed: $e");
                          }
                        }
                      }
                    },
                  ),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final String iconPath;
  final String label;

  const PaymentMethod({super.key, required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;
    return BlocBuilder<PaymentCubit, String?>(
      builder: (context, selectedMethod) {
        bool isSelected = selectedMethod == label;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
          child: GestureDetector(
            onTap: () {
              context.read<PaymentCubit>().selectPaymentMethod(label);
            },
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(42),
                border: Border.all(color: Color(0xff202938)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: Color(0xff2D3748),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xff202938), width: 2),
                    ),
                    child: SvgPicture.asset(iconPath, fit: BoxFit.scaleDown),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: fontSize * 0.9,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: Color(0xff3579DD),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildDebitCard(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  double padding = size.width * 0.03;
  double fontSize = size.width * 0.05;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: padding * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: Color(0xff202938)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.add, color: Colors.white),
          SizedBox(width: size.width * 0.03),
          Text(
            'Add Debit Card',
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: fontSize * 0.9,
            ),
          ),
        ],
      ),
    ),
  );
}
