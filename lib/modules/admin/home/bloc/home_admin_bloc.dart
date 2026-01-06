import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';
import 'home_admin_event.dart';
import 'home_admin_state.dart';

class HomeAdminBloc extends Bloc<HomeAdminEvent, HomeAdminState> {
  final EventRepository eventRepository;

  HomeAdminBloc({required this.eventRepository}) : super(HomeAdminInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<HomeAdminState> emit,
  ) async {
    emit(HomeAdminLoading());
    try {
      // Simulate API call to get dashboard statistics
      await Future.delayed(const Duration(seconds: 1));
      
      final events = await eventRepository.getEvents();
      
      // Calculate statistics
      final stats = DashboardStats(
        totalEvents: events.length,
        activeEvents: events.length,
        totalTicketsSold: 1250, // Mock data
        totalRevenue: 45780.50, // Mock data
      );
      
      emit(HomeAdminLoaded(stats));
    } catch (e) {
      emit(HomeAdminError('Failed to load dashboard data: ${e.toString()}'));
    }
  }
}
