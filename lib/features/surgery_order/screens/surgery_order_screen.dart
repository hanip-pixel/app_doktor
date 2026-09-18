import 'package:flutter/material.dart';
import '../../../core/widgets/patient_header_card.dart';
import '../../../data/models/patient.dart';
import '../../../data/models/medical_order.dart';
import '../../../data/dummy/dummy_orders.dart';

class SurgeryOrderScreen extends StatefulWidget {
  final Patient patient;

  const SurgeryOrderScreen({super.key, required this.patient});

  @override
  State<SurgeryOrderScreen> createState() => _SurgeryOrderScreenState();
}

class _SurgeryOrderScreenState extends State<SurgeryOrderScreen> {
  String _surgeryType = 'Apendektomi Laparoskopi / Open';
  String _urgency = 'Elektif'; // 'Elektif' atau 'Cito'
  String _operatorDoctor = 'dr. Hendra Gunawan, Sp.B';
  String _operatingRoom = 'Kamar Bedah Mayor 1 (OK-1)';
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _scheduledTime = const TimeOfDay(hour: 9, minute: 0);
  final TextEditingController _notesController = TextEditingController();

  final List<String> _surgeryList = [
    'Apendektomi Laparoskopi / Open',
    'Herniorafi / Herniotomi Inguinalis',
    'Kolesistektomi (Pengangkatan Batu Empedu)',
    'Debridement Luka / Ulkus Diabetikum',
    'Eksisi Tumor Jinak / Lipoma / Kista',
    'Sectio Caesarea (SC)',
    'Laparotomi Eksplorasi Akut',
    'ORIF Pasang Pen Fraktur Tulang',
  ];

  void _submitOrder() {
    final newOrder = MedicalOrder(
      id: 'ord_ok_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'OK/2026/09/${1000 + DummyOrders.list.length}',
      patient: widget.patient,
      type: OrderType.surgery,
      items: [
        'Tindakan: $_surgeryType',
        'Sifat: Sifat $_urgency',
        'Jadwal: ${_scheduledDate.day}/${_scheduledDate.month}/${_scheduledDate.year} jam ${_scheduledTime.format(context)}',
        'Ruang: $_operatingRoom',
        'Operator: $_operatorDoctor',
      ],
      clinicalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      status: OrderStatus.pendingSurgery,
      orderTime: 'Baru saja',
    );

    DummyOrders.list.insert(0, newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Jadwal Kamar Operasi (OK) berhasil dikirim ke Instalasi Bedah!'),
        backgroundColor: const Color(0xFFE11D48),
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
          'Order Kamar Operasi (OK)',
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

                  // Sifat Operasi (Elektif vs Cito)
                  const Text('Urgensi Tindakan', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUrgencyCard('Elektif', 'Terencana', Icons.event_available_rounded, const Color(0xFF00897B)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildUrgencyCard('Cito', 'Darurat / Segera', Icons.warning_amber_rounded, const Color(0xFFE11D48)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tindakan Operasi
                  const Text('Rencana Tindakan Bedah', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8F1F8)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _surgeryType,
                        items: _surgeryList.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (val) => setState(() => _surgeryType = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dokter Operator
                  const Text('Dokter Operator Spesialis Bedah', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FBFE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8F1F8)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _operatorDoctor,
                        items: const [
                          DropdownMenuItem(value: 'dr. Hendra Gunawan, Sp.B', child: Text('dr. Hendra Gunawan, Sp.B (Bedah Umum)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'dr. Anita Rahma, Sp.B-KBD', child: Text('dr. Anita Rahma, Sp.B-KBD (Bedah Digestif)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'dr. Farhan, Sp.OT', child: Text('dr. Farhan, Sp.OT (Bedah Orthopedi)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'dr. Rina Puspita, Sp.OG', child: Text('dr. Rina Puspita, Sp.OG (Kebidanan & Kandungan)', style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (val) => setState(() => _operatorDoctor = val!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Rencana Tanggal & Jam
                  const Text('Waktu Pelaksanaan Operasi', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _scheduledDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (date != null) setState(() => _scheduledDate = date);
                          },
                          icon: const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFF00897B)),
                          label: Text('${_scheduledDate.day}/${_scheduledDate.month}/${_scheduledDate.year}', style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _scheduledTime,
                            );
                            if (time != null) setState(() => _scheduledTime = time);
                          },
                          icon: const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF00897B)),
                          label: Text(_scheduledTime.format(context), style: const TextStyle(fontSize: 12.5, color: Color(0xFF0F172A))),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Catatan Khusus & Persiapan
                  const Text('Catatan & Persiapan Pre-Operasi', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
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
                        hintText: 'Contoh: Puasa 6 jam pre-op, Siapkan 2 kantong PRC, Konsul Anestesi',
                        hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _submitOrder,
                  icon: const Icon(Icons.local_hospital_rounded, size: 18),
                  label: const Text('Kirim Jadwal ke Kamar Bedah (OK)', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE11D48),
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

  Widget _buildUrgencyCard(String label, String subtitle, IconData icon, Color color) {
    final isSelected = _urgency == label;
    return InkWell(
      onTap: () => setState(() => _urgency = label),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : const Color(0xFFE2E8F0), width: isSelected ? 1.8 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : const Color(0xFF64748B), size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? color : const Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}