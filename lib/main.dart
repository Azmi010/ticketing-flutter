import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ticketing_flutter/core/config/graphql_config.dart';
import 'package:ticketing_flutter/data/repositories/auth_repository.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_event.dart';
import 'package:ticketing_flutter/modules/auth/screen/login_screen.dart';
import 'package:ticketing_flutter/modules/auth/widgets/auth_middleware.dart';
import 'package:ticketing_flutter/modules/nav/screen/navbar_admin_screen.dart';
import 'package:ticketing_flutter/modules/nav/screen/navbar_user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ValueNotifier<GraphQLClient>>(
      future: GraphQLConfig.initializeClient(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return GraphQLProvider(
          client: snapshot.data!,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(
                  authRepository: AuthRepository(),
                )..add(CheckAuthStatus()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ticketing App',
              home: const AuthMiddleware(),
              routes: {
                '/login': (context) => LoginScreen(),
                '/user': (context) => const NavbarUserScreen(),
                '/admin': (context) => const NavbarAdminScreen(),
              },
            ),
          ),
        );
      },
    );
  }
}
