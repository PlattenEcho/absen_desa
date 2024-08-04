import 'package:absen_desa/controller/storage_controller.dart';
import 'package:absen_desa/cubit/cubit.dart';
import 'package:absen_desa/ui/pages/login_page.dart';
import 'package:absen_desa/ui/pages/main_page.dart';
import 'package:absen_desa/ui/pages/register_page.dart';
import 'package:absen_desa/ui/pages/splash_screen.dart';
import 'package:absen_desa/ui/pages/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(StorageController());
  try {
    await Supabase.initialize(
      url: 'https://gxmkwumsyxqpxtaefgeu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4bWt3dW1zeXhxcHh0YWVmZ2V1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjE4Njg5NTMsImV4cCI6MjAzNzQ0NDk1M30.zx-MamaN2Gl4pERvAgynHobMMOqEXNRrwHP1LuCXrOQ',
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Error initializing Supabase: $e');
  }
  runApp(MainApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageCubit(),
        ),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, routes: {
        '/': (context) => const SplashScreen(),
        '/start-screen': (context) => const StartScreen(),
        '/login-page': (context) => const LoginPage(),
        '/register-page': (context) => const RegisterPage(),
        '/main-page': (context) => const MainPage(pageIndex: 0),
      }),
    );
  }
}
