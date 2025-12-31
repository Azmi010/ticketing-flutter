import '../models/category_model.dart';
import '../models/event_model.dart';

class EventRepository {
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Category(id: 0, name: "All Events"),
      Category(id: 1, name: "Music"),
      Category(id: 2, name: "Art & Design"),
      Category(id: 3, name: "Business"),
      Category(id: 4, name: "Tech"),
    ];
  }

  Future<List<Event>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Event(
        id: 101,
        title: "Neon Lights Festival 2024",
        description: "Grand Park Arena",
        date: DateTime(2024, 10, 12, 20),
        location: "San Francisco, CA",
        price: 45,
        categoryId: 1,
      ),
      Event(
        id: 102,
        title: "Modern Abstract Exhibition",
        description: "SF MOMA",
        date: DateTime(2024, 10, 13, 10),
        location: "San Francisco, CA",
        price: 25,
        categoryId: 2,
      ),
    ];
  }
}