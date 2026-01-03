import '../models/ticket_model.dart';

class TicketRepository {
  Future<List<Ticket>> getTicketsByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allTickets = [
      Ticket(
        id: 1,
        eventTitle: 'Neon Lights Festival 2024',
        eventImage: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800',
        eventDate: DateTime(2024, 10, 12, 20, 0),
        eventLocation: 'Grand Park Arena',
        ticketType: 'General',
        ticketQuantity: 2,
        status: 'confirmed',
      ),
      Ticket(
        id: 2,
        eventTitle: 'Art & Design Expo',
        eventImage: 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800',
        eventDate: DateTime(2024, 11, 5, 10, 0),
        eventLocation: 'City Convention Center',
        ticketType: 'VIP Pass',
        ticketQuantity: 1,
        status: 'soon',
      ),
      Ticket(
        id: 3,
        eventTitle: 'Summer Music Fest',
        eventImage: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
        eventDate: DateTime(2024, 8, 15, 18, 0),
        eventLocation: 'Riverside Park',
        ticketType: 'General Admission',
        ticketQuantity: 3,
        status: 'past',
      ),
      Ticket(
        id: 4,
        eventTitle: 'Tech Conference 2024',
        eventImage: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        eventDate: DateTime(2024, 9, 20, 9, 0),
        eventLocation: 'Tech Hub Center',
        ticketType: 'Standard',
        ticketQuantity: 1,
        status: 'past',
      ),
      Ticket(
        id: 5,
        eventTitle: 'Food Festival',
        eventImage: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800',
        eventDate: DateTime(2024, 10, 25, 12, 0),
        eventLocation: 'Downtown Square',
        ticketType: 'General',
        ticketQuantity: 2,
        status: 'canceled',
      ),
    ];

    if (status == 'upcoming') {
      return allTickets.where((ticket) => 
        ticket.status == 'confirmed' || ticket.status == 'soon'
      ).toList();
    } else if (status == 'past') {
      return allTickets.where((ticket) => ticket.status == 'past').toList();
    } else if (status == 'canceled') {
      return allTickets.where((ticket) => ticket.status == 'canceled').toList();
    }
    
    return allTickets;
  }
}
