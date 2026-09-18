import 'package:flutter/material.dart';
import '../../../core/widgets/patient_header_card.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/dummy/dummy_orders.dart';

class LabOrderScreen extends StatefulWidget {
  final Patient patient;

  const LabOrderScreen({super.key, required this.patient});

  @override
  State<LabOrderScreen> createState() => _LabOrderScreenState();
}

class _LabOrderScreenState extends State<LabOrderScreen> {
  final Set<String> _selectedTests = {};
  final TextEditingController _notesController = TextEditingController();

  final Map<String, List<String>> _labCategories = {
    'Hematologi & Darah Lengkap': [
      'Darah Lengkap Otomatis (CBC)',
      'Laju Endap Darah (LED)',
      'Golongan Darah & Rhesus',
      'Masa Perdarahan / Pembekuan (CT/BT)',
    ],
    'Kimia Klinik & Diabetes': [
      'Gula Darah Sewaktu (GDS)',
      'Gula Darah Puasa (GDP)',
      'HbA1c (Hemoglobin Terglikasi)',
      'Ureum & Kreatinin (Fungsi Ginjal)',
      'SGOT & SGPT (Fungsi Hati)',
      'Asam Urat',
      'Profil Lipid (Kolesterol, HDL, LDL, Trigliserida)',
    ],
    'Urinalisis & Imunologi': [
      'Urin Lengkap & Sedimen',
      'Tes Kehamilan Urin (Plano Test)',
      'Widal Test',
      'HBsAg Kualitatif (Rapid)',
      'Dengue NS1 Antigen',
    ],
  };

  void _submitOrder() {
    if (_selectedTests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 jenis pemeriksaan laboratorium.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final newOrder = MedicalOrder(
      id: 'ord_lab_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'LAB/2026/09/${1000 + DummyOrders.list.length}',
      patient: widget.patient,
      type: OrderType.lab,
      items: _selectedTests.toList(),
      clinicalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      status: OrderStatus.pendingLab,
      orderTime: 'Baru saja',
    );

    DummyOrders.list.insert(0, newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order Laboratorium (${_selectedTests.length} tes) berhasil dikirim!'),
        backgroundColor: const Color(0xFF00897B),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Permintaan Laboratorium',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PatientHeaderCard(patient: widget.patient),
                  const SizedBox(height: 16),

                  const Text(
                    'Pilih Pemeriksaan Laboratorium',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 10),

                  // Kategori Lab & Checkbox
                  ..._labCategories.entries.map((category) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FBFE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2EEF8)),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        shape: const Border(),
                        title: Text(
                          category.key,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00897B),
                          ),
                        ),
                        children: category.value.map((testName) {
                          final isChecked = _selectedTests.contains(testName);
                          return CheckboxListTile(
                            dense: true,
                            activeColor: const Color(0xFF00897B),
                            title: Text(
                              testName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedTests.add(testName);
                                } else {
                                  _selectedTests.remove(testName);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),
                  const Text(
                    'Catatan Klinis / Indikasi',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8F1F8)),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Evaluasi DM tipe 2, Cek fungsi ginjal rutin',
                        hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar Submit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitOrder,
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    'Kirim Order Lab (${_selectedTests.length})',
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 