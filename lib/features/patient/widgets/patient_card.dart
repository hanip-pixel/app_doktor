import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final orders = DummyOrders.getOrdersByPatient(patient.id);
    final pendingRadOrder = orders
        .where((o) => o.status == OrderStatus.pendingRadiology)
        .firstOrNull;
    final readyResultOrder = orders
        .where((o) => o.status == OrderStatus.resultsReady)
        .firstOrNull;

    final accentColor = _accentColor(pendingRadOrder, readyResultOrder);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.28),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GenderAvatar(patient: patient),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              patient.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFF94A3B8),
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM ${patient.mrNumber} • ${patient.age} th (${patient.gender})',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _TimePill(time: patient.scheduleTime),
                          StatusBadge.forPatient(patient),
                          _InsurancePill(label: patient.insurance),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Text(
                        patient.complaint,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      if (pendingRadOrder != null) ...[
                        const SizedBox(height: 10),
                        _ContextBadge(
                          icon: Icons.hourglass_top_rounded,
                          label:
                              'Di Radiologi • ${pendingRadOrder.items.first}',
                          bgColor: const Color(0xFFFAF5FF),
                          borderColor: const Color(0xFFE9D5FF),
                          textColor: const Color(0xFF7E22CE),
                        ),
                      ] else if (readyResultOrder != null) ...[
                        const SizedBox(height: 10),
                        _ContextBadge(
                          icon: Icons.verified_rounded,
                          label: 'Hasil siap • ${readyResultOrder.items.first}',
                          bgColor: const Color(0xFFECFDF5),
                          borderColor: const Color(0xFFA7F3D0),
                          textColor: const Color(0xFF065F46),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _accentColor(
    MedicalOrder? pendingRadOrder,
    MedicalOrder? readyResultOrder,
  ) {
    if (pendingRadOrder != null) return const Color(0xFF9333EA);
    if (readyResultOrder != null) return const Color(0xFF10B981);
    if (patient.status == PatientStatus.waiting) return const Color(0xFFF59E0B);
    if (patient.status == PatientStatus.done) return const Color(0xFF64748B);
    return const Color(0xFF00897B);
  }
}

class _GenderAvatar extends StatelessWidget {
  final Patient patient;

  const _GenderAvatar({required this.patient});

  @override
  Widget build(BuildContext context) {
    final isMale = patient.gender == 'L';
    return CircleAvatar(
      radius: 23,
      backgroundColor: const Color(0xFFE0F2FE),
      child: Icon(
        isMale ? Icons.face_rounded : Icons.face_3_rounded,
        color: const Color(0xFF0284C7),
        size: 27,
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String time;

  const _TimePill({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_rounded,
            size: 13,
            color: Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsurancePill extends StatelessWidget {
  final String label;

  const _InsurancePill({required this.label});

  @override
  Widget build(BuildContext context) {
    final isBpjs = label == 'BPJS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isBpjs ? const Color(0xFFE8F5E9) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: isBpjs ? const Color(0xFF2E7D32) : const Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}

class _ContextBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;

  const _ContextBadge({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
