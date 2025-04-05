import 'admin/description_screen/cubit/description_cubit.dart';
import 'admin/image_picker/cubit/media_cubit.dart';
import 'admin/report_details/cubit/report_details_cubit.dart';
import 'presentation/saved_screen/cubit/save_cubit.dart';
import 'user_onboarding/sign_up_screen/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bottom_navigation_bar.dart';
import 'core/constants.dart';
import 'presentation/start_screen/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.anonKey,
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
        BlocProvider(create: (context) => SaveCubit()),
        BlocProvider(create: (context) => MediaCubit()),
        BlocProvider(create: (context) => ReportDetailsCubit()),
        BlocProvider(create: (context) => DescriptionCubit()),
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
      title: 'Aloha Funds',
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null ? const BottomNavScreen() : StartScreen();
  }
}
