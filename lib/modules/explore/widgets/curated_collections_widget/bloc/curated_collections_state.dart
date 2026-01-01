part of 'curated_collections_bloc.dart';

enum CuratedCollectionsStatus { initial, success, error, loading }

extension CuratedCollectionsStatusX on CuratedCollectionsStatus {
  bool get isInitial => this == CuratedCollectionsStatus.initial;
  bool get isSuccess => this == CuratedCollectionsStatus.success;
  bool get isError => this == CuratedCollectionsStatus.error;
  bool get isLoading => this == CuratedCollectionsStatus.loading;
}

class CuratedCollectionsState extends Equatable {
  const CuratedCollectionsState({
    this.status = CuratedCollectionsStatus.initial,
    List<Event>? weekendEvents,
    List<Event>? freeEvents,
  })  : weekendEvents = weekendEvents ?? const [],
        freeEvents = freeEvents ?? const [];

  final List<Event> weekendEvents;
  final List<Event> freeEvents;
  final CuratedCollectionsStatus status;

  @override
  List<Object?> get props => [status, weekendEvents, freeEvents];

  CuratedCollectionsState copyWith({
    List<Event>? weekendEvents,
    List<Event>? freeEvents,
    CuratedCollectionsStatus? status,
  }) {
    return CuratedCollectionsState(
      weekendEvents: weekendEvents ?? this.weekendEvents,
      freeEvents: freeEvents ?? this.freeEvents,
      status: status ?? this.status,
    );
  }
}
