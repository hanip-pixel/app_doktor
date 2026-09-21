import 'package:flutter/material.dart';

import '../../../data/models/billing_item.dart';
import 'service_standard_badge.dart';

class ServiceSearchBottomSheet extends StatefulWidget {
  final List<ServiceItem> services;
  final List<ServiceItem> selectedServices;
  final ServiceStandard selectedStandard;
  final String Function(int value) formatCurrency;

  const ServiceSearchBottomSheet({
    super.key,
    required this.services,
    required this.selectedServices,
    required this.selectedStandard,
    required this.formatCurrency,
  });

  @override
  State<ServiceSearchBottomSheet> createState() =>
      _ServiceSearchBottomSheetState();
}

class _ServiceSearchBottomSheetState extends State<ServiceSearchBottomSheet> {
  late ServiceStandard _standard;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _standard = widget.selectedStandard;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceItem> get _filteredServices {
    final keyword = _searchController.text.trim().toLowerCase();
    return widget.services.where((service) {
      final matchesStandard = service.standard == _standard;
      final matchesKeyword =
          keyword.isEmpty ||
          service.name.toLowerCase().contains(keyword) ||
          service.code.toLowerCase().contains(keyword) ||
          service.category.toLowerCase().contains(keyword);
      return matchesStandard && matchesKeyword;
    }).toList();
  }

  bool _isSelected(ServiceItem service) {
    return widget.selectedServices.any((item) => item.id == service.id);
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = _filteredServices;
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = mediaQuery.size.height * 0.86;

    return SafeArea(
      child: SizedBox(
        height: availableHeight,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: mediaQuery.viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cari Tindakan Medis',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SegmentedButton<ServiceStandard>(
                segments: ServiceStandard.values
                    .map(
                      (standard) => ButtonSegment<ServiceStandard>(
                        value: standard,
                        label: Text(standard.label),
                      ),
                    )
                    .toList(),
                selected: {_standard},
                onSelectionChanged: (selected) {
                  setState(() => _standard = selected.first);
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.selected)
                        ? const Color(0xFF00897B)
                        : const Color(0xFF475569);
                  }),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari nama, kode, atau kategori layanan',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF00897B),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredServices.isEmpty
                    ? const Center(
                        child: Text(
                          'Layanan tidak ditemukan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: false,
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredServices.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        itemBuilder: (context, index) {
                          final service = filteredServices[index];
                          final selected = _isSelected(service);
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            title: Text(
                              service.name,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: selected
                                    ? const Color(0xFF00897B)
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    service.code,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  ServiceStandardBadge(
                                    standard: service.standard,
                                  ),
                                  Text(
                                    service.price == null
                                        ? 'Tarif menyesuaikan'
                                        : widget.formatCurrency(service.price!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF00897B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Icon(
                              selected
                                  ? Icons.check_circle_rounded
                                  : Icons.add_circle_outline_rounded,
                              color: selected
                                  ? const Color(0xFF00897B)
                                  : const Color(0xFF94A3B8),
                            ),
                            onTap: selected
                                ? null
                                : () => Navigator.pop(context, service),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
