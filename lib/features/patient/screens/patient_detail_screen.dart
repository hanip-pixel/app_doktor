import 'package:flutter/material.dart';
import '../../../core/widgets/patient_header_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/models/patient.dart';
import '../../radiology_order/screens/radiology_order_screen.dart';
import '../../medicine_order/screens/medicine_order_screen.dart';
import '../../billing/screens/billing_screen.dart';
import '../../examination/screens/examination_screen.dart';
import '../../examination/widgets/examination_flow_view.dart';
import '../../lab_order/screens/lab_order_screen.dart';
import '../../surgery_order/screens/surgery_order_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;
  final int initialTabIndex;

  const PatientDetailScreen({
    super.key,
    required this.patient,
    this.initialTabIndex = 0,
  });

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Patient _patient;
  late List<String> _diagnosaList;
  bool _isListeningAnamnesis = false;
  bool _isListeningFisik = false;
  bool _isEditingDraft = false;

  late TextEditingController _keluhanController;
  late TextEditingController _anamnesisController;
  late TextEditingController _terapiController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 3),
    );
    _patient = widget.patient;
    _diagnosaList = List.from(
      _patient.diagnosa.isEmpty
          ? ['R69  Pemeriksaan klinis']
          : _patient.diagnosa,
    );
    _keluhanController = TextEditingController(
      text: _patient.keluhanUtama ?? _patient.complaint,
    );
    _anamnesisController = TextEditingController(
      text: _patient.anamnesis ??
          _patient.cpptData?.asesmen ??
          'Anamnesis terverifikasi: ${_patient.complaint}',
    );
    _terapiController = TextEditingController(
      text: _patient.rencanaTerapi ??
          _patient.cpptData?.plan ??
          'Terapi simptomatik dan edukasi pasien.',
    );
  }

  void _enableEditDraft() {
    setState(() {
      _isEditingDraft = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mode Edit Draft Aktif. Anda sekarang dapat mengubah data rekam medis.'),
        backgroundColor: Color(0xFF00897B),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveDraft() {
    setState(() {
      _isEditingDraft = false;
      _patient = _patient.copyWith(
        keluhanUtama: _keluhanController.text,
        anamnesis: _anamnesisController.text,
        diagnosa: _diagnosaList,
        rencanaTerapi: _terapiController.text,
      );
    });
    _updatePatientInDummyList(_patient);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft pemeriksaan berhasil disimpan sementara (belum difinalisasi).'),
        backgroundColor: Color(0xFF0284C7),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _confirmResetDraft() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Reset Draft Pemeriksaan?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Semua perubahan draft pemeriksaan, keluhan, anamnesis, dan diagnosa akan dikembalikan ke data awal. Yakin ingin mereset?',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _keluhanController.text = _patient.complaint;
                _anamnesisController.text = 'Pasien datang untuk kontrol rutin. Tidak ada keluhan sesak atau nyeri dada baru.';
                _terapiController.text = 'Kontrol rutin, edukasi diet dan olahraga teratur.';
                _diagnosaList = ['E11.9  Diabetes melitus tipe 2'];
                _isEditingDraft = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Draft pemeriksaan berhasil di-reset ke data awal.'),
                  backgroundColor: Color(0xFFEF4444),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Reset Draft'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keluhanController.dispose();
    _anamnesisController.dispose();
    _terapiController.dispose();
    super.dispose();
  }

  void _updatePatientInDummyList(Patient updated) {
    final index =
        DummyPatients.todayList.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      DummyPatients.todayList[index] = updated;
    }
  }

  void _showLoadingDialog(String title, String subtitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Row(
            children: [
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF00897B),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _panggilPasien() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.campaign_rounded, color: Color(0xFF00897B), size: 28),
            SizedBox(width: 8),
            Text(
              'Panggil Pasien',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Text(
          'Memanggil pasien "${_patient.name}" ke Ruang Periksa Dokter 1?',
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              _showLoadingDialog(
                'Memanggil Pasien...',
                'Sinkronisasi display antrean poli...',
              );
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) {
                Navigator.pop(context);
                final updatedPatient = _patient.copyWith(
                  status: PatientStatus.inProgress,
                );
                setState(() {
                  _patient = updatedPatient;
                });
                _updatePatientInDummyList(updatedPatient);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pasien ${_patient.name} berhasil dipanggil ke ruang periksa!',
                    ),
                    backgroundColor: const Color(0xFF00897B),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Langsung buka formulir pemeriksaan 3-step
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExaminationScreen(patient: updatedPatient),
                  ),
                ).then((_) {
                  final latest = DummyPatients.todayList.firstWhere(
                    (p) => p.id == _patient.id,
                    orElse: () => _patient,
                  );
                  if (mounted) {
                    setState(() {
                      _patient = latest;
                    });
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Panggil & Mulai'),
          ),
        ],
      ),
    );
  }

  void _selesaikanPemeriksaan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Color(0xFF00897B), size: 28),
            SizedBox(width: 8),
            Text(
              'Selesaikan Pemeriksaan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: const Text(
          'Simpan seluruh hasil rekam medis dan selesaikan pemeriksaan pasien ini? Pasien akan dialihkan ke bagian Farmasi & Billing.',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              _showLoadingDialog(
                'Menyimpan Rekam Medis...',
                'Menerapkan TTE & Sinkronisasi SIMRS...',
              );
              await Future.delayed(const Duration(milliseconds: 800));
              if (mounted) {
                Navigator.pop(context);
                setState(() {
                  _patient = _patient.copyWith(
                    status: PatientStatus.done,
                    keluhanUtama: _keluhanController.text,
                    anamnesis: _anamnesisController.text,
                    rencanaTerapi: _terapiController.text,
                    diagnosa: _diagnosaList,
                  );
                });
                _updatePatientInDummyList(_patient);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Pemeriksaan medis berhasil diselesaikan & terkunci.',
                    ),
                    backgroundColor: Color(0xFF00897B),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
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
                    'Detail Pasien',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Current Live Status Badge
                  StatusBadge.forPatient(_patient),
                ],
              ),
            ),

            // Patient Banner Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PatientHeaderCard(patient: _patient),
            ),
            const SizedBox(height: 10),

            // Conditional Content based on Patient Status:
            // Pasien Menunggu dan Pasien Selesai tidak memiliki akses ke Order, Riwayat, & Billing.
            // TabBar hanya ditampilkan saat pasien Sedang Diperiksa (inProgress).
                       if (_patient.status == PatientStatus.inProgress) ...[
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF00897B),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF00897B),
                indicatorWeight: 2.5,
                labelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Pemeriksaan'),
                  Tab(text: 'Order'),
                  Tab(text: 'Billing'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildInProgressState(),
                    _buildOrderTab(),
                    _buildBillingTab(),
                  ],
                ),
              ),
            ] else if (_patient.status == PatientStatus.waiting) ...[
              Expanded(
                child: _buildWaitingState(),
              ),
            ] else ...[
              Expanded(
                child: _buildDoneState(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAMPILAN 1: STATUS MENUNGGU
  // ==========================================
  Widget _buildWaitingState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Menunggu
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  color: Color(0xFFD97706),
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pasien di Ruang Tunggu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Pasien sedang menunggu giliran. Silakan klik tombol "Panggil Pasien" di bawah untuk memanggil pasien dan membuka form rekam medis.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFFB45309),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Info Awal dari Triase / Perawat
          _sectionTitle('Keluhan Awal Pasien'),
          const SizedBox(height: 6),
          _inputContainer(
            child: Text(
              _patient.complaint,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _sectionTitle('Tanda Vital Awal (Triase Perawat)'),
          const SizedBox(height: 6),
          _inputContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _vitalRow('TD', _patient.tekananDarah ?? '120/80 mmHg'),
                const SizedBox(height: 4),
                _vitalRow('Nadi', _patient.nadi ?? '80 x/menit'),
                const SizedBox(height: 4),
                _vitalRow('RR', _patient.laju ?? '18 x/menit'),
                const SizedBox(height: 4),
                _vitalRow('Suhu', _patient.suhu ?? '36.8 °C'),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Panggil Pasien
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _panggilPasien,
              icon: const Icon(Icons.campaign_rounded, size: 22),
              label: const Text(
                'Panggil Pasien & Mulai Periksa',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAMPILAN 2: STATUS SEDANG DIPERIKSA (FORM AKTIF)
  // ==========================================
  Widget _buildInProgressState() {
    return ExaminationFlowView(
      patient: _patient,
      onSaved: (updated) {
        setState(() {
          _patient = updated;
        });
        _updatePatientInDummyList(updated);
      },
    );
  }

  // ignore: unused_element
  Widget _buildLegacyInProgressState() {
    final patientOrders = DummyOrders.getOrdersByPatient(_patient.id);
    final penunjangResults = patientOrders
        .where((o) =>
            o.resultSummary != null || o.status == OrderStatus.resultsReady)
        .toList();
    final pendingRadOrders = patientOrders
        .where((o) => o.status == OrderStatus.pendingRadiology)
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Cepat: Buka Formulir Pemeriksaan 3-Step Alur Baru
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF00695C)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00897B).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Formulir Pemeriksaan (3-Step)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '1. Layanan  •  2. Isi Form  •  3. Validasi',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExaminationScreen(patient: _patient),
                      ),
                    ).then((_) {
                      final updated = DummyPatients.todayList.firstWhere(
                        (p) => p.id == _patient.id,
                        orElse: () => _patient,
                      );
                      if (mounted) {
                        setState(() {
                          _patient = updated;
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00897B),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: const Size(0, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Buka Form',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Banner Status Draft / Mode Edit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _isEditingDraft
                  ? const Color(0xFFE6FDF4)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isEditingDraft
                    ? const Color(0xFFA7F3D0)
                    : const Color(0xFFFDE68A),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _isEditingDraft
                      ? Icons.edit_note_rounded
                      : Icons.lock_clock_rounded,
                  color: _isEditingDraft
                      ? const Color(0xFF059669)
                      : const Color(0xFFD97706),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditingDraft
                            ? 'Mode Edit Draft Aktif'
                            : 'Draft Pemeriksaan (Mode Tinjau / Terkunci)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _isEditingDraft
                              ? const Color(0xFF065F46)
                              : const Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEditingDraft
                            ? 'Silakan isi/perbarui keluhan, anamnesis, diagnosa, dan terapi.'
                            : 'Form terkunci otomatis untuk meminimalisir salah input. Klik "Edit Draft" untuk mengubah data.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _isEditingDraft
                              ? const Color(0xFF047857)
                              : const Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Keluhan Utama
          _sectionTitle('Keluhan Utama'),
          const SizedBox(height: 6),
          _inputContainer(
            child: TextField(
              controller: _keluhanController,
              readOnly: !_isEditingDraft,
              maxLines: null,
              style: TextStyle(
                fontSize: 13.5,
                color: _isEditingDraft
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF475569),
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: _isEditingDraft ? 'Ketik keluhan utama pasien...' : null,
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
                onTap: _isEditingDraft
                    ? () {
                        setState(() {
                          _isListeningAnamnesis = !_isListeningAnamnesis;
                        });
                        if (_isListeningAnamnesis) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mendengarkan rekaman suara dokter...'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF00897B),
                            ),
                          );
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aktifkan tombol "Edit Draft" terlebih dahulu untuk merekam suara.',
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF475569),
                          ),
                        );
                      },
              ),
            ],
          ),
          const SizedBox(height: 6),
          _inputContainer(
            child: TextField(
              controller: _anamnesisController,
              readOnly: !_isEditingDraft,
              maxLines: 3,
              style: TextStyle(
                fontSize: 13.5,
                color: _isEditingDraft
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF475569),
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: _isEditingDraft ? 'Ketik atau rekam suara anamnesis...' : null,
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
                onTap: _isEditingDraft
                    ? () {
                        setState(() {
                          _isListeningFisik = !_isListeningFisik;
                        });
                        if (_isListeningFisik) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Merekam catatan suara pemeriksaan fisik...'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF00897B),
                            ),
                          );
                        }
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aktifkan tombol "Edit Draft" terlebih dahulu untuk merekam suara.',
                            ),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF475569),
                          ),
                        );
                      },
              ),
            ],
          ),
          const SizedBox(height: 6),
          _inputContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _vitalRow('TD', _patient.tekananDarah ?? '130/80 mmHg'),
                const SizedBox(height: 4),
                _vitalRow('Nadi', _patient.nadi ?? '78 x/menit'),
                const SizedBox(height: 4),
                _vitalRow('RR', _patient.laju ?? '20 x/menit'),
                const SizedBox(height: 4),
                _vitalRow('Suhu', _patient.suhu ?? '36.5 °C'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Status Order Penunjang Sedang Diproses di Instalasi Radiologi
          if (pendingRadOrders.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF5FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9D5FF)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      color: Color(0xFF9333EA),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pasien Sedang di Instalasi Radiologi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7E22CE),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Permintaan: ${pendingRadOrders.first.items.join(", ")}. Menunggu hasil pemeriksaan & ekspertise.',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6B21A8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Hasil Pemeriksaan Penunjang (Radiologi & Lab)
          if (penunjangResults.isNotEmpty) ...[
            _buildPenunjangResultsSection(penunjangResults),
            const SizedBox(height: 16),
          ],

          // Diagnosa (ICD-10 chips)
          _sectionTitle('Diagnosa (ICD-10)'),
          const SizedBox(height: 8),
          Column(
            children: _diagnosaList.map((diagnosa) {
              final parts = diagnosa.split('  ');
              final code = parts.isNotEmpty ? parts[0] : '';
              final name = parts.length > 1 ? parts[1] : diagnosa;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    if (_isEditingDraft)
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
          if (_isEditingDraft)
            GestureDetector(
              onTap: _showAddDiagnosaSheet,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Color(0xFF00897B), size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Tambah Diagnosa ICD-10',
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
          _sectionTitle('Rencana Terapi & Tindakan'),
          const SizedBox(height: 6),
          _inputContainer(
            child: TextField(
              controller: _terapiController,
              readOnly: !_isEditingDraft,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13.5,
                color: _isEditingDraft
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF475569),
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: _isEditingDraft ? 'Ketik rencana terapi atau obat...' : null,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ACTION BUTTONS SESUAI WORKFLOW DRAFT -> EDIT -> RESET -> SAVE -> FINALIZE
          if (!_isEditingDraft) ...[
            // Baris Tombol Aksi Draft (Edit & Reset)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _enableEditDraft,
                      icon: const Icon(Icons.edit_note_rounded, size: 20),
                      label: const Text(
                        'Edit Draft',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _confirmResetDraft,
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: const Text(
                        'Reset Draft',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tombol Finalisasi Pemeriksaan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _selesaikanPemeriksaan,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: const Text(
                  'Finalisasi & Selesaikan Pemeriksaan',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ] else ...[
            // Mode Edit Sedang Aktif: Tombol Simpan Draft & Batal
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _saveDraft,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text(
                        'Simpan Draft',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _isEditingDraft = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mode edit ditutup.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text(
                        'Tutup Edit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Selesaikan Langsung dari Mode Edit
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _saveDraft();
                  _selesaikanPemeriksaan();
                },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: const Text(
                  'Simpan & Finalisasi Pemeriksaan',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // TAMPILAN RESUME MEDIS SELESAI (DONE STATE)
  // ==========================================
  Widget _buildDoneState() {
    final penunjangResults = DummyOrders.getOrdersByPatient(_patient.id)
        .where((o) =>
            o.resultSummary != null ||
            o.status == OrderStatus.resultsReady ||
            o.status == OrderStatus.completed)
        .toList();

    final cppt = _patient.cpptData;
    final ttv = _patient.ttvData;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Selesai
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemeriksaan Medis Selesai & Terkunci',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Rekam Medis Elektronik (RME) telah tersimpan dan tervalidasi oleh DPJP.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // TANDA-TANDA VITAL (TTV)
          _sectionTitle('Tanda-Tanda Vital (TTV)'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _doneVitalCard(
                        'Tekanan Darah',
                        ttv?.tekananDarah ??
                            _patient.tekananDarah ??
                            '120/80 mmHg',
                        Icons.speed_rounded,
                        const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _doneVitalCard(
                        'Denyut Nadi',
                        ttv != null
                            ? '${ttv.nadi} x/mnt'
                            : (_patient.nadi ?? '80 x/mnt'),
                        Icons.favorite_rounded,
                        const Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _doneVitalCard(
                        'Laju Nafas',
                        ttv != null
                            ? '${ttv.lajuNafas} x/mnt'
                            : (_patient.laju ?? '18 x/mnt'),
                        Icons.air_rounded,
                        const Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _doneVitalCard(
                        'Suhu Tubuh',
                        ttv != null
                            ? '${ttv.suhu} °C'
                            : (_patient.suhu ?? '36.5 °C'),
                        Icons.thermostat_rounded,
                        const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
                if (ttv != null &&
                    (ttv.spo2.isNotEmpty || ttv.beratBadan.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _doneVitalCard(
                          'Saturasi SpO2',
                          '${ttv.spo2} %',
                          Icons.water_drop_rounded,
                          const Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _doneVitalCard(
                          'BB / TB (IMT)',
                          '${ttv.beratBadan}kg / ${ttv.tinggiBadan}cm (${ttv.imtCategory})',
                          Icons.monitor_weight_rounded,
                          const Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // CATATAN PERKEMBANGAN PASIEN TERINTEGRASI (CPPT - SOAP)
          _sectionTitle('Catatan Perkembangan Pasien (CPPT - SOAP)'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _soapBlock(
                    'S',
                    'Subjektif / Keluhan',
                    cppt?.subjektif.isNotEmpty == true
                        ? cppt!.subjektif
                        : (_patient.keluhanUtama ?? _patient.complaint),
                    const Color(0xFF00897B)),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _soapBlock(
                    'O',
                    'Objektif / Fisik & Penunjang',
                    cppt?.objektif.isNotEmpty == true
                        ? cppt!.objektif
                        : (_patient.pemeriksaanFisik ??
                            'Pemeriksaan fisik dalam batas normal.'),
                    const Color(0xFF2563EB)),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _soapBlock(
                    'A',
                    'Asesmen / Analisis Klinis',
                    cppt?.asesmen.isNotEmpty == true
                        ? cppt!.asesmen
                        : (_patient.anamnesis ??
                            'Kondisi klinis terkompensasi baik.'),
                    const Color(0xFFD97706)),
                const Divider(height: 16, color: Color(0xFFF1F5F9)),
                _soapBlock(
                    'P',
                    'Plan / Rencana Terapi & Tindak Lanjut',
                    cppt?.plan.isNotEmpty == true
                        ? cppt!.plan
                        : (_patient.rencanaTerapi ??
                            'Lanjutkan terapi dan edukasi.'),
                    const Color(0xFF7C3AED)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // HASIL PEMERIKSAAN PENUNJANG (RADIOLOGI & LAB)
          if (penunjangResults.isNotEmpty) ...[
            _buildPenunjangResultsSection(penunjangResults),
            const SizedBox(height: 16),
          ],

          // DIAGNOSA ICD-10 & TINDAKAN ICD-9-CM
          _sectionTitle('Diagnosa & Tindakan Medis'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diagnosa Utama & Sekunder (ICD-10):',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 6),
                Column(
                  children: _patient.diagnosa.map((d) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF16A34A), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              d,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                if (_patient.tindakan.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Tindakan Medis / Prosedur (ICD-9-CM):',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Column(
                    children: _patient.tindakan.map((t) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.medical_services_rounded,
                                color: Color(0xFF2563EB), size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // RENCANA TERAPI, RESEP & EDUKASI
          _sectionTitle('Rencana Terapi, Resep & Edukasi'),
          const SizedBox(height: 8),
          Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medication_rounded,
                        color: Color(0xFF00897B), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Instruksi Obat & Resep:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _patient.rencanaTerapi ?? _terapiController.text,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_patient.diagnosaTindakanData?.catatanEdukasi.isNotEmpty ==
                    true) ...[
                  const Divider(height: 16, color: Color(0xFFF1F5F9)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.school_rounded,
                          color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Edukasi Pasien:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _patient.diagnosaTindakanData!.catatanEdukasi,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Cetak / Lihat Resume
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                _showResumeDialog();
              },
              icon: const Icon(Icons.print_rounded, size: 20),
              label: const Text(
                'Lihat / Cetak Resume Medis',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00897B),
                side: const BorderSide(color: Color(0xFF00897B), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _doneVitalCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _soapBlock(
      String letter, String title, String content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF334155),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  void _showResumeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Dialog (PDF Bar)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF00897B),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pratinjau Dokumen PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Format Standar Resume Medis Elektronik (RME)',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),

              // Dokumen Lembar Resume Medis PDF
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kop Surat Rumah Sakit
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFFE0F2F1)),
                              ),
                              child: Image.asset(
                                'assets/images/logo_rs.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.local_hospital_rounded,
                                        color: Color(0xFF00897B), size: 28),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RSUD DR. H. ABDUL MOELOEK',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Provinsi Lampung · SIMRS Cloud',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1.5, height: 20),

                        // Judul Dokumen Resmi
                        const Center(
                          child: Text(
                            'RESUME MEDIS RAWAT JALAN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'No. Dokumen: RM-RJ/2026/09/${_patient.mrNumber}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Identitas Pasien
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _pdfRow('Nama Pasien', _patient.name),
                              _pdfRow('No. Rekam Medis', _patient.mrNumber),
                              _pdfRow('Usia / Jenis Kelamin',
                                  '${_patient.age} Tahun / ${_patient.gender == 'L' ? 'Laki-Laki' : 'Perempuan'}'),
                              _pdfRow('Penjamin / Asuransi',
                                  _patient.insurance),
                              if (_patient.noSep != null)
                                _pdfRow('No. SEP BPJS', _patient.noSep!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Anamnesis & Keluhan
                        const Text(
                          'A. ANAMNESIS & KELUHAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _keluhanController.text.isNotEmpty
                              ? _keluhanController.text
                              : _patient.complaint,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 10),

                        // Tanda Vital
                        const Text(
                          'B. TANDA-TANDA VITAL (TRIASE)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TD: ${_patient.tekananDarah ?? '130/80 mmHg'}   |   Nadi: ${_patient.nadi ?? '78 x/m'}   |   RR: ${_patient.laju ?? '20 x/m'}   |   Suhu: ${_patient.suhu ?? '36.5 °C'}',
                          style: const TextStyle(
                              fontSize: 11.5, color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 10),

                        // Diagnosa ICD-10
                        const Text(
                          'C. DIAGNOSA KLINIS (ICD-10)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _diagnosaList.join('\n'),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),

                        // Terapi / Edukasi
                        const Text(
                          'D. RENCANA TERAPI & EDUKASI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _terapiController.text,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 16),

                        // Tanda Tangan Elektronik Dokter (TTE)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tervalidasi Digital:',
                                  style: TextStyle(
                                      fontSize: 10, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  'Sistem RME RSUDAM',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00897B),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFCBD5E1)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.qr_code_2_rounded,
                                      size: 40, color: Color(0xFF1E293B)),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'dr. Andi Pratama, Sp.PD',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const Text(
                                  'SIP: 446/1234/SIP.D/2024',
                                  style: TextStyle(
                                      fontSize: 10, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Actions (Print / Download PDF)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '📥 Dokumen PDF Resume Medis berhasil diunduh ke memori perangkat.'),
                              backgroundColor: Color(0xFF00897B),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: const Text('Unduh PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00897B),
                          side: const BorderSide(color: Color(0xFF00897B)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '🖨️ Mengirim dokumen PDF Resume Medis ke printer poli...'),
                              backgroundColor: Color(0xFF00897B),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.print_rounded, size: 18),
                        label: const Text('Cetak Dokumen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pdfRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
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
          color: isListening ? const Color(0xFFFFE4E6) : const Color(0xFFE0F2F1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none_rounded,
          size: 18,
          color: isListening ? const Color(0xFFE11D48) : const Color(0xFF00897B),
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

   Widget _buildOrderTab() {
    final patientOrders = DummyOrders.getOrdersByPatient(_patient.id);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // Baris 1: Order Radiologi & Order Lab
        Row(
          children: [
            Expanded(
              child: _quickOrderActionCard(
                icon: Icons.biotech_rounded,
                title: 'Order Radiologi',
                subtitle: '+ Rontgen / USG',
                gradient: const LinearGradient(
                  colors: [Color(0xFFD946EF), Color(0xFFA855F7)],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RadiologyOrderScreen(patient: _patient),
                    ),
                  );
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickOrderActionCard(
                icon: Icons.science_rounded,
                title: 'Order Lab',
                subtitle: '+ Darah / Urin',
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LabOrderScreen(patient: _patient),
                    ),
                  );
                  if (mounted) setState(() {});
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Baris 2: Order Obat & Order OK (Operasi)
        Row(
          children: [
            Expanded(
              child: _quickOrderActionCard(
                icon: Icons.medication_rounded,
                title: 'Order Obat',
                subtitle: '+ E-Resep Baru',
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MedicineOrderScreen(patient: _patient),
                    ),
                  );
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickOrderActionCard(
                icon: Icons.local_hospital_rounded,
                title: 'Order OK',
                subtitle: '+ Jadwal Bedah',
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurgeryOrderScreen(patient: _patient),
                    ),
                  );
                  if (mounted) setState(() {});
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Daftar Order Pasien Ini (Sama seperti sebelumnya)...

        // Section: Order Aktif Pasien Ini
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Pasien (${patientOrders.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            if (patientOrders.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Terkoneksi SIMRS',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00897B),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (patientOrders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2EEF8)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF00897B),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Belum ada order untuk pasien ini',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Klik tombol di atas untuk mengirim permintaan Radiologi atau Resep Obat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          )
        else
                    ...patientOrders.map((order) {
            final isRad = order.type == OrderType.radiology;
            final isMed = order.type == OrderType.medicine;
            final isLab = order.type == OrderType.lab;
            final isSurgery = order.type == OrderType.surgery;

            final badgeColor = isRad
                ? const Color(0xFF9333EA)
                : isMed
                    ? const Color(0xFF0284C7)
                    : isLab
                        ? const Color(0xFF059669)
                        : isSurgery
                            ? const Color(0xFFE11D48)
                            : const Color(0xFFEA580C);

            final badgeBg = isRad
                ? const Color(0xFFF3E8FF)
                : isMed
                    ? const Color(0xFFE0F2FE)
                    : isLab
                        ? const Color(0xFFD1FAE5)
                        : isSurgery
                            ? const Color(0xFFFFE4E6)
                            : const Color(0xFFFFEDD5);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order.typeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: badgeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      Text(
                        order.orderTime.split(' ').first,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order.items.map((it) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Color(0xFF00897B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                it,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (order.resultSummary != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Text(
                        order.resultSummary!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF065F46),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: order.status == OrderStatus.resultsReady
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Status: ${order.statusLabel}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: order.status == OrderStatus.resultsReady
                            ? const Color(0xFF059669)
                            : const Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _quickOrderActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F1F8), width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00897B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillingTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F6FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 40,
                color: Color(0xFF00897B),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Rincian Tagihan Pasien',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Lihat dan kelola seluruh billing tindakan, konsultasi, penunjang, dan resep obat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BillingScreen(patient: _patient),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Buka Billing',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPenunjangResultsSection(List<MedicalOrder> results) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.biotech_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Penunjang Terbaru',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    Text(
                      'Telah diverifikasi oleh Dokter Spesialis Penunjang',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: Color(0xFF16A34A), size: 13),
                    const SizedBox(width: 4),
                    Text(
                      '${results.length} Tersedia',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...results.map((res) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD1FAE5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          res.typeLabel,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9333EA),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          res.items.join(', '),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        res.orderNumber,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.psychology_alt_rounded,
                              size: 14,
                              color: Color(0xFF059669),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Bacaan Dokter: ${res.doctorName ?? "Spesialis Radiologi"}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          res.resultSummary ??
                              'Hasil pemeriksaan telah selesai diverifikasi.',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showXrayModal(res),
                          icon:
                              const Icon(Icons.image_search_rounded, size: 16),
                          label: const Text(
                            'Lihat Citra Rontgen',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00897B),
                            side: const BorderSide(color: Color(0xFF00897B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                          ),
                        ),
                      ),
                      if (_isEditingDraft &&
                          !_diagnosaList.any((d) =>
                              d.contains('Kardiomegali') || d.contains('I20'))) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _diagnosaList
                                  .add('I20.9  Angina pektoris / Kardiomegali');
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Diagnosa disesuaikan berdasarkan hasil rontgen.',
                                ),
                                backgroundColor: Color(0xFF00897B),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_task_rounded, size: 15),
                          label: const Text(
                            '+ Diagnosa',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 10,
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showXrayModal(MedicalOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
                child: Row(
                  children: [
                    const Icon(Icons.biotech_rounded,
                        color: Color(0xFF34D399), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Citra Radiologi: ${order.items.first}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${order.orderNumber} • ${order.patient.name}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF334155)),

              // Interactive Image Box
              Container(
                margin: const EdgeInsets.all(12),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Grid lines
                    Opacity(
                      opacity: 0.15,
                      child: GridPaper(
                        color: Colors.tealAccent,
                        interval: 40,
                        divisions: 2,
                        subdivisions: 1,
                        child: Container(),
                      ),
                    ),
                    // Simulated anatomical thoracic X-ray graphic
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.medical_services_outlined,
                          size: 70,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF475569)),
                          ),
                          child: const Text(
                            'THORAX AP/PA ERECT • PACS VIEWER',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Scale metrics overlay
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        color: Colors.black54,
                        child: const Text(
                          'CTR: 54% (Kardiomegali) | KV: 120 | mAs: 4.0',
                          style: TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expertise Details
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified_user_rounded,
                              color: Color(0xFF34D399), size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Ekspertise Radiologi Terverifikasi',
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        order.resultSummary ??
                            'Cor membesar CTR > 50%. Pulmo bersih tanpa infiltrat aktif.',
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
