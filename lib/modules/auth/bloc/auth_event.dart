import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}