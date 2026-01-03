class Ticket {
  final int id;
  final String eventTitle;
  final String eventImage;
  final DateTime eventDate;
  final String eventLocation;
  final String ticketType;
  final int ticketQuantity;
  final String status; // 'confirmed', 'soon', 'past', 'canceled'

  Ticket({
    required this.id,
    required this.eventTitle,
    required this.eventImage,
    required this.eventDate,
    required this.eventLocation,
    required this.ticketType,
    required this.ticketQuantity,
    required this.status,
  });

  // Helper to format date and time
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = eventDate.hour > 12 ? eventDate.hour - 12 : eventDate.hour;
    final period = eventDate.hour >= 12 ? 'PM' : 'AM';
    return '${months[eventDate.month - 1]} ${eventDate.day.toString().padLeft(2, '0')} • ${hour.toString().padLeft(2, '0')}:${eventDate.minute.toString().padLeft(2, '0')} $period';
  }

  String get ticketInfo {
    return '$ticketQuantity $ticketType';
  }
}
