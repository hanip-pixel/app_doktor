import 'package:flutter/material.dart';
import '../../../data/models/patient.dart';

class PatientHistoryScreen extends StatelessWidget {
  final Patient? patient;

  const PatientHistoryScreen({super.key, this.patient});

  @override
  Widget build(BuildContext context) {
    final historyData = [
      {
        'date': '16 Sep 2026',
        'unit': 'Poli Penyakit Dalam',
        'doctor': 'dr. Andi Pratama, Sp.PD',
        'complaint': patient?.complaint ?? 'Kontrol rutin DM, tidak ada keluhan baru.',
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
      {
        'date': '20 Mei 2026',
        'unit': 'Instalasi Gawat Darurat (IGD)',
        'doctor': 'dr. Budi Santoso, Sp.PD',
        'complaint': 'Pusing berputar disertai mual.',
        'diagnosa': 'H81.1 - Benign Paroxysmal Vertigo',
        'terapi': 'Betahistine 6 mg (3x1), Ondansetron 4 mg',
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
        title: const Text(
          'Riwayat Rekam Medis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final item = historyData[index];
          return _buildHistoryCard(item);
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris 1: Tanggal & Badge Poli
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.event_note_rounded,
                    size: 16,
                    color: Color(0xFF00897B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['date']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['unit']!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00897B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Baris 2: Nama Dokter
          Text(
            item['doctor']!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const Divider(height: 16, thickness: 0.8),

          // Baris 3: Keluhan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 70,
                child: Text(
                  'Keluhan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const Text(': ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Expanded(
                child: Text(
                  item['complaint']!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Baris 4: Diagnosa
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 70,
                child: Text(
                  'Diagnosa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const Text(': ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Expanded(
                child: Text(
                  item['diagnosa']!,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Baris 5: Terapi
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 70,
                child: Text(
                  'Terapi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const Text(': ', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Expanded(
                child: Text(
                  item['terapi']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}