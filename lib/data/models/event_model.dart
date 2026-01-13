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
  final int totalTickets;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.category,
    this.organizer,
    this.tickets,
    this.totalTickets = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final ticketsList = json['tickets'] != null
        ? (json['tickets'] as List).map((t) => TicketType.fromJson(t)).toList()
        : null;
    
    final totalTickets = ticketsList?.fold<int>(
      0, 
      (sum, ticket) => sum + ticket.quota
    ) ?? 0;
    
    return Event(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      location: json['location'] ?? '',
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      organizer: json['organizer'] != null ? UserModel.fromJson(json['organizer']) : null,
      tickets: ticketsList,
      totalTickets: totalTickets,
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
      'totalTickets': totalTickets,
    };
  }
  
  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    Category? category,
    UserModel? organizer,
    List<TicketType>? tickets,
    int? totalTickets,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      tickets: tickets ?? this.tickets,
      totalTickets: totalTickets ?? this.totalTickets,
    );
  }

  @override
  List<Object?> get props => [id, title, description, date, location, category, organizer, tickets, totalTickets];
}