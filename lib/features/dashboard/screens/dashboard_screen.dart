import 'package:flutter/material.dart';

import '../../../data/dummy/dummy_orders.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/medical_order.dart';
import '../../billing/screens/service_history_screen.dart';
import '../../medicine_order/screens/patient_medicine_list_screen.dart';
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

   // 1. Helper Greeting Dinamis Sesuai Jam
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi'; // atau 'Good morning'
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang'; // atau 'Good afternoon'
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore'; // atau 'Good evening'
    } else {
      return 'Selamat Malam'; // atau 'Good night'
    }
  }

  // 2. Helper Format Tanggal Bahasa Indonesia
  String _getFormattedDate() {
    final now = DateTime.now();
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month];
    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  // 3. Header Atas: Greeting & Foto Dokter
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      child: Column(
        children: [
          // Baris Greeting & Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()},',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'dr. Andi Pratama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              // Foto Profil Dokter
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/doctor_avatar.jpg',
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 46,
                      height: 46,
                      color: Colors.white,
                      child: const Icon(
                        Icons.person_rounded,
                        color: _primary,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ============================================================
          // KARTU DOKTER TEAL GELAP (PENGGANTI KARTU VITAMIN D DI GAMBAR)
          // ============================================================
                    // ============================================================
          // KARTU DOKTER: CLEAN WHITE CARD (KONTRAS TINGGI)
          // ============================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Baris Atas: Label & Badge Poli
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981), // Dot hijau aktif
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'DOKTER SPESIALIS',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Poli Internis',
                        style: TextStyle(
                          color: Color(0xFF00897B),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2. Baris Tengah: Nama Lengkap Dokter
                const Text(
                  'dr. Andi Pratama, Sp.PD',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 10),

                // 3. Baris Bawah: Spesialisasi & Nomor SIP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.medical_services_rounded,
                          size: 14,
                          color: Color(0xFF00897B),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Penyakit Dalam',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'SIP. 446.1/1234',
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU PUTIH STATISTIK (PENGGANTI TODAY'S PROGRESS DI GAMBAR)
  // ============================================================
  Widget _buildTodayStats({
    required int totalPatients,
    required int pendingOrders,
    required int readyResults,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: Tanggal Real-Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFormattedDate(),
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Ringkasan Pelayanan Pasien Hari Ini',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: _primary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3 Kotak Statistik (Sesuai Kotak di Gambar)
          Row(
            children: [
              // Kotak 1: Pasien Hari Ini
              Expanded(
                child: _buildMiniStatBox(
                  value: '$totalPatients',
                  label: 'Pasien Hari Ini',
                  accentColor: const Color(0xFF0D9488),
                  bgColor: const Color(0xFFF0FDFA),
                ),
              ),
              const SizedBox(width: 8),

              // Kotak 2: Order Pending
              Expanded(
                child: _buildMiniStatBox(
                  value: '$pendingOrders',
                  label: 'Order Pending',
                  accentColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFFFBEB),
                ),
              ),
              const SizedBox(width: 8),

              // Kotak 3: Hasil Baru
              Expanded(
                child: _buildMiniStatBox(
                  value: '$readyResults',
                  label: 'Hasil Baru',
                  accentColor: const Color(0xFF7C3AED),
                  bgColor: const Color(0xFFF5F3FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk Tiap Kotak dari 3 Kotak Statistik
  Widget _buildMiniStatBox({
    required String value,
    required String label,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: accentColor,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              height: 1.15,
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
