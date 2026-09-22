import 'package:flutter/material.dart';
import '../../../data/dummy/dummy_orders.dart';
import '../../../data/models/medical_order.dart';
import '../../patient/screens/patient_detail_screen.dart';

class OrderListScreen extends StatefulWidget {
  final String? initialFilter;

  const OrderListScreen({super.key, this.initialFilter});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late String _selectedFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterCategories = [
    'Semua',
    'Pending',
    'Hasil Baru',
    'Radiologi',
    'Resep Obat',
    'Billing',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'Semua';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicalOrder> get _filteredOrders {
    var list = DummyOrders.list;

    // Apply Category/Status Filter
    if (_selectedFilter == 'Pending') {
      list = list
          .where(
            (o) =>
                o.status == OrderStatus.pendingPharmacy ||
                o.status == OrderStatus.pendingRadiology ||
                o.status == OrderStatus.pendingBilling,
          )
          .toList();
    } else if (_selectedFilter == 'Hasil Baru') {
      list = list.where((o) => o.status == OrderStatus.resultsReady).toList();
    } else if (_selectedFilter == 'Radiologi') {
      list = list.where((o) => o.type == OrderType.radiology).toList();
    } else if (_selectedFilter == 'Resep Obat') {
      list = list.where((o) => o.type == OrderType.medicine).toList();
    } else if (_selectedFilter == 'Billing') {
      list = list.where((o) => o.type == OrderType.billing).toList();
    }

    // Apply Search Query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((o) {
        final matchPatient =
            o.patient.name.toLowerCase().contains(q) ||
            o.patient.mrNumber.toLowerCase().contains(q);
        final matchNumber = o.orderNumber.toLowerCase().contains(q);
        final matchItems = o.items.any(
          (item) => item.toLowerCase().contains(q),
        );
        return matchPatient || matchNumber || matchItems;
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(),
            const SizedBox(height: 14),

            // Search Bar & Filter Chips
            _buildSearchAndFilters(),

            // Order List Content
            Expanded(
              child: orders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderCard(order);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final totalOrders = _filteredOrders.length;

    return Container(
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
              Icons.receipt_long_rounded,
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
                  'Monitoring Order Poli',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Status resep, radiologi, dan billing',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$totalOrders Total',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Input
          Material(
            color: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(28),
            clipBehavior: Clip.antiAlias,
            child: TextField(
              controller: _searchController,
              cursorColor: const Color(0xFF00897B),
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari pasien / No. RM / No. order',
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
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
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

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _filterCategories.map((cat) {
                final isSelected = _selectedFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedFilter = cat),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00897B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00897B)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(MedicalOrder order) {
    final typeConfig = _getTypeConfig(order.type);
    final statusConfig = _getStatusConfig(order.status);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
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
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showOrderDetailSheet(order),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Type Pill & Order Number + Time
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeConfig.bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            typeConfig.icon,
                            size: 14,
                            color: typeConfig.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            order.typeLabel,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: typeConfig.color,
                            ),
                          ),
                        ],
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
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      order.orderTime.split(' ').first,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Patient Info Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE0F2FE),
                      child: Icon(
                        order.patient.gender == 'L'
                            ? Icons.face_rounded
                            : Icons.face_3_rounded,
                        color: const Color(0xFF0284C7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.patient.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'RM ${order.patient.mrNumber} • ${order.patient.age} th (${order.patient.gender})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: order.patient.insurance == 'BPJS'
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Item Order List preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: order.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Color(0xFF00897B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item,
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
                ),

                // Result Summary if available
                if (order.resultSummary != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF059669),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order.resultSummary!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF065F46),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom Status Pill & Action Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusConfig.bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusConfig.icon,
                            size: 14,
                            color: statusConfig.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            order.statusLabel,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: statusConfig.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PatientDetailScreen(patient: order.patient),
                          ),
                        );
                        if (mounted) setState(() {});
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Buka Rekam Medis',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00897B),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: Color(0xFF00897B),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetailSheet(MedicalOrder order) {
    final typeConfig = _getTypeConfig(order.type);
    final statusConfig = _getStatusConfig(order.status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Sheet Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeConfig.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        typeConfig.icon,
                        color: typeConfig.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Order ${order.typeLabel}',
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),

                // Status Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusConfig.bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusConfig.color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        statusConfig.icon,
                        color: statusConfig.color,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status: ${order.statusLabel}',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: statusConfig.color,
                              ),
                            ),
                            Text(
                              'Waktu Order: ${order.orderTime}',
                              style: TextStyle(
                                fontSize: 12,
                                color: statusConfig.color.withValues(
                                  alpha: 0.85,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Patient Info Card
                const Text(
                  'Informasi Pasien',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Nama Pasien', order.patient.name),
                      const SizedBox(height: 6),
                      _buildInfoRow('No. Rekam Medis', order.patient.mrNumber),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        'Usia / Gender',
                        '${order.patient.age} Tahun / ${order.patient.gender == 'L' ? 'Laki-laki' : 'Perempuan'}',
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow('Penjamin', order.patient.insurance),
                      if (order.patient.noSep != null) ...[
                        const SizedBox(height: 6),
                        _buildInfoRow('No. SEP BPJS', order.patient.noSep!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Items list
                Text(
                  'Item Permintaan / Resep (${order.items.length})',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: order.items.asMap().entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: const Color(0xFF00897B),
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // Clinical Notes
                if (order.clinicalNotes != null &&
                    order.clinicalNotes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Catatan Klinis Dokter',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      order.clinicalNotes!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF92400E),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],

                // Result Summary Section
                if (order.resultSummary != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Hasil Ekspertise Penunjang',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Text(
                      order.resultSummary!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Button to Go to Patient Detail
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PatientDetailScreen(patient: order.patient),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.assignment_ind_rounded, size: 20),
                    label: const Text(
                      'Buka Lembar Rekam Medis Pasien',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_rounded,
                color: Color(0xFF94A3B8),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada data order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tidak ada order yang sesuai dengan filter atau kata kunci pencarian.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  _TypeConfig _getTypeConfig(OrderType type) {
    switch (type) {
      case OrderType.radiology:
        return _TypeConfig(
          icon: Icons.biotech_rounded,
          color: const Color(0xFF9333EA),
          bgColor: const Color(0xFFF3E8FF),
        );
      case OrderType.medicine:
        return _TypeConfig(
          icon: Icons.local_pharmacy_rounded,
          color: const Color(0xFF0284C7),
          bgColor: const Color(0xFFE0F2FE),
        );
      case OrderType.lab:
        return _TypeConfig(
          icon: Icons.science_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
        );
      case OrderType.surgery:
        return _TypeConfig(
          icon: Icons.local_hospital_rounded,
          color: const Color(0xFFE11D48),
          bgColor: const Color(0xFFFFE4E6),
        );
      case OrderType.billing:
        return _TypeConfig(
          icon: Icons.receipt_long_rounded,
          color: const Color(0xFFEA580C),
          bgColor: const Color(0xFFFFEDD5),
        );
    }
  }

  _StatusConfig _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingRadiology:
        return _StatusConfig(
          icon: Icons.hourglass_top_rounded,
          color: const Color(0xFF9333EA),
          bgColor: const Color(0xFFF3E8FF),
        );
      case OrderStatus.pendingPharmacy:
        return _StatusConfig(
          icon: Icons.access_time_filled_rounded,
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
        );
      case OrderStatus.pendingLab:
        return _StatusConfig(
          icon: Icons.science_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
        );
      case OrderStatus.pendingSurgery:
        return _StatusConfig(
          icon: Icons.emergency_rounded,
          color: const Color(0xFFE11D48),
          bgColor: const Color(0xFFFFE4E6),
        );
      case OrderStatus.resultsReady:
        return _StatusConfig(
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
        );
      case OrderStatus.pendingBilling:
        return _StatusConfig(
          icon: Icons.payments_rounded,
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFDBEAFE),
        );
      case OrderStatus.completed:
        return _StatusConfig(
          icon: Icons.task_alt_rounded,
          color: const Color(0xFF475569),
          bgColor: const Color(0xFFF1F5F9),
        );
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  final Color bgColor;

  _TypeConfig({required this.icon, required this.color, required this.bgColor});
}

class _StatusConfig {
  final IconData icon;
  final Color color;
  final Color bgColor;

  _StatusConfig({
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}
