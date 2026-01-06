import 'package:equatable/equatable.dart';
import 'category_model.dart';
import 'user_model.dart';
import 'ticket_type_model.dart';

class Event extends Equatable {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final Category? category;
  final UserModel? organizer;
  final List<TicketType>? tickets;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.category,
    this.organizer,
    this.tickets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      location: json['location'] ?? '',
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      organizer: json['organizer'] != null ? UserModel.fromJson(json['organizer']) : null,
      tickets: json['tickets'] != null
          ? (json['tickets'] as List).map((t) => TicketType.fromJson(t)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'category': category?.toJson(),
      'organizer': organizer?.toJson(),
      'tickets': tickets?.map((t) => t.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, description, date, location, category, organizer, tickets];
}