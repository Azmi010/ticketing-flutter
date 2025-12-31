class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int price;
  final int categoryId;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.price,
    required this.categoryId,
  });
}