import 'package:equatable/equatable.dart';
import 'ticket_type_model.dart';

class OrderDetail extends Equatable {
  final int id;
  final int qty;
  final TicketType? ticket;

  const OrderDetail({
    required this.id,
    required this.qty,
    this.ticket,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      qty: json['qty'] != null
          ? (json['qty'] is int ? json['qty'] : int.parse(json['qty'].toString()))
          : 0,
      ticket: json['ticket'] != null ? TicketType.fromJson(json['ticket']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'ticket': ticket?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, qty, ticket];
}
