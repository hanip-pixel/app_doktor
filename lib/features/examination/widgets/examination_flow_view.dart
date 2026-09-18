import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/examination_entry.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/models/patient.dart';

class ExaminationFlowView extends StatefulWidget {
  final Patient patient;
  final ValueChanged<Patient>? onSaved;

  const ExaminationFlowView({
    super.key,
    required this.patient,
    this.onSaved,
  });

  @override
  State<ExaminationFlowView> createState() => _ExaminationFlowViewState();
}

class _ExaminationFlowViewState extends State<ExaminationFlowView> {
  late Patient _patient;
  late PageController _pageController;
  int _currentStepIndex = 0; // 0: Pilih Layanan, 1: Isi Form, 2: Validasi Isi

  // Selected Services in Step 1 (Awalnya kosong, dokter memilih secara manual)
  final Set<ExaminationServiceType> _selectedServices = {};

  // Controllers for CPPT
  late TextEditingController _subjektifController;
  late TextEditingController _objektifController;
  late TextEditingController _asesmenController;
  late TextEditingController _planController;

  // Controllers for TTV
  late TextEditingController _tdController;
  late TextEditingController _nadiController;
  late TextEditingController _rrController;
  late TextEditingController _suhuController;
  late TextEditingController _spo2Controller;
  late TextEditingController _bbController;
  late TextEditingController _tbController;

  // Controllers for Diagnosa & Tindakan
  late List<String> _diagnosaList;
  late List<String> _tindakanList;
  late TextEditingController _terapiController;
  late TextEditingController _edukasiController;

  bool _isListeningVoice = false;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    _pageController = PageController(initialPage: 0);

    // CPPT Controllers (Awal bersih)
    _subjektifController = TextEditingController(
      text: _patient.keluhanUtama?.isNotEmpty == true
          ? _patient.keluhanUtama!
          : (_patient.complaint.isNotEmpty ? _patient.complaint : ''),
    );
    _objektifController = TextEditingController();
    _asesmenController = TextEditingController();
    _planController = TextEditingController();

    // TTV Controllers (Awal bersih)
    _tdController = TextEditingController();
    _nadiController = TextEditingController();
    _rrController = TextEditingController();
    _suhuController = TextEditingController();
    _spo2Controller = TextEditingController();
    _bbController = TextEditingController();
    _tbController = TextEditingController();

    // Diagnosa & Tindakan (Awal bersih)
    _diagnosaList = [];
    _tindakanList = [];
    _terapiController = TextEditingController();
    _edukasiController = TextEditingController();

    // Add listeners for reactive step 2 validation
    _subjektifController.addListener(_onFieldChanged);
    _objektifController.addListener(_onFieldChanged);
    _asesmenController.addListener(_onFieldChanged);
    _planController.addListener(_onFieldChanged);
    _tdController.addListener(_onFieldChanged);
    _nadiController.addListener(_onFieldChanged);
    _rrController.addListener(_onFieldChanged);
    _suhuController.addListener(_onFieldChanged);
    _spo2Controller.addListener(_onFieldChanged);
    _bbController.addListener(_onFieldChanged);
    _tbController.addListener(_onFieldChanged);
    _terapiController.addListener(_onFieldChanged);
    _edukasiController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _subjektifController.removeListener(_onFieldChanged);
    _objektifController.removeListener(_onFieldChanged);
    _asesmenController.removeListener(_onFieldChanged);
    _planController.removeListener(_onFieldChanged);
    _tdController.removeListener(_onFieldChanged);
    _nadiController.removeListener(_onFieldChanged);
    _rrController.removeListener(_onFieldChanged);
    _suhuController.removeListener(_onFieldChanged);
    _spo2Controller.removeListener(_onFieldChanged);
    _bbController.removeListener(_onFieldChanged);
    _tbController.removeListener(_onFieldChanged);
    _terapiController.removeListener(_onFieldChanged);
    _edukasiController.removeListener(_onFieldChanged);

    _subjektifController.dispose();
    _objektifController.dispose();
    _asesmenController.dispose();
    _planController.dispose();

    _tdController.dispose();
    _nadiController.dispose();
    _rrController.dispose();
    _suhuController.dispose();
    _spo2Controller.dispose();
    _bbController.dispose();
    _tbController.dispose();

    _terapiController.dispose();
    _edukasiController.dispose();
    super.dispose();
  }

  // Validasi apakah setiap layanan yang dipilih sudah memiliki isian
  bool get _isStep2Valid {
    if (_selectedServices.isEmpty) return false;

    // Untuk layanan CPPT: minimal 1 komponen SOAP harus terisi
    if (_selectedServices.contains(ExaminationServiceType.cppt)) {
      final hasCppt = _subjektifController.text.trim().isNotEmpty ||
          _objektifController.text.trim().isNotEmpty ||
          _asesmenController.text.trim().isNotEmpty ||
          _planController.text.trim().isNotEmpty;
      if (!hasCppt) return false;
    }

    // Untuk layanan TTV: minimal 1 parameter TTV harus terisi
    if (_selectedServices.contains(ExaminationServiceType.ttv)) {
      final hasTtv = _tdController.text.trim().isNotEmpty ||
          _nadiController.text.trim().isNotEmpty ||
          _rrController.text.trim().isNotEmpty ||
          _suhuController.text.trim().isNotEmpty ||
          _spo2Controller.text.trim().isNotEmpty ||
          _bbController.text.trim().isNotEmpty ||
          _tbController.text.trim().isNotEmpty;
      if (!hasTtv) return false;
    }

    // Untuk layanan Diagnosa & Tindakan: minimal 1 diagnosa / tindakan / terapi / edukasi terisi
    if (_selectedServices.contains(ExaminationServiceType.diagnosaTindakan)) {
      final hasDiag = _diagnosaList.isNotEmpty ||
          _tindakanList.isNotEmpty ||
          _terapiController.text.trim().isNotEmpty ||
          _edukasiController.text.trim().isNotEmpty;
      if (!hasDiag) return false;
    }

    return true;
  }

  void _goToStep(int index) {
    if (_selectedServices.isEmpty && index > 0) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Silakan pilih minimal 1 layanan pemeriksaan terlebih dahulu.'),
          backgroundColor: Color(0xFFE11D48),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (index == 2 && !_isStep2Valid) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Silakan lengkapi isi formulir pemeriksaan yang dipilih terlebih dahulu.'),
          backgroundColor: Color(0xFFE11D48),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _currentStepIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  double? get _calculatedImt {
    final bb = double.tryParse(_bbController.text);
    final tb = double.tryParse(_tbController.text);
    if (bb != null && tb != null && tb > 0) {
      final tbMeter = tb / 100.0;
      return bb / (tbMeter * tbMeter);
    }
    return null;
  }

  String get _imtStatus {
    final val = _calculatedImt;
    if (val == null) return 'Normal';
    if (val < 18.5) return 'Underweight';
    if (val < 25.0) return 'Normal';
    if (val < 30.0) return 'Overweight';
    return 'Obesitas';
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
      'M17.0  Osteoartritis lutut primer bilateral',
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

  void _showAddTindakanSheet() {
    final commonTindakan = [
      '89.07  Konsultasi dan Evaluasi Medis Pasien',
      '89.7   Pemeriksaan Fisik Lengkap Poliklinik',
      '89.52  Elektrokardiogram (EKG 12-Lead)',
      '96.59  Irigasi dan Pembersihan Luka Ringan',
      '93.57  Aplikasi Pembalutan dan Perban Elastis',
      '99.29  Injeksi Terapi Obat / Vitamin IM/IV',
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
                  'Pilih Tindakan Medis (ICD-9-CM)',
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
                itemCount: commonTindakan.length,
                itemBuilder: (context, index) {
                  final t = commonTindakan[index];
                  final isAdded = _tindakanList.contains(t);
                  return ListTile(
                    dense: true,
                    title: Text(
                      t,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isAdded ? FontWeight.bold : FontWeight.w500,
                        color: isAdded
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    trailing: isAdded
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF2563EB), size: 20)
                        : const Icon(Icons.add_circle_outline,
                            color: Color(0xFF94A3B8), size: 20),
                    onTap: () {
                      if (!isAdded) {
                        setState(() => _tindakanList.add(t));
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

  void _confirmDeleteDraft() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Color(0xFFDC2626), size: 26),
            SizedBox(width: 8),
            Text(
              'Reset Draft Pemeriksaan?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin mereset formulir pemeriksaan ini kembali ke awal (kosong)?',
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
                _selectedServices.clear();

                _subjektifController.text = _patient.complaint;
                _objektifController.clear();
                _asesmenController.clear();
                _planController.clear();

                _tdController.clear();
                _nadiController.clear();
                _rrController.clear();
                _suhuController.clear();
                _spo2Controller.clear();
                _bbController.clear();
                _tbController.clear();

                _diagnosaList.clear();
                _tindakanList.clear();
                _terapiController.clear();
                _edukasiController.clear();
              });

              _goToStep(0);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Draft pemeriksaan berhasil di-reset ke awal.'),
                  backgroundColor: Color(0xFFDC2626),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Reset'),
          ),
        ],
      ),
    );
  }

  void _saveFinalExamination() {
    final cppt = CpptData(
      subjektif: _subjektifController.text,
      objektif: _objektifController.text,
      asesmen: _asesmenController.text,
      plan: _planController.text,
    );
    final ttv = TtvData(
      tekananDarah:
          _tdController.text.isNotEmpty ? _tdController.text : '120/80',
      nadi: _nadiController.text.isNotEmpty ? _nadiController.text : '80',
      lajuNafas: _rrController.text.isNotEmpty ? _rrController.text : '18',
      suhu: _suhuController.text.isNotEmpty ? _suhuController.text : '36.5',
      spo2: _spo2Controller.text.isNotEmpty ? _spo2Controller.text : '98',
      beratBadan: _bbController.text.isNotEmpty ? _bbController.text : '65',
      tinggiBadan: _tbController.text.isNotEmpty ? _tbController.text : '170',
    );
    final diagTindakan = DiagnosaTindakanData(
      diagnosaList: _diagnosaList,
      tindakanList: _tindakanList,
      rencanaTerapi: _terapiController.text,
      catatanEdukasi: _edukasiController.text,
    );

    final updated = _patient.copyWith(
      keluhanUtama: _subjektifController.text.isNotEmpty
          ? _subjektifController.text
          : _patient.complaint,
      anamnesis: _asesmenController.text.isNotEmpty
          ? _asesmenController.text
          : _patient.anamnesis,
      tekananDarah: '${ttv.tekananDarah} mmHg',
      nadi: '${ttv.nadi} x/menit',
      laju: '${ttv.lajuNafas} x/menit',
      suhu: '${ttv.suhu} °C',
      diagnosa: _diagnosaList.isNotEmpty ? _diagnosaList : _patient.diagnosa,
      tindakan: _tindakanList.isNotEmpty ? _tindakanList : _patient.tindakan,
      rencanaTerapi: _terapiController.text.isNotEmpty
          ? _terapiController.text
          : _patient.rencanaTerapi,
      status: PatientStatus.done,
      cpptData: cppt,
      ttvData: ttv,
      diagnosaTindakanData: diagTindakan,
    );

    final idx = DummyPatients.todayList.indexWhere((p) => p.id == updated.id);
    if (idx != -1) {
      DummyPatients.todayList[idx] = updated;
    }

    if (widget.onSaved != null) {
      widget.onSaved!(updated);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFECFDF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF059669),
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pemeriksaan Berhasil Disimpan!',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Data rekam medis ${_patient.name} telah tersimpan dan status pemeriksaan selesai.',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Selesai & Tutup',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // RADIOLOGY / PENUNJANG INTEGRATION
  // ===========================================================================
  Widget _buildRadiologyAlertBanner() {
    final patientOrders = DummyOrders.getOrdersByPatient(_patient.id);
    final readyOrders = patientOrders
        .where((o) =>
            o.type == OrderType.radiology &&
            (o.status == OrderStatus.resultsReady ||
                o.resultSummary != null ||
                o.status == OrderStatus.completed))
        .toList();
    final pendingOrders = patientOrders
        .where((o) =>
            o.type == OrderType.radiology &&
            o.status == OrderStatus.pendingRadiology)
        .toList();

    if (readyOrders.isEmpty && pendingOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    if (readyOrders.isNotEmpty) {
      final order = readyOrders.first;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDD6FE), width: 1.3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
              blurRadius: 8,
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.biotech_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Hasil Radiologi Siap Ditinjau',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF5B21B6),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Hasil Keluar',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${order.orderNumber} • ${order.items.join(", ")}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6D28D9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (order.resultSummary != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE9D5FF)),
                ),
                child: Text(
                  order.resultSummary!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                    height: 1.3,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: OutlinedButton.icon(
                      onPressed: () => _showRadiologyEkspertiseDialog(order),
                      icon: const Icon(Icons.remove_red_eye_rounded, size: 14),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Lihat Citra & Ekspertise',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7C3AED),
                        side: const BorderSide(color: Color(0xFF7C3AED)),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyRadiologyToCppt(order),
                      icon: const Icon(Icons.content_copy_rounded, size: 14),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Salin ke CPPT (Objektif)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (pendingOrders.isNotEmpty) {
      final pending = pendingOrders.first;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.hourglass_top_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Radiologi Sedang Diproses',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${pending.items.join(", ")} • Pasien sedang antre di Radiologi. Anda dapat mengisi CPPT / TTV terlebih dahulu.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB45309),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showRadiologyEkspertiseDialog(MedicalOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 440),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.biotech_rounded,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hasil Ekspertise & Citra Radiologi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${order.orderNumber} • ${_patient.name} (${_patient.mrNumber})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Radiograph Film Viewport
                      Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF334155), width: 1.5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/sample_xray.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                      Icons.image_not_supported_rounded,
                                      color: Colors.white54,
                                      size: 40),
                                );
                              },
                            ),
                            // Watermark / Overlay
                            Positioned(
                              top: 8,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${_patient.name.toUpperCase()} | ${_patient.mrNumber}\n${order.items.join(", ")} | DICOM 3.0',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9.5,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ),
                            // Toolbar
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.zoom_in_rounded,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Icon(Icons.contrast_rounded,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Icon(Icons.fullscreen_rounded,
                                        color: Colors.white, size: 16),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Ekspertise Notes
                      const Text(
                        'Deskripsi Ekspertise Radiolog:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.resultSummary ??
                                  'Cor dan Pulmo dalam batas normal. Tidak tampak kardiomegali atau infiltrat aktif.',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF1E293B),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dokter Radiolog:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  'dr. Hendro Wicaksono, Sp.Rad',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Actions
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _copyRadiologyToCppt(order);
                        },
                        icon: const Icon(Icons.content_copy_rounded, size: 16),
                        label: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Salin ke CPPT',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
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

  void _copyRadiologyToCppt(MedicalOrder order) {
    setState(() {
      _selectedServices.add(ExaminationServiceType.cppt);
      final radText =
          '[Hasil Radiologi ${order.items.join(", ")}]: ${order.resultSummary ?? "Dalam batas normal"}';
      if (_objektifController.text.trim().isEmpty) {
        _objektifController.text = radText;
      } else if (!_objektifController.text.contains(order.items.first)) {
        _objektifController.text =
            '${_objektifController.text.trim()}\n$radText';
      }
    });

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Hasil radiologi berhasil disalin ke CPPT (Objektif)!',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7C3AED),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sleek Connected Sliding Step Dots (Titik Geser Antar Step - Read Only)
        _buildSlidingStepIndicator(),

        // 3-Step PageView Content
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Driven by buttons
            children: [
              _buildStep1SelectServices(),
              _buildStep2InputForm(),
              _buildStep3ValidateReview(),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SLEEK CONNECTED SLIDING STEP DOTS INDICATOR (TITIK GESER ANTAR STEP)
  // ===========================================================================
  Widget _buildSlidingStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          _buildStepDotNode(
            index: 0,
            label: '1. Layanan',
            icon: Icons.checklist_rounded,
          ),
          _buildStepConnectorLine(0),
          _buildStepDotNode(
            index: 1,
            label: '2. Isi Form',
            icon: Icons.edit_note_rounded,
          ),
          _buildStepConnectorLine(1),
          _buildStepDotNode(
            index: 2,
            label: '3. Validasi',
            icon: Icons.verified_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStepDotNode({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isCurrent = _currentStepIndex == index;
    final isPassed = _currentStepIndex > index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isCurrent ? 12 : 6,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF00897B)
            : (isPassed ? const Color(0xFFE0F2F1) : Colors.transparent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Dot / Icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isCurrent ? 16 : 12,
            height: isCurrent ? 16 : 12,
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.white
                  : (isPassed
                      ? const Color(0xFF00897B)
                      : const Color(0xFF94A3B8)),
              shape: BoxShape.circle,
            ),
            child: isPassed
                ? const Icon(Icons.check, size: 8, color: Colors.white)
                : (isCurrent
                    ? const Center(
                        child: Icon(Icons.circle,
                            size: 6, color: Color(0xFF00897B)))
                    : null),
          ),
          const SizedBox(width: 5),

          // Step Label
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
              color: isCurrent
                  ? Colors.white
                  : (isPassed
                      ? const Color(0xFF00897B)
                      : const Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnectorLine(int lineIndex) {
    final isPassed = _currentStepIndex > lineIndex;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color:
              isPassed ? const Color(0xFF00897B) : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP 1: PILIH LAYANAN PEMERIKSAAN
  // ===========================================================================
  Widget _buildStep1SelectServices() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radiology / Penunjang Alert Banner if available
                _buildRadiologyAlertBanner(),

                // Info Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Layanan yang Ingin Diisi:',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedServices.length ==
                              ExaminationServiceType.values.length) {
                            _selectedServices.clear();
                          } else {
                            _selectedServices
                                .addAll(ExaminationServiceType.values);
                          }
                        });
                      },
                      child: Text(
                        _selectedServices.length ==
                                ExaminationServiceType.values.length
                            ? 'Batal Semua'
                            : 'Pilih Semua',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 3 Service Cards
                ...ExaminationServiceType.values.map((type) {
                  final isSelected = _selectedServices.contains(type);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? type.color : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.6 : 1.1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedServices.remove(type);
                            } else {
                              _selectedServices.add(type);
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: type.bgColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(type.icon,
                                    color: type.color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      type.subtitle,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF64748B),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? type.color
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? type.color
                                        : const Color(0xFFCBD5E1),
                                    width: 1.6,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check,
                                        size: 14, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Bottom Next Button
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _selectedServices.isNotEmpty
                  ? () => _goToStep(1)
                  : null,
              icon: Icon(
                Icons.edit_note_rounded,
                size: 18,
                color: _selectedServices.isNotEmpty
                    ? Colors.white
                    : const Color(0xFF94A3B8),
              ),
              label: Text(
                _selectedServices.isNotEmpty
                    ? 'Lanjut ke Isi Form (${_selectedServices.length} Layanan)'
                    : 'Pilih Layanan Terlebih Dahulu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _selectedServices.isNotEmpty
                      ? Colors.white
                      : const Color(0xFF94A3B8),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFF1F5F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 2: ISI FORMULIR PEMERIKSAAN
  // ===========================================================================
  Widget _buildStep2InputForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radiology / Penunjang Alert Banner if available
                _buildRadiologyAlertBanner(),

                // Voice Dictation Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isListeningVoice
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color: _isListeningVoice
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF00897B),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _isListeningVoice
                              ? 'Mendengarkan suara dokter...'
                              : 'Dikte suara untuk mengisi SOAP lebih cepat.',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _isListeningVoice
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(
                              () => _isListeningVoice = !_isListeningVoice);
                        },
                        child: Text(
                          _isListeningVoice ? 'Stop' : 'Mulai Dikte',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: _isListeningVoice
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF00897B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selected Modules Forms
                if (_selectedServices.contains(ExaminationServiceType.cppt))
                  _buildCpptFormCard(),

                if (_selectedServices.contains(ExaminationServiceType.ttv))
                  _buildTtvFormCard(),

                if (_selectedServices
                    .contains(ExaminationServiceType.diagnosaTindakan))
                  _buildDiagnosaTindakanFormCard(),
              ],
            ),
          ),
        ),

        // Bottom Navigation Bar
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => _goToStep(0),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Ubah Layanan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.5),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _isStep2Valid ? () => _goToStep(2) : null,
                    icon: Icon(
                      _isStep2Valid
                          ? Icons.verified_user_rounded
                          : Icons.lock_outline_rounded,
                      size: 18,
                      color: _isStep2Valid
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _isStep2Valid
                            ? 'Lanjut ke Validasi'
                            : 'Lengkapi Isian Layanan',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _isStep2Valid
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCpptFormCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history_edu_rounded,
                  color: Color(0xFF00897B), size: 18),
              SizedBox(width: 6),
              Text(
                'CPPT (SOAP)',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildInputField(
            tag: 'S',
            label: 'Subjektif (Keluhan)',
            controller: _subjektifController,
            hintText: 'Contoh: Pasien mengeluh pusing dan demam sejak 2 hari...',
          ),
          const SizedBox(height: 8),
          _buildInputField(
            tag: 'O',
            label: 'Objektif (Pemeriksaan Fisik)',
            controller: _objektifController,
            hintText: 'Contoh: KU baik, compos mentis, thoraks dbn...',
          ),
          const SizedBox(height: 8),
          _buildInputField(
            tag: 'A',
            label: 'Asesmen (Kesimpulan)',
            controller: _asesmenController,
            hintText: 'Contoh: Febris H-2 ec suspek infeksi virus...',
          ),
          const SizedBox(height: 8),
          _buildInputField(
            tag: 'P',
            label: 'Plan (Rencana Tindakan)',
            controller: _planController,
            hintText: 'Contoh: Terapi simptomatis, edukasi hidrasi cukup...',
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String tag,
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: const Color(0xFF00897B),
              child: Text(tag,
                  style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155))),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF1E293B)),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF94A3B8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTtvFormCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_rounded,
                  color: Color(0xFFE11D48), size: 18),
              SizedBox(width: 6),
              Text(
                'Tanda-Tanda Vital (TTV)',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _buildTtvInputItem(
                      'Tekanan Darah', 'mmHg', _tdController, '120/80')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildTtvInputItem(
                      'Denyut Nadi', 'x/mnt', _nadiController, '80')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildTtvInputItem(
                      'Laju Nafas', 'x/mnt', _rrController, '18')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildTtvInputItem(
                      'Suhu Tubuh', '°C', _suhuController, '36.5')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildTtvInputItem(
                      'SpO2', '%', _spo2Controller, '98')),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('IMT / Gizi',
                          style: TextStyle(
                              fontSize: 10, color: Color(0xFF64748B))),
                      Text(
                        _calculatedImt != null
                            ? '${_calculatedImt!.toStringAsFixed(1)} kg/m² ($_imtStatus)'
                            : '- (Isi BB/TB)',
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildTtvInputItem(
                      'Berat Badan', 'kg', _bbController, '60')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildTtvInputItem(
                      'Tinggi Badan', 'cm', _tbController, '165')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTtvInputItem(
      String label, String unit, TextEditingController controller,
      [String? hint]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 9.5, color: Color(0xFF64748B))),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(unit,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDiagnosaTindakanFormCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment_turned_in_rounded,
                  color: Color(0xFF2563EB), size: 18),
              SizedBox(width: 6),
              Text(
                'Diagnosa & Tindakan Medis',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ICD-10
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Diagnosa ICD-10',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569))),
              InkWell(
                onTap: _showAddDiagnosaSheet,
                child: const Text('+ Tambah ICD-10',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_diagnosaList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
              ),
              child: const Text(
                'Belum ada diagnosa dipilih. Klik "+ Tambah ICD-10"',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF94A3B8),
                ),
              ),
            )
          else
            ..._diagnosaList.map((d) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FBFE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(d,
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B)))),
                      InkWell(
                        onTap: () => setState(() => _diagnosaList.remove(d)),
                        child: const Icon(Icons.close,
                            size: 14, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 8),

          // ICD-9-CM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tindakan ICD-9-CM',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569))),
              InkWell(
                onTap: _showAddTindakanSheet,
                child: const Text('+ Tambah Tindakan',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_tindakanList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
              ),
              child: const Text(
                'Belum ada tindakan medis dipilih. Klik "+ Tambah Tindakan"',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF94A3B8),
                ),
              ),
            )
          else
            ..._tindakanList.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(t,
                              style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E40AF)))),
                      InkWell(
                        onTap: () => setState(() => _tindakanList.remove(t)),
                        child: const Icon(Icons.close,
                            size: 14, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )),
          const SizedBox(height: 8),

          _buildInputField(
            tag: 'Tx',
            label: 'Rencana Terapi',
            controller: _terapiController,
            hintText: 'Contoh: Paracetamol 500mg 3x1 tab...',
          ),
          const SizedBox(height: 8),
          _buildInputField(
            tag: 'Ed',
            label: 'Catatan Edukasi',
            controller: _edukasiController,
            hintText: 'Contoh: Edukasi diet rendah garam, istirahat cukup...',
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 3: VALIDASI ISINYA (REVIEW / TINJAUAN)
  // ===========================================================================
  Widget _buildStep3ValidateReview() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Validation Banner Notice
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded,
                          color: Color(0xFFD97706), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Validasi data pemeriksaan di bawah sebelum disimpan ke rekam medis.',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Review: CPPT
                if (_selectedServices.contains(ExaminationServiceType.cppt))
                  _buildReviewBlock(
                    title: 'CPPT (SOAP)',
                    icon: Icons.history_edu_rounded,
                    color: const Color(0xFF00897B),
                    items: [
                      MapEntry('S - Subjektif', _subjektifController.text),
                      MapEntry('O - Objektif', _objektifController.text),
                      MapEntry('A - Asesmen', _asesmenController.text),
                      MapEntry('P - Plan', _planController.text),
                    ],
                  ),

                // Review: TTV
                if (_selectedServices.contains(ExaminationServiceType.ttv))
                  _buildReviewBlock(
                    title: 'Tanda-Tanda Vital (TTV)',
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFE11D48),
                    items: [
                      MapEntry('Tekanan Darah', '${_tdController.text} mmHg'),
                      MapEntry('Denyut Nadi', '${_nadiController.text} x/mnt'),
                      MapEntry('Laju Nafas', '${_rrController.text} x/mnt'),
                      MapEntry('Suhu Tubuh', '${_suhuController.text} °C'),
                      MapEntry('SpO2', '${_spo2Controller.text} %'),
                      MapEntry('IMT / Gizi',
                          '${_calculatedImt?.toStringAsFixed(1) ?? "23.0"} kg/m² ($_imtStatus)'),
                    ],
                  ),

                // Review: Diagnosa & Tindakan
                if (_selectedServices
                    .contains(ExaminationServiceType.diagnosaTindakan))
                  _buildReviewBlock(
                    title: 'Diagnosa, Tindakan & Terapi',
                    icon: Icons.assignment_turned_in_rounded,
                    color: const Color(0xFF2563EB),
                    items: [
                      MapEntry('Diagnosa ICD-10', _diagnosaList.join(', ')),
                      MapEntry('Tindakan ICD-9-CM', _tindakanList.join(', ')),
                      MapEntry('Rencana Terapi', _terapiController.text),
                      MapEntry('Catatan Edukasi', _edukasiController.text),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // Bottom Action Controls (Edit Form / Reset / Simpan)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Tombol Edit
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => _goToStep(1),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      foregroundColor: const Color(0xFF00897B),
                      side: const BorderSide(color: Color(0xFF00897B)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol Reset
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: _confirmDeleteDraft,
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol Simpan
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _saveFinalExamination,
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewBlock({
    required String title,
    required IconData icon,
    required Color color,
    required List<MapEntry<String, String>> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      entry.value.isNotEmpty ? entry.value : '-',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
