import '../models/medical_order.dart';
import 'dummy_patients.dart';

class DummyOrders {
  // Static mutable list so new orders dynamically persist across app session
  static final List<MedicalOrder> list = [
    // Order milik Budi Santoso (inProgress) - Hasil Radiologi Siap
    MedicalOrder(
      id: 'ord_1',
      orderNumber: 'RAD/2026/09/0014',
      patient: DummyPatients.todayList[0], // Budi Santoso
      type: OrderType.radiology,
      items: const ['Thorax AP/PA', 'Abdomen Polos (BNO)'],
      clinicalNotes: 'Evaluasi kondisi paru & cor, curiga kardiomegali.',
      status: OrderStatus.resultsReady,
      orderTime: '08:45 WIB (15 mnt lalu)',
      resultSummary: 'Ekspertise Sp.Rad: Cor membesar (CTR 54%), pulmo tidak tampak infiltrat aktif/efusi pleura.',
    ),

    // Order milik Budi Santoso (inProgress) - Resep Sedang Diproses Farmasi
    MedicalOrder(
      id: 'ord_2',
      orderNumber: 'RSP/2026/09/0088',
      patient: DummyPatients.todayList[0], // Budi Santoso
      type: OrderType.medicine,
      items: const [
        'Metformin 500 mg (3x1 sesudah makan)',
        'Amlodipine 5 mg (1x1 pagi)',
        'Omeprazole 20 mg (1x1 sebelum makan)',
      ],
      clinicalNotes: 'Resep kronis 30 hari + edukasi ketaatan minum obat.',
      status: OrderStatus.pendingPharmacy,
      orderTime: '09:10 WIB (35 mnt lalu)',
    ),

    // Order milik Maya Indah (done) - Selesai & Masuk Billing
    MedicalOrder(
      id: 'ord_3',
      orderNumber: 'BIL/2026/09/0039',
      patient: DummyPatients.todayList[5], // Maya Indah
      type: OrderType.billing,
      items: const [
        'Konsultasi Spesialis Penyakit Dalam',
        'Paket Obat GERD & Sukralfat Sirup',
      ],
      clinicalNotes: 'Klaim Rawat Jalan BPJS.',
      status: OrderStatus.completed,
      orderTime: '07:45 WIB (2 jam lalu)',
    ),

    // Order milik Hendra Wijaya (done) - Radiologi Selesai
    MedicalOrder(
      id: 'ord_4',
      orderNumber: 'RAD/2026/09/0009',
      patient: DummyPatients.todayList[6], // Hendra Wijaya
      type: OrderType.radiology,
      items: const ['Thorax PA Dewasa'],
      clinicalNotes: 'Batuk > 2 minggu, suspek bronkitis/TB.',
      status: OrderStatus.completed,
      orderTime: '07:30 WIB (2.5 jam lalu)',
      resultSummary: 'Ekspertise Sp.Rad: Cor dan pulmo dalam batas normal. Tidak tampak sarang spesifik aktif.',
    ),
  ];

  static void addOrder(MedicalOrder order) {
    list.insert(0, order);
  }

  static List<MedicalOrder> getOrdersByPatient(String patientId) {
    return list.where((o) => o.patient.id == patientId).toList();
  }

  static int get pendingCount => list
      .where((o) =>
          o.status == OrderStatus.pendingPharmacy ||
          o.status == OrderStatus.pendingRadiology ||
          o.status == OrderStatus.pendingBilling)
      .length;

  static int get newResultsCount =>
      list.where((o) => o.status == OrderStatus.resultsReady).length;
}
