import 'package:equatable/equatable.dart';

class SearchEventResponse extends Equatable {
  final int id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String? categoryName;
  final String? organizerName;

  const SearchEventResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.categoryName,
    this.organizerName,
  });

  factory SearchEventResponse.fromJson(Map<String, dynamic> json) {
    return SearchEventResponse(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      categoryName: json['categoryName'],
      organizerName: json['organizerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'categoryName': categoryName,
      'organizerName': organizerName,
    };
  }

  @override
  List<Object?> get props => [id, title, description, location, date, categoryName, organizerName];
}
