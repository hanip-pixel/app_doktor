import 'package:flutter/material.dart';

import '../../../data/dummy/dummy_billing.dart';
import '../../../data/dummy/dummy_patients.dart';
import '../../../data/models/billing_item.dart';
import '../../../data/models/patient.dart';
import '../widgets/patient_service_header_widget.dart';
import '../widgets/selected_service_tile.dart';
import '../widgets/service_search_bottom_sheet.dart';

class BillingScreen extends StatefulWidget {
  final Patient patient;

  const BillingScreen({super.key, required this.patient});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late final List<ServiceItem> _masterServices;
  final List<ServiceItem> _selectedServices = [];
  ServiceStandard _selectedStandard = ServiceStandard.kris;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _masterServices = DummyBilling.serviceCatalog;
    _selectedServices.addAll(widget.patient.services);
  }

  int get _totalPrice =>
      _selectedServices.fold(0, (sum, item) => sum + (item.price ?? 0));

  String _formatRupiah(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final posFromRight = str.length - i;
      buffer.write(str[i]);
      if (posFromRight > 1 && posFromRight % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  Future<void> _openServicePicker() async {
    final selected = await showModalBottomSheet<ServiceItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ServiceSearchBottomSheet(
        services: _masterServices,
        selectedServices: _selectedServices,
        selectedStandard: _selectedStandard,
        formatCurrency: _formatRupiah,
      ),
    );

    if (selected == null || !mounted) return;
    if (_selectedServices.any((item) => item.id == selected.id)) return;

    setState(() {
      _selectedServices.add(selected);
      _selectedStandard = selected.standard;
    });
  }

  Future<void> _saveServices() async {
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu tindakan medis terlebih dahulu.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final updatedPatient = widget.patient.copyWith(
      services: List.from(_selectedServices),
    );
    final idx = DummyPatients.todayList.indexWhere((p) => p.id == widget.patient.id);
    if (idx != -1) {
      DummyPatients.todayList[idx] = updatedPatient;
    }

    setState(() => _isSubmitting = false);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedServices.length} jasa layanan berhasil disimpan (${_formatRupiah(_totalPrice)}).',
        ),
        backgroundColor: const Color(0xFF00897B),
      ),
    );

    Navigator.pop(context, updatedPatient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildStickyFooter(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                children: [
                  PatientServiceHeaderWidget(patient: widget.patient),
                  const SizedBox(height: 16),
                  _buildAddServiceButton(),
                  const SizedBox(height: 18),
                  _buildSelectedSectionHeader(),
                  const SizedBox(height: 10),
                  if (_selectedServices.isEmpty)
                    _buildEmptyState()
                  else
                    _buildSelectedServicesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
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
          const Expanded(
            child: Text(
              'Jasa Layanan',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddServiceButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _openServicePicker,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
        label: const Text(
          'Cari / Tambah Tindakan Medis',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSelectedSectionHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Daftar Tindakan Terpilih',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        Text(
          '${_selectedServices.length} item',
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedServicesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _selectedServices.length,
      itemBuilder: (context, index) {
        final service = _selectedServices[index];
        return SelectedServiceTile(
          service: service,
          formatCurrency: _formatRupiah,
          onDelete: () => setState(() => _selectedServices.removeAt(index)),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.playlist_add_rounded,
              color: Color(0xFF00897B),
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada tindakan dipilih',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tambahkan jenis layanan, tindakan medis, atau paket MCU dari master data dummy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedServices.length} item dipilih',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  _formatRupiah(_totalPrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF00897B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _saveServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Simpan Jasa Layanan',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
