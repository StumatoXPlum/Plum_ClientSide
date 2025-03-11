import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task2/presentation/home_screen/home_screen/view/new_home_screen.dart';
import 'core/bottom_navigation_bar.dart';
import 'core/constants.dart';
import 'firebase_options.dart';
import 'presentation/authentication_screens/sign_up_screen/cubit/auth_cubit.dart';
import 'presentation/authentication_screens/sign_up_screen/view/sign_up_screen.dart';
import 'presentation/cart/cubit/cart_cubit.dart';
import 'presentation/history_screen/cubit/order_history_cubit.dart';
import 'presentation/home_screen/home_detail_screen/cubit/booking_cubit.dart';
import 'presentation/home_screen/home_detail_screen/cubit/cart_buttons.dart';
import 'presentation/home_screen/home_screen/cubit/earned_points_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    anonKey: AppSecrets.anonKey,
    url: AppSecrets.supabaseUrl,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => OrderHistoryCubit()),
        BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => CartButtonCubit()),
        BlocProvider(create: (context) => EarnedPointsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: NewHomeScreen(),
    );
  }

  Widget _getInitialScreen() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? const BottomNavScreen() : SignUpScreen();
  }
}
