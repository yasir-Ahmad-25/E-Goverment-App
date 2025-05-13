import 'package:flutter/material.dart';

class CertificateWaitingWidget extends StatelessWidget {
  final String certificateType;

  const CertificateWaitingWidget({super.key, required this.certificateType});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, size: 60, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Waiting for $certificateType Approval',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your $certificateType application is under review. You will be notified once it is approved.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateDeclinedWidget extends StatelessWidget {
  final String certificateType;
  final String reason;
  final VoidCallback onResubmit;

  const CertificateDeclinedWidget({
    super.key,
    required this.certificateType,
    required this.reason,
    required this.onResubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[100],
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '$certificateType Declined',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('Reason: $reason', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text(
              'Please review the reason and resubmit your application.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: onResubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text("Resubmit $certificateType"),
            ),
          ],
        ),
      ),
    );
  }
}