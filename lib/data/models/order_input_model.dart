class OrderInput {
  final int ticketId;
  final int qty;

  OrderInput({
    required this.ticketId,
    required this.qty,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'qty': qty,
    };
  }
}
