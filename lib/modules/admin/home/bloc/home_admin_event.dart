import 'package:equatable/equatable.dart';

abstract class HomeAdminEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends HomeAdminEvent {}
