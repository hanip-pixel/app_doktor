import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/patient.dart';
import '../widgets/patient_card.dart';
import 'patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  int _selectedFilter =
      0; // 0: Hari ini, 1: Menunggu, 2: Sedang Diperiksa, 3: Selesai
  final _searchController = TextEditingController();
  bool _isLoading = false;

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
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _onFilterChanged(int index) {
    if (_selectedFilter != index) {
      setState(() {
        _selectedFilter = index;
        _isLoading = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  List<Patient> get _filteredPatients {
    final query = _searchController.text.trim().toLowerCase();
    return DummyPatients.todayList.where((p) {
      // Status Filter
      bool matchesStatus = true;
      if (_selectedFilter == 1) {
        matchesStatus = p.status == PatientStatus.waiting;
      } else if (_selectedFilter == 2) {
        matchesStatus = p.status == PatientStatus.inProgress;
      } else if (_selectedFilter == 3) {
        matchesStatus = p.status == PatientStatus.done;
      }

      // Search Query Filter (name, No. RM, NIK, or complaint)
      bool matchesQuery = true;
      if (query.isNotEmpty) {
        final matchName = p.name.toLowerCase().contains(query);
        final matchMr = p.mrNumber.toLowerCase().contains(query);
        final matchNik = (p.nik ?? '').toLowerCase().contains(query);
        final matchComplaint = p.complaint.toLowerCase().contains(query);
        matchesQuery = matchName || matchMr || matchNik || matchComplaint;
      }

      return matchesStatus && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredPatients;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.groups_2_rounded,
                      color: Color(0xFF00897B),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daftar Pasien',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Cari dan pantau status pasien poli',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${filteredList.length} Data',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Search Bar & Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Search Input
                  Material(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: const Color(
                      0xFF0F172A,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(28),
                    clipBehavior: Clip.antiAlias,
                    child: TextField(
                      controller: _searchController,
                      cursorColor: const Color(0xFF00897B),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Cari nama / No. RM / NIK',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Color(0xFF64748B),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(
                            color: Color(0xFFF1F5F9),
                            width: 0.8,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(
                            color: Color(0xFFF1F5F9),
                            width: 0.8,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: const BorderSide(
                            color: Color(0xFF99D8D0),
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips (Horizontally scrollable for all screen sizes)
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildFilterChip('Hari ini', 0),
                        const SizedBox(width: 8),
                        _buildFilterChip('Menunggu', 1),
                        const SizedBox(width: 8),
                        _buildFilterChip('Sedang Diperiksa', 2),
                        const SizedBox(width: 8),
                        _buildFilterChip('Selesai', 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Patient List
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton()
                  : RefreshIndicator(
                      color: const Color(0xFF00897B),
                      backgroundColor: const Color(0xFFF8FAFC),
                      onRefresh: _handleRefresh,
                      child: filteredList.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final patient = filteredList[index];
                                return PatientCard(
                                  patient: patient,
                                  onTap: () =>
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PatientDetailScreen(
                                            patient: patient,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {});
                                      }),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8F1F8), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 130,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 180,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 110,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 65,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => _onFilterChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00897B) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF00897B) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F6FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 38,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pasien Tidak Ditemukan',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tidak ada pasien yang sesuai dengan kata kunci pencarian atau filter status yang dipilih.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
