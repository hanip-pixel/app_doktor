import 'package:flutter/material.dart';
import '../../../data/models/patient.dart';
import '../../../data/dummy/dummy_patients.dart';
import 'patient_detail_screen.dart';

class PatientHistoryScreen extends StatefulWidget {
  final Patient? patient;

  const PatientHistoryScreen({super.key, this.patient});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  String _searchQuery = '';
  String _selectedPeriod = 'Semua';

  @override
  Widget build(BuildContext context) {
    // JIKA DIAKSES DARI HEADER PASIEN TERTENTU
    if (widget.patient != null) {
      return _buildSinglePatientHistory(context, widget.patient!);
    }

    // JIKA DIAKSES DARI MENU BERANDA / DASHBOARD (LOG PASIEN DOKTER)
    return _buildDoctorPatientHistoryList(context);
  }

  // =========================================================================
  // 1. TAMPILAN BERANDA: DAFTAR PASIEN YANG SUDAH PERNAH DIPERIKSA DOKTER
  // =========================================================================
  Widget _buildDoctorPatientHistoryList(BuildContext context) {
    // Data pasien yang sudah pernah diperiksa oleh dokter ini
    final List<Map<String, dynamic>> doctorPatientsHistory = [
      {
        'patient': DummyPatients.todayList[0], // Budi Santoso
        'visitDate': '16 Sep 2026 · 09:15 WIB',
        'diagnosa': 'E11.9 Diabetes Melitus Tipe 2',
        'therapy': 'Metformin 500 mg (2x1), Konsul Gizi',
        'status': 'Selesai Diperiksa',
      },
      {
        'patient': DummyPatients.todayList[5], // Maya Indah
        'visitDate': '16 Sep 2026 · 08:30 WIB',
        'diagnosa': 'K21.9 GERD (Gastroesophageal Reflux)',
        'therapy': 'Omeprazole 20 mg (2x1), Antasida DOEN',
        'status': 'Selesai Diperiksa',
      },
      {
        'patient': DummyPatients.todayList[2], // Hendra Wijaya
        'visitDate': '15 Sep 2026 · 11:00 WIB',
        'diagnosa': 'I10 Hipertensi Primer Derajat II',
        'therapy': 'Amlodipine 10 mg (1x1), Candesartan 8 mg',
        'status': 'Selesai Diperiksa',
      },
      {
        'patient': DummyPatients.todayList[3], // Ratna Sari
        'visitDate': '14 Sep 2026 · 10:20 WIB',
        'diagnosa': 'J45.0 Asma Bronkiale Eksaserbasi Ringan',
        'therapy': 'Salbutamol Inhaler, Cetirizine 10 mg',
        'status': 'Selesai Diperiksa',
      },
      {
        'patient': DummyPatients.todayList[4], // Agus Setiawan
        'visitDate': '12 Sep 2026 · 14:10 WIB',
        'diagnosa': 'M54.5 Low Back Pain (LBP)',
        'therapy': 'Natrium Diklofenak 50 mg, Fisioterapi',
        'status': 'Selesai Diperiksa',
      },
    ];

    // Filter pencarian berdasarkan nama atau No. RM
    final filteredList = doctorPatientsHistory.where((item) {
      final p = item['patient'] as Patient;
      final q = _searchQuery.toLowerCase();
      final matchName = p.name.toLowerCase().contains(q);
      final matchRm = p.mrNumber.toLowerCase().contains(q);
      final matchDiag = (item['diagnosa'] as String).toLowerCase().contains(q);
      return matchName || matchRm || matchDiag;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Pelayanan Pasien',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar & Filter Periode
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              children: [
                // Search Input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(fontSize: 13.5),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                      hintText: 'Cari nama pasien, No. RM, diagnosa...',
                      hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Chip Filter Periode
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'].map((period) {
                      final isSelected = _selectedPeriod == period;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(period),
                          selected: isSelected,
                          onSelected: (val) => setState(() => _selectedPeriod = period),
                          selectedColor: const Color(0xFF00897B),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                          backgroundColor: const Color(0xFFF1F5F9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF00897B) : const Color(0xFFE2E8F0),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Kartu Pasien yang Pernah Diperiksa
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada riwayat pasien ditemukan',
                      style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final p = item['patient'] as Patient;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PatientDetailScreen(patient: p),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Baris 1: Nama, Usia, Badge Asuransi
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        p.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF00897B),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          p.insurance,
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),

                                  // Baris 2: RM & Waktu Kunjungan
                                  Row(
                                    children: [
                                      Text(
                                        'RM ${p.mrNumber} · ${p.age} th · ${p.gender}',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        item['visitDate'],
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16, thickness: 0.8),

                                  // Diagnosa
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF059669)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item['diagnosa'],
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Terapi
                                  Text(
                                    'Terapi: ${item['therapy']}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 2. TAMPILAN DARI HEADER: RIWAYAT REKAM MEDIS 1 PASIEN TERTENTU
  // =========================================================================
  Widget _buildSinglePatientHistory(BuildContext context, Patient p) {
    final historyData = [
      {
        'date': '16 Sep 2026',
        'unit': 'Poli Penyakit Dalam',
        'doctor': 'dr. Andi Pratama, Sp.PD',
        'complaint': p.complaint,
        'diagnosa': 'E11.9 - Diabetes Melitus Tipe 2',
        'terapi': 'Metformin 500 mg (2x1), Edukasi diet',
      },
      {
        'date': '12 Agu 2026',
        'unit': 'Poli Penyakit Dalam',
        'doctor': 'dr. Andi Pratama, Sp.PD',
        'complaint': 'Kontrol gula darah puasa, badan terasa lemas.',
        'diagnosa': 'E11.9 - Diabetes Melitus Tipe 2',
        'terapi': 'Metformin 500 mg (2x1), Cek Lab GDS',
      },
      {
        'date': '05 Jul 2026',
        'unit': 'Poli Penyakit Dalam',
        'doctor': 'dr. Andi Pratama, Sp.PD',
        'complaint': 'Keluhan kesemutan pada jari kaki dan sering haus.',
        'diagnosa': 'E11.9 - Diabetes Melitus Tipe 2',
        'terapi': 'Pemeriksaan Lab GDS + HbA1c, Terapi oral',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat: ${p.name}',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['date']!,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      item['unit']!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF00897B)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item['doctor']!, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                const Divider(height: 14, thickness: 0.8),
                Text('Keluhan: ${item['complaint']}', style: const TextStyle(fontSize: 12.5, color: Color(0xFF1E293B))),
                const SizedBox(height: 3),
                Text('Diagnosa: ${item['diagnosa']}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                const SizedBox(height: 3),
                Text('Terapi: ${item['terapi']}', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
              ],
            ),
          );
        },
      ),
    );
  }
}