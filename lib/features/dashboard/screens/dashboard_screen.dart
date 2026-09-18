import 'package:flutter/material.dart';
import '../../patient/screens/patient_list_screen.dart';
import '../../patient/screens/patient_search_screen.dart';
import '../../patient/screens/patient_history_screen.dart';
import '../../examination/screens/examination_screen.dart';
import '../../radiology_order/screens/radiology_order_screen.dart';
import '../../medicine_order/screens/medicine_order_screen.dart';
import '../../billing/screens/billing_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../../order_monitoring/screens/order_list_screen.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/dummy/dummy_notifications.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = DummyPatients.todayList.first;

    return Scaffold(
      backgroundColor: const Color(0xFF00897B),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00897B),
              Color(0xFF00796B),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header Section
              _buildHeader(context),
              const SizedBox(height: 12),
              // Main White Body Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Section
                          _buildDateHeader(),
                          const SizedBox(height: 14),

                          // Summary Cards (3 items)
                          _buildSummaryStats(context),
                          const SizedBox(height: 20),

                          // Menu Action Items
                          _buildMenuItem(
                            context,
                            icon: Icons.person_search_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF00BCD4), Color(0xFF009688)],
                            ),
                            title: 'Cari & Pantau Pasien',
                            subtitle: 'Cari data spesifik & pantau tindakan',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PatientSearchScreen(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.monitor_heart_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF818CF8), Color(0xFF5D5FEF)],
                            ),
                            title: 'Pemeriksaan',
                            subtitle: 'Catat hasil pemeriksaan',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ExaminationScreen(patient: patient),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.biotech_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFD946EF), Color(0xFFA855F7)],
                            ),
                            title: 'Order Radiologi',
                            subtitle: 'Buat permintaan radiologi',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RadiologyOrderScreen(patient: patient),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.local_pharmacy_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                            ),
                            title: 'Order Obat',
                            subtitle: 'Resep dan e-resep',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MedicineOrderScreen(patient: patient),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.receipt_long_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFB923C), Color(0xFFF97316)],
                            ),
                            title: 'Billing',
                            subtitle: 'Buat billing pasien',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BillingScreen(patient: patient),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.history_edu_rounded,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF34D399), Color(0xFF059669)],
                            ),
                            title: 'Riwayat Pasien',
                            subtitle: 'Kunjungan & hasil',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PatientHistoryScreen(),
                              ),
                            ),
                          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          // Doctor Avatar with ring
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/doctor_avatar.jpg',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF00897B),
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Doctor Info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'dr. Andi Pratama, Sp.PD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Internis',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Notification Bell with Unread Badge
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationScreen(),
                ),
              );
            },
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
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${DummyNotifications.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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

  Widget _buildDateHeader() {
    return const Row(
      children: [
        Icon(
          Icons.calendar_today_outlined,
          size: 15,
          color: Color(0xFF64748B),
        ),
        SizedBox(width: 8),
        Text(
          'Rabu, 16 Sep 2026',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(BuildContext context) {
    final patientCount = DummyPatients.todayList.length;
    final pendingCount = DummyOrders.pendingCount;
    final resultsCount = DummyOrders.newResultsCount;

    return Row(
      children: [
        _buildStatCard(
          value: '$patientCount',
          label: 'Pasien Hari Ini',
          icon: Icons.people_alt_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PatientListScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          value: '$pendingCount',
          label: 'Order Pending',
          icon: Icons.hourglass_empty_rounded,
          valueColor: const Color(0xFFD97706),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OrderListScreen(initialFilter: 'Pending'),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          value: '$resultsCount',
          label: 'Hasil Baru',
          icon: Icons.mark_email_unread_outlined,
          valueColor: const Color(0xFF059669),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const OrderListScreen(initialFilter: 'Hasil Baru'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required VoidCallback onTap,
    IconData? icon,
    Color? valueColor,
  }) {
    return Expanded(
      child: Material(
        color: const Color(0xFFF1F6FA),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: valueColor ?? const Color(0xFF1E293B),
                        height: 1.1,
                      ),
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        size: 16,
                        color: valueColor ?? const Color(0xFF94A3B8),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Gradient gradient,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE8F1F8),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Squircle Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                // Titles
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
