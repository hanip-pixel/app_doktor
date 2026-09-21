import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/models/medical_order.dart';
import '../../patient/screens/patient_detail_screen.dart';

class RadiologyMonitoringScreen extends StatefulWidget {
  const RadiologyMonitoringScreen({super.key});

  @override
  State<RadiologyMonitoringScreen> createState() =>
      _RadiologyMonitoringScreenState();
}

class _RadiologyMonitoringScreenState extends State<RadiologyMonitoringScreen> {
  String _selectedTab = 'ready'; // 'ready', 'pending', 'all'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicalOrder> get _radiologyOrders {
    // Filter only radiology orders
    var list = DummyOrders.list
        .where((o) => o.type == OrderType.radiology)
        .toList();

    // Tab Filter
    if (_selectedTab == 'ready') {
      list = list
          .where(
            (o) =>
                o.status == OrderStatus.resultsReady ||
                o.status == OrderStatus.completed,
          )
          .toList();
    } else if (_selectedTab == 'pending') {
      list = list
          .where((o) => o.status == OrderStatus.pendingRadiology)
          .toList();
    }

    // Search Query Filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((o) {
        final matchPatient =
            o.patient.name.toLowerCase().contains(q) ||
            o.patient.mrNumber.toLowerCase().contains(q);
        final matchOrderNumber = o.orderNumber.toLowerCase().contains(q);
        final matchItems = o.items.any(
          (item) => item.toLowerCase().contains(q),
        );
        final matchResult = (o.resultSummary ?? '').toLowerCase().contains(q);
        return matchPatient || matchOrderNumber || matchItems || matchResult;
      }).toList();
    }

    return list;
  }

  int get _readyCount => DummyOrders.list
      .where(
        (o) =>
            o.type == OrderType.radiology &&
            (o.status == OrderStatus.resultsReady ||
                o.status == OrderStatus.completed),
      )
      .length;

  int get _pendingCount => DummyOrders.list
      .where(
        (o) =>
            o.type == OrderType.radiology &&
            o.status == OrderStatus.pendingRadiology,
      )
      .length;

  @override
  Widget build(BuildContext context) {
    final orders = _radiologyOrders;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(),

            // Search Bar
            _buildSearchBar(),

            // Tab Selector (Hasil Siap Dibaca vs Dalam Antrean)
            _buildTabSelector(),

            // Content List
            Expanded(
              child: orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildRadiologyResultCard(order);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.2),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1E293B),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil & Monitoring Radiologi',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Hasil rontgen, USG, & ekspertise Sp.Rad',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF4FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF0ABFC)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.biotech_rounded,
                  size: 14,
                  color: Color(0xFFA855F7),
                ),
                const SizedBox(width: 4),
                Text(
                  '$_readyCount Siap',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA855F7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Cari nama pasien, No. RM, atau jenis rontgen...',
            hintStyle: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF94A3B8),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 11),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabItem(
                key: 'ready',
                label: 'Hasil Siap Dibaca',
                count: _readyCount,
                icon: Icons.verified_rounded,
                activeColor: const Color(0xFF059669),
              ),
              const SizedBox(width: 4),
              _buildTabItem(
                key: 'pending',
                label: 'Dalam Antrean',
                count: _pendingCount,
                icon: Icons.hourglass_top_rounded,
                activeColor: const Color(0xFFD97706),
              ),
              const SizedBox(width: 4),
              _buildTabItem(
                key: 'all',
                label: 'Semua',
                count: DummyOrders.list
                    .where((o) => o.type == OrderType.radiology)
                    .length,
                icon: Icons.list_alt_rounded,
                activeColor: const Color(0xFF00897B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String key,
    required String label,
    required int count,
    required IconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedTab == key;

    return InkWell(
      onTap: () => setState(() => _selectedTab = key),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? activeColor : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeColor : const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card Hasil Radiologi dengan Preview
  // ---------------------------------------------------------------------------
  Widget _buildRadiologyResultCard(MedicalOrder order) {
    final hasResult =
        order.resultSummary != null && order.resultSummary!.isNotEmpty;
    final isPending = order.status == OrderStatus.pendingRadiology;
    final isMale = order.patient.gender == 'L';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasResult ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
          width: hasResult ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Patient + Order Info
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isMale
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFFDF2F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMale
                          ? const Color(0xFFBFDBFE)
                          : const Color(0xFFFBCFE8),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isMale ? Icons.face_rounded : Icons.face_3_rounded,
                      color: isMale
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFDB2777),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Patient Name & MR
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              order.patient.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: order.patient.insurance == 'BPJS'
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order.patient.insurance,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: order.patient.insurance == 'BPJS'
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'RM: ${order.patient.mrNumber} • ${order.patient.age} th (${isMale ? "L" : "P"}) • ${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hasResult
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasResult
                          ? const Color(0xFF6EE7B7)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasResult
                            ? Icons.check_circle_rounded
                            : Icons.hourglass_top_rounded,
                        size: 13,
                        color: hasResult
                            ? const Color(0xFF059669)
                            : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasResult ? 'Hasil Siap' : 'Dalam Antrean',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: hasResult
                              ? const Color(0xFF059669)
                              : const Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Examination Items Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: order.items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFF0ABFC)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 12,
                        color: Color(0xFFA855F7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFA855F7),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // PREVIEW SECTION (If Result Available)
          if (hasResult) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/sample_xray.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: const Color(0xFF1E293B),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: Colors.white54,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DICOM',
                                style: TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Ekspertise Summary
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: Color(0xFF34D399),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Ekspertise Radiolog (Sp.Rad)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF34D399),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.resultSummary!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE2E8F0),
                              height: 1.35,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (isPending) ...[
            // Status Pending Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFD97706),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        (order.clinicalNotes != null &&
                                order.clinicalNotes!.isNotEmpty)
                            ? 'Indikasi: ${order.clinicalNotes}'
                            : 'Sedang dalam antrean tindakan di Instalasi Radiologi.',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF92400E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                if (hasResult) ...[
                  // Button Buka Viewer Rontgen
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showDicomViewerModal(context, order),
                      icon: const Icon(
                        Icons.fullscreen_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Foto Rontgen',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Button Salin ke CPPT
                  OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: order.resultSummary ?? ''),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ekspertise ${order.patient.name} disalin ke clipboard!',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF00897B),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: Color(0xFF00897B),
                    ),
                    label: const Text(
                      'Salin',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00897B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF80CBC4)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                // Button Buka RME Pasien
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PatientDetailScreen(patient: order.patient),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.folder_shared_outlined,
                    size: 16,
                    color: Color(0xFF475569),
                  ),
                  label: const Text(
                    'RME',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                Icons.biotech_outlined,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Data Radiologi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tidak ditemukan pemeriksaan yang cocok dengan "$_searchQuery".'
                  : 'Belum ada order radiologi pada kategori ini.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fullscreen Interactive DICOM X-Ray Viewer Modal
  // ---------------------------------------------------------------------------
  void _showDicomViewerModal(BuildContext context, MedicalOrder order) {
    showDialog(
      context: context,
      builder: (viewerContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 24,
          ),
          backgroundColor: const Color(0xFF090D16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Viewer Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF111827),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.grid_view_rounded,
                      color: Color(0xFF38BDF8),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order.patient.name} (${order.patient.mrNumber})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${order.items.join(" • ")} • ${order.orderNumber}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                      ),
                      onPressed: () => Navigator.pop(viewerContext),
                    ),
                  ],
                ),
              ),

              // Image Area with Zoom
              Flexible(
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(8),
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/sample_xray.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'File foto rontgen tidak tersedia',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Diagnosis Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFF111827),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.assignment_turned_in_rounded,
                          color: Color(0xFF34D399),
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Kesimpulan Hasil Radiologi',
                          style: TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.resultSummary ??
                          'Hasil pemeriksaan telah selesai diverifikasi oleh Dokter Spesialis Radiologi.',
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: order.resultSummary ?? ''),
                            );
                            Navigator.pop(viewerContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Ekspertise disalin ke clipboard!',
                                ),
                                backgroundColor: const Color(0xFF00897B),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.copy_rounded,
                            size: 16,
                            color: Color(0xFF38BDF8),
                          ),
                          label: const Text(
                            'Salin ke CPPT',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontWeight: FontWeight.bold,
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
      },
    );
  }
}
