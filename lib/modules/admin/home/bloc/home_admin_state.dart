import 'package:equatable/equatable.dart';

class DashboardStats {
  final int totalEvents;
  final int activeEvents;
  final int totalTicketsSold;
  final double totalRevenue;

  DashboardStats({
    required this.totalEvents,
    required this.activeEvents,
    required this.totalTicketsSold,
    required this.totalRevenue,
  });
}

abstract class HomeAdminState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeAdminInitial extends HomeAdminState {}

class HomeAdminLoading extends HomeAdminState {}

class HomeAdminLoaded extends HomeAdminState {
  final DashboardStats stats;

  HomeAdminLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class HomeAdminError extends HomeAdminState {
  final String message;

  HomeAdminError(this.message);

  @override
  List<Object?> get props => [message];
}
