part of 'event_by_category_bloc.dart';

abstract class EventByCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetEventsByCategory extends EventByCategoryEvent {
  final int categoryId;
  GetEventsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}