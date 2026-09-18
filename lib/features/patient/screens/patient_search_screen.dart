import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/patient.dart';
import 'patient_detail_screen.dart';
import 'patient_history_screen.dart';

class PatientSearchScreen extends StatefulWidget {
  const PatientSearchScreen({super.key});

  @override
  State<PatientSearchScreen> createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Semua'; // 'Semua', 'No. RM', 'NIK', 'Nama'

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Patient> get _searchResults {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return [];
    }

    return DummyPatients.todayList.where((p) {
      final matchName = p.name.toLowerCase().contains(query);
      final matchMr = p.mrNumber.toLowerCase().contains(query);
      final matchNik = (p.nik ?? '').toLowerCase().contains(query);
      final matchSep = (p.noSep ?? '').toLowerCase().contains(query);
      final matchComplaint = p.complaint.toLowerCase().contains(query);
      final matchDiagnosa = p.diagnosa.any((d) => d.toLowerCase().contains(query));

      if (_selectedCategory == 'No. RM') {
        return matchMr;
      } else if (_selectedCategory == 'NIK') {
        return matchNik;
      } else if (_selectedCategory == 'Nama') {
        return matchName;
      }
      return matchName || matchMr || matchNik || matchSep || matchComplaint || matchDiagnosa;
    }).toList();
  }

  void _applyQuickSearch(String text) {
    _searchController.text = text;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final results = _searchResults;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pencarian & Pantau Pasien',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Cari data spesifik & pantau tindakan medis',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.white70,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Search Box Card
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF00897B),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Input TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Ketik No. RM, NIK, atau Nama Pasien...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF00897B),
                        size: 24,
                      ),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('Semua'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('No. RM'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('NIK'),
                      const SizedBox(width: 8),
                      _buildCategoryChip('Nama'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body Content: Empty State vs Results vs Not Found
          Expanded(
            child: query.isEmpty
                ? _buildInitialEmptyState()
                : results.isEmpty
                    ? _buildNotFoundState(query)
                    : _buildSearchResultsList(results),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF00796B) : Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Initial Empty State (When doctor hasn't typed anything)
  // ---------------------------------------------------------------------------
  Widget _buildInitialEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt Banner Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0F2F1), Color(0xFFF1F8E9)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF80CBC4).withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00897B).withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_search_rounded,
                    size: 38,
                    color: Color(0xFF00897B),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Cari Data Pasien Spesifik',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Masukkan Nomor Rekam Medis (RM), NIK, atau Nama Pasien untuk memantau status tindakan dan melakukan perubahan data klinis.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Search Samples / Chips
          const Row(
            children: [
              Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFF59E0B)),
              SizedBox(width: 6),
              Text(
                'Saran Pencarian Cepat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestionChip('0012345', 'Budi Santoso (RM)'),
              _buildSuggestionChip('0012346', 'Siti Aminah (RM)'),
              _buildSuggestionChip('3171012304790001', 'NIK Budi'),
              _buildSuggestionChip('Ahmad Fauzi', 'Ahmad Fauzi'),
              _buildSuggestionChip('Dewi Lestari', 'Dewi Lestari'),
              _buildSuggestionChip('Eko Prasetyo', 'Eko Prasetyo'),
            ],
          ),
          const SizedBox(height: 26),

          // Features Guide Section
          const Text(
            'Panduan Fitur Pemantauan Pasien',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          _buildGuideItem(
            icon: Icons.badge_outlined,
            iconBg: const Color(0xFFE0F2FE),
            iconColor: const Color(0xFF0284C7),
            title: 'Identitas & Demografis Lengkap',
            desc: 'Akses data lengkap No. RM, NIK, No. BPJS, status asuransi, hingga kontak darurat.',
          ),
          const SizedBox(height: 10),
          _buildGuideItem(
            icon: Icons.monitor_heart_outlined,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFDC2626),
            title: 'Pantau Status Tindakan & CPPT',
            desc: 'Lihat progres TTV, catatan SOAP dokter, order radiologi, lab, dan e-resep farmasi.',
          ),
          const SizedBox(height: 10),
          _buildGuideItem(
            icon: Icons.edit_note_rounded,
            iconBg: const Color(0xFFFEF3C7),
            iconColor: const Color(0xFFD97706),
            title: 'Akses & Ubah Rekam Medis (RME)',
            desc: 'Langsung buka lembar pemeriksaan untuk mengedit tindakan atau melanjutkan asesmen.',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String queryValue, String label) {
    return ActionChip(
      avatar: const Icon(Icons.search, size: 14, color: Color(0xFF00897B)),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0F766E),
        ),
      ),
      backgroundColor: const Color(0xFFE6FFFA),
      side: const BorderSide(color: Color(0xFF99F6E4)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () => _applyQuickSearch(queryValue),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Not Found State
  // ---------------------------------------------------------------------------
  Widget _buildNotFoundState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Pasien Tidak Ditemukan',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak ada data pasien yang cocok dengan kata kunci "$query". Pastikan No. RM, NIK, atau Nama Pasien sudah tepat.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Pencarian'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00897B),
                side: const BorderSide(color: Color(0xFF00897B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Search Results List
  // ---------------------------------------------------------------------------
  Widget _buildSearchResultsList(List<Patient> results) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ditemukan ${results.length} Pasien',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const Text(
                  'Ketuk untuk melihat detail',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        }

        final patient = results[index - 1];
        return _buildPatientResultCard(patient);
      },
    );
  }

  Widget _buildPatientResultCard(Patient patient) {
    final isMale = patient.gender == 'L';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _showPatientMonitoringModal(context, patient),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Name + RM & Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with gender indicator
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isMale ? const Color(0xFFEFF6FF) : const Color(0xFFFDF2F8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isMale ? const Color(0xFFBFDBFE) : const Color(0xFFFBCFE8),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isMale ? Icons.face_rounded : Icons.face_3_rounded,
                          color: isMale ? const Color(0xFF2563EB) : const Color(0xFFDB2777),
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name & Identitas
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'RM: ${patient.mrNumber}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                              ),
                              if (patient.nik != null && patient.nik!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'NIK: ${patient.nik}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              Text(
                                '${patient.age} th • ${isMale ? "Laki-laki" : "Perempuan"}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    StatusBadge(status: patient.status),
                  ],
                ),
                const Divider(height: 20, color: Color(0xFFF1F5F9)),

                // Clinical summary & Service Location
                Row(
                  children: [
                    const Icon(
                      Icons.local_hospital_outlined,
                      size: 14,
                      color: Color(0xFF00897B),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${patient.poli ?? "Poli Penyakit Dalam"} • ${patient.dpjp ?? "dr. Andi Pratama, Sp.PD"}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEEF2F6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.medical_information_outlined,
                        size: 15,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          patient.diagnosa.isNotEmpty
                              ? 'Diagnosa: ${patient.diagnosa.first}'
                              : 'Keluhan: ${patient.complaint}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF334155),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Color(0xFF00897B),
                      ),
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

  // ---------------------------------------------------------------------------
  // 4. Detailed Patient Identity & Clinical Monitoring Bottom Sheet Modal
  // ---------------------------------------------------------------------------
  void _showPatientMonitoringModal(BuildContext context, Patient patient) {
    final isMale = patient.gender == 'L';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  // Drag Handle Bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Patient Avatar
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: isMale ? const Color(0xFFEFF6FF) : const Color(0xFFFDF2F8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isMale ? const Color(0xFFBFDBFE) : const Color(0xFFFBCFE8),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isMale ? Icons.face_rounded : Icons.face_3_rounded,
                              color: isMale ? const Color(0xFF2563EB) : const Color(0xFFDB2777),
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Name & Identification
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      patient.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusBadge(status: patient.status),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'No. RM: ${patient.mrNumber} • ${patient.age} Tahun (${isMale ? "L" : "P"})',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),

                  // Scrollable Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      children: [
                        // SECTION 1: IDENTITAS LENGKAP PASIEN
                        _buildSectionTitle('Identitas Lengkap Pasien', Icons.badge_outlined),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('Nama Lengkap', patient.name),
                              _buildInfoRow('No. Rekam Medis (RM)', patient.mrNumber),
                              _buildInfoRow('NIK (KTP)', patient.nik ?? '3171012304790001'),
                              _buildInfoRow('No. BPJS / Asuransi', '${patient.insurance} (${patient.noSep ?? "2026R00012345"})'),
                              _buildInfoRow('Jenis Kelamin', isMale ? 'Laki-laki (L)' : 'Perempuan (P)'),
                              _buildInfoRow('Usia / Tanggal Lahir', '${patient.age} Tahun • ${patient.birthDate ?? "15 Mei 1981"}'),
                              _buildInfoRow('Golongan Darah', patient.bloodType ?? 'O (Rhesus +)'),
                              _buildInfoRow('No. Telepon / HP', patient.phone ?? '0812-3456-7890'),
                              _buildInfoRow('Alamat Domisili', patient.address ?? 'Jl. Melati No. 42, Jakarta Selatan'),
                              _buildInfoRow('Pekerjaan', patient.occupation ?? 'Karyawan Swasta'),
                              _buildInfoRow('Kontak Darurat', patient.emergencyContact ?? 'Ny. Sarah (Istri - 0813-9876-5432)', isLast: true),
                            ],
                          ),
                        ),

                        // Alergi Alert Box (if any)
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  patient.allergies.isNotEmpty
                                      ? 'Riwayat Alergi: ${patient.allergies.join(", ")}'
                                      : 'Riwayat Alergi: Amoxicillin (Reaksi: Ruam kulit ringan)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF991B1B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // SECTION 2: STATUS PEMANTAUAN & TINDAKAN KLINIS
                        _buildSectionTitle('Status Pemantauan & Tindakan', Icons.monitor_heart_outlined),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('Poli / Ruang Rawat', patient.poli ?? 'Poli Penyakit Dalam'),
                              _buildInfoRow('Dokter Penanggung Jawab', patient.dpjp ?? 'dr. Andi Pratama, Sp.PD'),
                              _buildInfoRow('Jadwal / Jam Kedatangan', '${patient.scheduleTime} WIB'),
                              _buildInfoRow('Keluhan Saat Registrasi', patient.complaint, isLast: true),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Clinical Checklist Monitoring Cards
                        _buildChecklistMonitoringCard(patient),

                        const SizedBox(height: 24),

                        // SECTION 3: RINGKASAN TTV & CPPT SOAP TERAKHIR
                        _buildSectionTitle('Ringkasan TTV & SOAP Terkini', Icons.receipt_long_rounded),
                        const SizedBox(height: 10),

                        // TTV Grid
                        _buildTtvSummaryGrid(patient),
                        const SizedBox(height: 12),

                        // CPPT SOAP Accordion Box
                        _buildSoapSummaryBox(patient),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Bottom Action Buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Riwayat Pasien Button
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(modalContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PatientHistoryScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.history_rounded, size: 18),
                            label: const Text('Riwayat'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF475569),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Buka / Ubah Tindakan RME Button
                        Expanded(
                          flex: 3,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(modalContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PatientDetailScreen(patient: patient),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note_rounded, size: 20, color: Colors.white),
                            label: const Text(
                              'Buka RME & Tindakan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00897B),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF00897B)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistMonitoringCard(Patient patient) {
    final hasTtv = patient.ttvData != null || patient.tekananDarah != null;
    final hasCppt = patient.cpptData != null || patient.anamnesis != null;
    final hasRadiology = patient.tindakan.any((t) => t.toLowerCase().contains('rontgen') || t.toLowerCase().contains('radiologi'));
    final hasDiagnosa = patient.diagnosa.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist_rounded, color: Color(0xFF16A34A), size: 18),
              SizedBox(width: 6),
              Text(
                'Progres Alur Tindakan Klinis Hari Ini',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF15803D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCheckItem('Tanda Vital & Triase', hasTtv ? 'Sudah Tercatat' : 'Belum diisi', hasTtv),
          _buildCheckItem('Asesmen Medis (CPPT)', hasCppt ? 'Catatan SOAP Tersimpan' : 'Siap Diisi', hasCppt),
          _buildCheckItem('Pemeriksaan Radiologi', hasRadiology ? 'Order / Hasil Radiologi Ada' : 'Tidak Ada Order', hasRadiology),
          _buildCheckItem('Diagnosa & E-Resep', hasDiagnosa ? '${patient.diagnosa.length} Diagnosa ICD-10' : 'Menunggu Input', hasDiagnosa),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, String statusText, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: isDone ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDone ? const Color(0xFF15803D) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTtvSummaryGrid(Patient patient) {
    final td = patient.ttvData?.tekananDarah ?? patient.tekananDarah ?? '120/80';
    final nadi = patient.ttvData?.nadi ?? patient.nadi ?? '78';
    final suhu = patient.ttvData?.suhu ?? patient.suhu ?? '36.5';
    final rr = patient.ttvData?.lajuNafas ?? patient.laju ?? '20';
    final spo2 = patient.ttvData?.spo2 ?? '98';
    final bb = patient.ttvData?.beratBadan ?? '70';

    return Column(
      children: [
        Row(
          children: [
            _buildTtvMiniCard('TD', '$td mmHg', Icons.speed_rounded, const Color(0xFF0284C7)),
            const SizedBox(width: 8),
            _buildTtvMiniCard('Nadi', '$nadi x/m', Icons.favorite_rounded, const Color(0xFFDC2626)),
            const SizedBox(width: 8),
            _buildTtvMiniCard('Suhu', '$suhu °C', Icons.thermostat_rounded, const Color(0xFFD97706)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTtvMiniCard('RR', '$rr x/m', Icons.air_rounded, const Color(0xFF059669)),
            const SizedBox(width: 8),
            _buildTtvMiniCard('SpO2', '$spo2%', Icons.waves_rounded, const Color(0xFF7C3AED)),
            const SizedBox(width: 8),
            _buildTtvMiniCard('BB', '$bb kg', Icons.monitor_weight_rounded, const Color(0xFF475569)),
          ],
        ),
      ],
    );
  }

  Widget _buildTtvMiniCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoapSummaryBox(Patient patient) {
    final subjektif = patient.cpptData?.subjektif ?? patient.keluhanUtama ?? patient.complaint;
    final objektif = patient.cpptData?.objektif ?? patient.pemeriksaanFisik ?? 'Pemeriksaan fisik umum dalam batas normal.';
    final asesmen = patient.cpptData?.asesmen ?? (patient.diagnosa.isNotEmpty ? patient.diagnosa.join(', ') : 'Observasi klinis');
    final plan = patient.cpptData?.plan ?? patient.rencanaTerapi ?? 'Pemeriksaan lanjutan & edukasi pasien.';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan CPPT (SOAP) Terakhir',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),
          _buildSoapItem('S (Subjektif)', subjektif),
          _buildSoapItem('O (Objektif)', objektif),
          _buildSoapItem('A (Asesmen)', asesmen),
          _buildSoapItem('P (Plan)', plan, isLast: true),
        ],
      ),
    );
  }

  Widget _buildSoapItem(String label, String content, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00897B),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            content,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF334155),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
