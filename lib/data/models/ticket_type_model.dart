import 'package:equatable/equatable.dart';

class TicketType extends Equatable {
  final int id;
  final String name;
  final double price;
  final int quota;
  final int? eventId;

  const TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.quota,
    this.eventId,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      price: json['price'] is double
          ? json['price']
          : double.parse(json['price'].toString()),
      quota: json['quota'] is int ? json['quota'] : int.parse(json['quota'].toString()),
      eventId: json['eventId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quota': quota,
      'eventId': eventId,
    };
  }

  @override
  List<Object?> get props => [id, name, price, quota, eventId];
}
