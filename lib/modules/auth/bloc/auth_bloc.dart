import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      
      await Future.delayed(const Duration(seconds: 2));

      if (event.email == "admin@mail.com" && event.password == "password") {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Email atau password salah"));
      }
    });
  }
}