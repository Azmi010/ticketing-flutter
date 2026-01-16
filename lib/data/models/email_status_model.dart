import 'package:equatable/equatable.dart';

enum EmailStatus { pending, sent, failed }

class EmailStatusUpdate extends Equatable {
  final int emailLogId;
  final int orderId;
  final EmailStatus status;
  final String? error;
  final DateTime updatedAt;

  const EmailStatusUpdate({
    required this.emailLogId,
    required this.orderId,
    required this.status,
    this.error,
    required this.updatedAt,
  });

  factory EmailStatusUpdate.fromJson(Map<String, dynamic> json) {
    return EmailStatusUpdate(
      emailLogId: json['emailLogId'] is int
          ? json['emailLogId']
          : int.parse(json['emailLogId'].toString()),
      orderId: json['orderId'] is int
          ? json['orderId']
          : int.parse(json['orderId'].toString()),
      status: _parseStatus(json['status']),
      error: json['error'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  static EmailStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return EmailStatus.pending;
      case 'SENT':
        return EmailStatus.sent;
      case 'FAILED':
        return EmailStatus.failed;
      default:
        return EmailStatus.pending;
    }
  }

  String get statusMessage {
    switch (status) {
      case EmailStatus.pending:
        return 'Email sedang dikirim...';
      case EmailStatus.sent:
        return 'Email sudah dikirim';
      case EmailStatus.failed:
        return 'Email gagal dikirim';
    }
  }

  @override
  List<Object?> get props => [emailLogId, orderId, status, error, updatedAt];
}
