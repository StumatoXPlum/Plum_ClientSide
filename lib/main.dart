import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/bookmark_screen/cubit/bookmark_cubit.dart';
import 'presentation/ticket/cubit/ticket_cubit.dart';
import 'core/custom_widgets/bottom_navigation_bar.dart';
import 'core/constants.dart';
import 'presentation/authentication_screens/sign_up_screen/cubit/auth_cubit.dart';
import 'presentation/authentication_screens/sign_up_screen/view/sign_up_screen.dart';
import 'presentation/points_screen/cubit/earned_points_cubit.dart';

void main() async {
  await Supabase.initialize(
    anonKey: AppSecrets.anonKey,
    url: AppSecrets.supabaseUrl,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => EarnedPointsCubit()),
        BlocProvider(create: (context) => BookmarkCubit()),
        BlocProvider(create: (context) => TicketCubit()),
      ],
      child: MyApp(),
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
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null ? const BottomNavScreen() : SignUpScreen();
  }
}
