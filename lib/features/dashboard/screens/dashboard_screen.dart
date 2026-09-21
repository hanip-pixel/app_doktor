import 'package:flutter/material.dart';

import '../../../data/dummy/dummy_notifications.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/medical_order.dart';
import '../../billing/screens/service_history_screen.dart';
import '../../medicine_order/screens/patient_medicine_list_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../../patient/screens/patient_history_screen.dart';
import '../../patient/screens/patient_search_screen.dart';
import '../../radiology_order/screens/radiology_monitoring_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color _primary = Color(0xFF00897B);
  static const Color _primaryDark = Color(0xFF00796B);
  static const Color _ink = Color(0xFF111827);
  static const Color _muted = Color(0xFF64748B);
  static const Color _line = Color(0xFFE5EAF0);

  @override
  Widget build(BuildContext context) {
    final patients = DummyPatients.todayList;
    final orders = DummyOrders.list;
    final pendingOrders = orders
        .where((order) => order.status != OrderStatus.completed)
        .length;
    final readyResults = orders
        .where((order) => order.status == OrderStatus.resultsReady)
        .length;

    return Scaffold(
      backgroundColor: _primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primary, _primaryDark],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 0),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 118),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTodayStats(
                            totalPatients: patients.length,
                            pendingOrders: pendingOrders,
                            readyResults: readyResults,
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Monitoring Layanan',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _buildServiceList(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 22, 20, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor_avatar.jpg',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 48,
                    height: 48,
                    color: Colors.white,
                    child: const Icon(
                      Icons.person_rounded,
                      color: _primary,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'dr. Andi Pratama, Sp.PD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Internis',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _open(context, const NotificationScreen()),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                if (DummyNotifications.unreadCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        DummyNotifications.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStats({
    required int totalPatients,
    required int pendingOrders,
    required int readyResults,
  }) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: _muted, size: 18),
            SizedBox(width: 9),
            Text(
              'Rabu, 16 Sep 2026',
              style: TextStyle(
                color: _muted,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Transform.translate(
          offset: const Offset(0, -4),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  value: '$totalPatients',
                  label: 'Pasien Hari Ini',
                  icon: Icons.groups_rounded,
                  color: _ink,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  value: '$pendingOrders',
                  label: 'Order Pending',
                  icon: Icons.hourglass_top_rounded,
                  color: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  value: '$readyResults',
                  label: 'Hasil Baru',
                  icon: Icons.mark_email_unread_outlined,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.fromLTRB(10, 12, 9, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.80),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color.withValues(alpha: 0.9), size: 17),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: _muted,
              fontSize: 9.8,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(BuildContext context) {
    final items = [
      _DashboardService(
        icon: Icons.person_search_rounded,
        label: 'Cari & Pantau Pasien',
        subtitle: 'Cari data pasien dan pantau tindakan',
        color: const Color(0xFF0891B2),
        onTap: () => _open(context, const PatientSearchScreen()),
      ),
      _DashboardService(
        icon: Icons.biotech_rounded,
        label: 'Monitoring Radiologi',
        subtitle: 'Pantau status dan hasil pemeriksaan',
        color: const Color(0xFF7C3AED),
        onTap: () => _open(context, const RadiologyMonitoringScreen()),
      ),
      _DashboardService(
        icon: Icons.medical_services_rounded,
        label: 'Obat Pasien',
        subtitle: 'Pantau obat yang diberikan ke pasien',
        color: const Color(0xFF2563EB),
        onTap: () => _open(context, const PatientMedicineListScreen()),
      ),
      _DashboardService(
        icon: Icons.receipt_long_rounded,
        label: 'Riwayat Jasa Layanan',
        subtitle: 'Lihat rekap layanan final pasien',
        color: const Color(0xFFF97316),
        onTap: () => _open(context, const ServiceHistoryScreen()),
      ),
      _DashboardService(
        icon: Icons.history_edu_rounded,
        label: 'Riwayat Pasien',
        subtitle: 'Lihat riwayat kunjungan pasien',
        color: const Color(0xFF0D9488),
        onTap: () => _open(context, const PatientHistoryScreen()),
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _buildServiceCard(items[i]),
          if (i != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildServiceCard(_DashboardService item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFCFE),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _line),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.055),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.color.withValues(alpha: 0.92), item.color],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: item.color.withValues(alpha: 0.22),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(item.icon, color: Colors.white, size: 27),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12.2,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: item.color,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _DashboardService {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardService({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
