import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum PatientStatus { waiting, inProgress, done }

class StatusBadge extends StatelessWidget {
  final PatientStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
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
