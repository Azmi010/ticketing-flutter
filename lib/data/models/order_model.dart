import 'package:equatable/equatable.dart';
import 'order_detail_model.dart';
import 'user_model.dart';

class Order extends Equatable {
  final int id;
  final double totalPrice;
  final DateTime createdAt;
  final UserModel? user;
  final List<OrderDetail>? details;

  const Order({
    required this.id,
    required this.totalPrice,
    required this.createdAt,
    this.user,
    this.details,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      totalPrice: json['total_price'] != null
          ? (json['total_price'] is double
              ? json['total_price']
              : double.parse(json['total_price'].toString()))
          : 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      details: json['details'] != null
          ? (json['details'] as List)
              .map((d) => OrderDetail.fromJson(d))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_price': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'user': user?.toJson(),
      'details': details?.map((d) => d.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, totalPrice, createdAt, user, details];
}
