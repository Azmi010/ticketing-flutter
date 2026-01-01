import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/category_model.dart';
import 'package:ticketing_flutter/data/repositories/event_repository.dart';

part 'card_category_event.dart';
part 'card_category_state.dart';

class CardCategoryBloc extends Bloc<CardCategoryEvent, CardCategoryState> {
  CardCategoryBloc({
    required this.eventRepository,
  }) : super(const CardCategoryState()) {
    on<GetBrowseCategories>(_mapGetBrowseCategoriesEventToState);
  }
  final EventRepository eventRepository;

  void _mapGetBrowseCategoriesEventToState(
      GetBrowseCategories event, Emitter<CardCategoryState> emit) async {
    emit(state.copyWith(status: CardCategoryStatus.loading));
    try {
      final categories = await eventRepository.getBrowseCategories();
      emit(
        state.copyWith(
          status: CardCategoryStatus.success,
          categories: categories,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: CardCategoryStatus.error));
    }
  }
}
