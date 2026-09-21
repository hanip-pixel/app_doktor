import 'package:flutter/material.dart';

import '../../../data/models/billing_item.dart';

class ServiceStandardBadge extends StatelessWidget {
  final ServiceStandard standard;

  const ServiceStandardBadge({super.key, required this.standard});

  @override
  Widget build(BuildContext context) {
    final isKris = standard == ServiceStandard.kris;
    final color = isKris ? const Color(0xFF00897B) : const Color(0xFF7C3AED);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(
        standard.label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
