import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:ticketing_flutter/modules/auth/screen/login_screen.dart';
import 'package:ticketing_flutter/modules/nav/screen/navbar_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AuthBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ticketing App',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => const NavbarScreen(),
        },
      ),
    );
  }
}
