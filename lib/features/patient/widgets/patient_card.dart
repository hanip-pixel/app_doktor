import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Cek status order penunjang / radiologi pasien untuk membedakan tahap pemeriksaan
    final orders = DummyOrders.getOrdersByPatient(patient.id);
    final pendingRadOrder = orders
        .where((o) => o.status == OrderStatus.pendingRadiology)
        .firstOrNull;
    final readyResultOrder =
        orders.where((o) => o.status == OrderStatus.resultsReady).firstOrNull;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: pendingRadOrder != null
              ? const Color(0xFFE9D5FF)
              : (readyResultOrder != null
                  ? const Color(0xFFA7F3D0)
                  : const Color(0xFFE8F1F8)),
          width:
              (pendingRadOrder != null || readyResultOrder != null) ? 1.3 : 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Schedule Time
                SizedBox(
                  width: 50,
                  child: Text(
                    patient.scheduleTime,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Center Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM ${patient.mrNumber}  |  ${patient.age} th  |  ${patient.gender}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient.complaint,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      // Penanda Status Tambahan Khusus Tahap Penunjang
                      if (patient.status == PatientStatus.inProgress &&
                          pendingRadOrder != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF5FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: const Color(0xFFE9D5FF), width: 0.9),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.hourglass_top_rounded,
                                  size: 12, color: Color(0xFF9333EA)),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Di Instalasi Radiologi (${pendingRadOrder.items.first})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF7E22CE),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (patient.status == PatientStatus.inProgress &&
                          readyResultOrder != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: const Color(0xFFA7F3D0), width: 0.9),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  size: 12, color: Color(0xFF059669)),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Hasil Rontgen Thorax Siap Dianalisis',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF065F46),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Right Column: Chevron + Smart Contextual Status Badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8),
                      size: 22,
                    ),
                    const SizedBox(height: 18),
                    StatusBadge.forPatient(patient),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
