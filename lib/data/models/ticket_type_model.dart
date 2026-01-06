import 'package:equatable/equatable.dart';
import 'event_model.dart';

class TicketType extends Equatable {
  final int id;
  final String name;
  final double price;
  final int quota;
  final int? eventId;
  final Event? event;

  const TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.quota,
    this.eventId,
    this.event,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      price: json['price'] != null
          ? (json['price'] is double
              ? json['price']
              : double.parse(json['price'].toString()))
          : 0.0,
      quota: json['quota'] != null
          ? (json['quota'] is int ? json['quota'] : int.parse(json['quota'].toString()))
          : 0,
      eventId: json['eventId'] != null
          ? (json['eventId'] is int ? json['eventId'] : int.parse(json['eventId'].toString()))
          : null,
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quota': quota,
      'eventId': eventId,
      'event': event?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, name, price, quota, eventId, event];
}
