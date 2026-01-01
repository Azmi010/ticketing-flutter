part of 'card_category_bloc.dart';

enum CardCategoryStatus { initial, success, error, loading }

extension CardCategoryStatusX on CardCategoryStatus {
  bool get isInitial => this == CardCategoryStatus.initial;
  bool get isSuccess => this == CardCategoryStatus.success;
  bool get isError => this == CardCategoryStatus.error;
  bool get isLoading => this == CardCategoryStatus.loading;
}

class CardCategoryState extends Equatable {
  const CardCategoryState({
    this.status = CardCategoryStatus.initial,
    List<Category>? categories,
  }) : categories = categories ?? const [];

  final List<Category> categories;
  final CardCategoryStatus status;

  @override
  List<Object?> get props => [status, categories];

  CardCategoryState copyWith({
    List<Category>? categories,
    CardCategoryStatus? status,
  }) {
    return CardCategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }
}
