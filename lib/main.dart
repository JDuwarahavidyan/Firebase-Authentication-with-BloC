import 'package:auth/bloc/auth/auth_bloc.dart';
import 'package:auth/bloc/user/user_bloc.dart';
import 'package:auth/canteen_screen.dart';
import 'package:auth/student_screen.dart';
import 'package:auth/repositories/auth_repository.dart';
import 'package:auth/reset_email.dart';
import 'package:auth/reset_password.dart';
import 'package:auth/services/auth_service.dart';
import 'package:auth/register_screen.dart';
import 'package:auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final AuthRepository authRepository = AuthRepository(
    firebaseAuthService: FirebaseAuthService(),
  );
  
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc()..add(UserReadEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RegisterScreen(),
        routes: {
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/student': (context) => const StudentHomeScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/reset-email': (context) => const ResetEmailScreen(),
          '/canteen': (context) => const CanteenHomeScreen(),

        },
      ),
    );
  }
}
