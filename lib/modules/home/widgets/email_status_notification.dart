import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/data/models/email_status_model.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_bloc.dart';
import 'package:ticketing_flutter/modules/home/bloc/order/order_state.dart';

class EmailStatusNotification extends StatelessWidget {
  const EmailStatusNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderSuccess && state.emailStatus != null) {
          return _buildStatusBanner(context, state.emailStatus!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatusBanner(BuildContext context, EmailStatusUpdate status) {
    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (status.status) {
      case EmailStatus.pending:
        backgroundColor = Colors.orange.shade100;
        icon = Icons.mail_outline;
        iconColor = Colors.orange.shade700;
        break;
      case EmailStatus.sent:
        backgroundColor = Colors.green.shade100;
        icon = Icons.check_circle_outline;
        iconColor = Colors.green.shade700;
        break;
      case EmailStatus.failed:
        backgroundColor = Colors.red.shade100;
        icon = Icons.error_outline;
        iconColor = Colors.red.shade700;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status.statusMessage,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (status.status == EmailStatus.failed && status.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      status.error!,
                      style: TextStyle(
                        color: iconColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (status.status == EmailStatus.pending)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              ),
            ),
        ],
      ),
    );
  }
}
