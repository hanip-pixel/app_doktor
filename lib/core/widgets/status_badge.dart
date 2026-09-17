import 'package:flutter/material.dart';
import '../../data/dummy/dummy_orders.dart';
import '../../data/models/medical_order.dart';
import '../../data/models/patient.dart';
import '../theme/app_colors.dart';

enum PatientStatus { waiting, inProgress, done }

class StatusBadge extends StatelessWidget {
  final PatientStatus status;
  final String? customLabel;
  final Color? customBg;
  final Color? customFg;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
    this.customBg,
    this.customFg,
    this.icon,
  });

  factory StatusBadge.forPatient(Patient patient) {
    if (patient.status == PatientStatus.inProgress) {
      final orders = DummyOrders.getOrdersByPatient(patient.id);
      final hasPendingRad =
          orders.any((o) => o.status == OrderStatus.pendingRadiology);
      final hasReadyResults =
          orders.any((o) => o.status == OrderStatus.resultsReady);

      if (hasPendingRad) {
        return const StatusBadge(
          status: PatientStatus.inProgress,
          customLabel: 'Di Radiologi',
          customBg: Color(0xFFF3E8FF),
          customFg: Color(0xFF7E22CE),
          icon: Icons.hourglass_top_rounded,
        );
      } else if (hasReadyResults) {
        return const StatusBadge(
          status: PatientStatus.inProgress,
          customLabel: 'Hasil Siap',
          customBg: Color(0xFFDCFCE7),
          customFg: Color(0xFF15803D),
          icon: Icons.mark_email_read_rounded,
        );
      }
    }

    return StatusBadge(status: patient.status);
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    IconData? badgeIcon = icon;

    if (customLabel != null && customBg != null && customFg != null) {
      bg = customBg!;
      fg = customFg!;
      label = customLabel!;
    } else {
      switch (status) {
        case PatientStatus.waiting:
          bg = const Color(0xFFFEF3C7);
          fg = const Color(0xFFD97706);
          label = 'Menunggu';
          break;
        case PatientStatus.inProgress:
          bg = const Color(0xFFE6FDF4);
          fg = const Color(0xFF059669);
          label = 'Sedang Diperiksa';
          break;
        case PatientStatus.done:
          bg = const Color(0xFFF1F5F9);
          fg = const Color(0xFF64748B);
          label = 'Selesai';
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeIcon != null) ...[
            Icon(badgeIcon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class InsuranceBadge extends StatelessWidget {
  final String label;
  const InsuranceBadge({super.key, this.label = 'BPJS'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bpjsBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.bpjsText,
        ),
      ),
    );
  }
}
