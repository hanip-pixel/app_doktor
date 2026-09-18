import 'package:flutter/material.dart';
import '../../../data/models/patient.dart';
import '../../../data/dummy/dummy_patients.dart';
import 'medicine_order_screen.dart';

class MedicinePatientSearchScreen extends StatefulWidget {
  const MedicinePatientSearchScreen({super.key});

  @override
  State<MedicinePatientSearchScreen> createState() =>
      _MedicinePatientSearchScreenState();
}

class _MedicinePatientSearchScreenState
    extends State<MedicinePatientSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Semua'; // 'Semua', 'No. RM', 'NIK', 'Nama'

  // Warna Utama Tema Resep Obat (Blue)
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _darkerBlue = Color(0xFF0369A1);
  static const Color _lightBlue = Color(0xFFE0F2FE);

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
      final matchDiagnosa =
          p.diagnosa.any((d) => d.toLowerCase().contains(query));

      if (_selectedCategory == 'No. RM') {
        return matchMr;
      } else if (_selectedCategory == 'NIK') {
        return matchNik;
      } else if (_selectedCategory == 'Nama') {
        return matchName;
      }
      return matchName ||
          matchMr ||
          matchNik ||
          matchSep ||
          matchComplaint ||
          matchDiagnosa;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final results = _searchResults;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Resep Obat Pasien',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Cari pasien untuk buat atau revisi resep obat',
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
          // Header Search Box (Warna Biru Khas Farmasi)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: const BoxDecoration(
              color: _primaryBlue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Input TextField Putih dengan Shadow
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
                    autofocus: false,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ketik No. RM, NIK, atau Nama Pasien...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: _primaryBlue,
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

                // Category Filter Pills (Semua, No. RM, NIK, Nama)
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

          // Konten Body
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
            color: isSelected ? _darkerBlue : Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Initial Empty State (Banner Biru Muda)
  // ---------------------------------------------------------------------------
  Widget _buildInitialEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE0F2FE), Color(0xFFEFF6FF)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.4),
                ),
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
                          color: _primaryBlue.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_pharmacy_rounded,
                      color: _primaryBlue,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Pencarian Pasien Resep Obat',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Cari pasien berdasarkan Nama, No. RM, atau NIK untuk membuat resep baru atau menambahkan item obat yang terlewat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Not Found State
  // ---------------------------------------------------------------------------
  Widget _buildNotFoundState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 36,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Pasien "$query" Tidak Ditemukan',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Periksa kembali kata kunci nama atau No. RM pasien.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Search Results List (Hasil Pasien dengan Aksen Biru)
  // ---------------------------------------------------------------------------
  Widget _buildSearchResultsList(List<Patient> list) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final patient = list[index];

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicineOrderScreen(patient: patient),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar Pasien Biru Muda
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: _lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: _primaryBlue,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Info Pasien
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                patient.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: _primaryBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  patient.insurance,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'RM ${patient.mrNumber} · ${patient.age} th · ${patient.gender}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keluhan: ${patient.complaint}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF334155),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Ikon Panah Masuk
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: _primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}