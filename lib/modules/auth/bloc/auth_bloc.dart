import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({AuthRepository? authRepository})
      : authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.login(event.email, event.password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logout();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }
}