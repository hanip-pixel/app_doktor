import 'package:flutter/material.dart';
import '../../../core/widgets/patient_header_card.dart';
import '../../../data/models/patient.dart';

class ExaminationScreen extends StatefulWidget {
  final Patient patient;

  const ExaminationScreen({super.key, required this.patient});

  @override
  State<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends State<ExaminationScreen> {
  late List<String> _diagnosaList;
  bool _isListeningAnamnesis = false;
  bool _isListeningFisik = false;

  late TextEditingController _keluhanController;
  late TextEditingController _anamnesisController;
  late TextEditingController _terapiController;

  @override
  void initState() {
    super.initState();
    _diagnosaList = List.from(
      widget.patient.diagnosa.isEmpty
          ? ['E11.9  Diabetes melitus tipe 2']
          : widget.patient.diagnosa,
    );
    _keluhanController = TextEditingController(
      text: widget.patient.keluhanUtama ?? widget.patient.complaint,
    );
    _anamnesisController = TextEditingController(
      text: widget.patient.anamnesis ??
          'Pasien datang untuk kontrol DM. Tidak ada keluhan baru.',
    );
    _terapiController = TextEditingController(
      text: widget.patient.rencanaTerapi ??
          'Kontrol rutin, edukasi diet dan olahraga.',
    );
  }

  @override
  void dispose() {
    _keluhanController.dispose();
    _anamnesisController.dispose();
    _terapiController.dispose();
    super.dispose();
  }

  void _showAddDiagnosaSheet() {
    final commonDiagnoses = [
      'E11.9  Diabetes melitus tipe 2',
      'I10  Hipertensi esensial (primer)',
      'A90  Demam dengue',
      'K21.9  GERD (Gastro-esophageal reflux)',
      'J40  Bronkitis tidak spesifik',
      'I20.9  Angina pektoris',
      'G43.9  Migrain tidak spesifik',
      'R10.4  Nyeri abdomen lainnya',
      'M54.5  Low back pain',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Diagnosa (ICD-10)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: commonDiagnoses.length,
                itemBuilder: (context, index) {
                  final d = commonDiagnoses[index];
                  final isAdded = _diagnosaList.contains(d);
                  return ListTile(
                    dense: true,
                    title: Text(
                      d,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isAdded ? FontWeight.bold : FontWeight.w500,
                        color: isAdded
                            ? const Color(0xFF00897B)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    trailing: isAdded
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF00897B), size: 20)
                        : const Icon(Icons.add_circle_outline,
                            color: Color(0xFF94A3B8), size: 20),
                    onTap: () {
                      if (!isAdded) {
                        setState(() => _diagnosaList.add(d));
                      }
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patient = widget.patient;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0F172A),
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Pemeriksaan Pasien',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Header Card
                    PatientHeaderCard(patient: patient),
                    const SizedBox(height: 16),

                    // Keluhan Utama
                    _sectionTitle('Keluhan Utama'),
                    const SizedBox(height: 6),
                    _inputContainer(
                      child: TextField(
                        controller: _keluhanController,
                        maxLines: null,
                        style: const TextStyle(
                            fontSize: 13.5, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Anamnesis with Mic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionTitle('Anamnesis'),
                        _micButton(
                          isListening: _isListeningAnamnesis,
                          onTap: () {
                            setState(() {
                              _isListeningAnamnesis = !_isListeningAnamnesis;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _inputContainer(
                      child: TextField(
                        controller: _anamnesisController,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 13.5, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pemeriksaan Fisik with Mic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionTitle('Pemeriksaan Fisik'),
                        _micButton(
                          isListening: _isListeningFisik,
                          onTap: () {
                            setState(() {
                              _isListeningFisik = !_isListeningFisik;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _inputContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _vitalRow('TD', patient.tekananDarah ?? '130/80 mmHg'),
                          const SizedBox(height: 4),
                          _vitalRow('Nadi', patient.nadi ?? '78 x/menit'),
                          const SizedBox(height: 4),
                          _vitalRow('RR', patient.laju ?? '20 x/menit'),
                          const SizedBox(height: 4),
                          _vitalRow('Suhu', patient.suhu ?? '36.5 °C'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Diagnosa
                    _sectionTitle('Diagnosa'),
                    const SizedBox(height: 8),
                    Column(
                      children: _diagnosaList.map((diagnosa) {
                        final parts = diagnosa.split('  ');
                        final code = parts.isNotEmpty ? parts[0] : '';
                        final name = parts.length > 1 ? parts[1] : diagnosa;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FBFE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2EEF8)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  code,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _diagnosaList.remove(diagnosa));
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    GestureDetector(
                      onTap: _showAddDiagnosaSheet,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(Icons.add,
                                color: Color(0xFF00897B), size: 18),
                            SizedBox(width: 4),
                            Text(
                              'Tambah Diagnosa',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rencana Terapi
                    _sectionTitle('Rencana Terapi'),
                    const SizedBox(height: 6),
                    _inputContainer(
                      child: TextField(
                        controller: _terapiController,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13.5, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Pemeriksaan pasien berhasil disimpan!'),
                              backgroundColor: Color(0xFF00897B),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Simpan Pemeriksaan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _inputContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE8F1F8),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }

  Widget _micButton({required bool isListening, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isListening
              ? const Color(0xFFFFE4E6)
              : const Color(0xFFE0F2F1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none_rounded,
          size: 18,
          color: isListening
              ? const Color(0xFFE11D48)
              : const Color(0xFF00897B),
        ),
      ),
    );
  }

  Widget _vitalRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
