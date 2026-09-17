import '../models/medical_order.dart';
import 'dummy_patients.dart';

class DummyOrders {
  // Static mutable list so new orders dynamically persist across app session
  // Data disinkronkan 100% dengan Daftar Pasien Poli Hari Ini
  static final List<MedicalOrder> list = [
    // -------------------------------------------------------------
    // 1. Tn. Budi Santoso (p1) - Status: Sedang Diperiksa (inProgress)
    // Skenario: Pasien di ruang periksa, hasil rontgen baru saja selesai keluar dari Radiologi.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_1',
      orderNumber: 'RAD/2026/09/0014',
      patient: DummyPatients.todayList[0], // Budi Santoso
      type: OrderType.radiology,
      items: const ['Thorax AP/PA', 'Abdomen Polos (BNO)'],
      clinicalNotes: 'Evaluasi kondisi paru & cor, curiga kardiomegali.',
      status: OrderStatus.resultsReady,
      orderTime: '08:45 WIB (15 mnt lalu)',
      resultSummary:
          'Ekspertise Sp.Rad: Cor membesar (CTR 54%), pulmo tidak tampak infiltrat aktif/efusi pleura.',
    ),

    // -------------------------------------------------------------
    // 2. Ny. Siti Aminah (p2) - Status: Sedang Diperiksa (inProgress)
    // Skenario: Dokter mengirim permintaan USG & BNO Abdomen, pasien sedang dalam antrean di Instalasi Radiologi.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_rad_pending',
      orderNumber: 'RAD/2026/09/0015',
      patient: DummyPatients.todayList[1], // Siti Aminah
      type: OrderType.radiology,
      items: const [
        'USG Abdomen Upper-Lower',
        'Foto Polos Abdomen (BNO) 3 Posisi',
      ],
      clinicalNotes:
          'Nyeri perut kanan bawah akut, evaluasi suspek appendicitis / nefrolitiasis.',
      status: OrderStatus.pendingRadiology,
      orderTime: '08:50 WIB (10 mnt lalu)',
    ),

    // -------------------------------------------------------------
    // 3. Ny. Maya Indah (p6) - Status: Selesai (done)
    // Skenario: Pemeriksaan selesai, resep obat GERD sedang diracik di Instalasi Farmasi.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_2',
      orderNumber: 'RSP/2026/09/0088',
      patient: DummyPatients.todayList[5], // Maya Indah
      type: OrderType.medicine,
      items: const [
        'Omeprazole 20 mg (2x1 ac)',
        'Sukralfat Sirup 500mg/5ml (3x1 C)',
        'Antasida DOEN Tab (3x1 ac)',
      ],
      clinicalNotes: 'Resep obat rawat jalan GERD & Gastritis akut.',
      status: OrderStatus.pendingPharmacy,
      orderTime: '07:10 WIB (45 mnt lalu)',
    ),

    // -------------------------------------------------------------
    // 3. Tn. Hendra Wijaya (p7) - Status: Selesai (done)
    // Skenario: Pemeriksaan batuk selesai, rontgen & resep antibiotik selesai diproses.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_3',
      orderNumber: 'RAD/2026/09/0009',
      patient: DummyPatients.todayList[6], // Hendra Wijaya
      type: OrderType.radiology,
      items: const ['Thorax PA Dewasa'],
      clinicalNotes: 'Batuk > 2 minggu, evaluasi bronkitis/TB.',
      status: OrderStatus.completed,
      orderTime: '07:25 WIB (1.5 jam lalu)',
      resultSummary:
          'Ekspertise Sp.Rad: Cor dan pulmo dalam batas normal. Tidak tampak sarang spesifik aktif.',
    ),
    MedicalOrder(
      id: 'ord_3_med',
      orderNumber: 'RSP/2026/09/0071',
      patient: DummyPatients.todayList[6], // Hendra Wijaya
      type: OrderType.medicine,
      items: const [
        'Ambroxol 30 mg (3x1 sesudah makan)',
        'Cefixime 200 mg (2x1 sesudah makan)',
      ],
      clinicalNotes: 'Terapi bronkitis akut.',
      status: OrderStatus.completed,
      orderTime: '07:28 WIB (1.5 jam lalu)',
    ),

    // -------------------------------------------------------------
    // 4. Ny. Dewi Lestari (p8) - Status: Selesai (done)
    // Skenario: Pemeriksaan selesai, berkas masuk ke Billing/Kasir Umum.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_4_bil',
      orderNumber: 'BIL/2026/09/0042',
      patient: DummyPatients.todayList[7], // Dewi Lestari
      type: OrderType.billing,
      items: const [
        'Konsultasi Dokter Spesialis Penyakit Dalam / Saraf',
        'Paket Obat Migrain (Betahistine 6mg, Flunarizine 5mg)',
      ],
      clinicalNotes: 'Klaim Billing Pasien Rawat Jalan Umum.',
      status: OrderStatus.pendingBilling,
      orderTime: '07:40 WIB (2 jam lalu)',
    ),
    MedicalOrder(
      id: 'ord_4_med',
      orderNumber: 'RSP/2026/09/0075',
      patient: DummyPatients.todayList[7], // Dewi Lestari
      type: OrderType.medicine,
      items: const [
        'Betahistine Mesylate 6 mg (3x1 sesudah makan)',
        'Flunarizine 5 mg (1x1 malam)',
      ],
      clinicalNotes: 'Terapi migrain dan vertigo.',
      status: OrderStatus.completed,
      orderTime: '07:38 WIB (2 jam lalu)',
    ),

    // -------------------------------------------------------------
    // 5. Tn. Bambang Pamungkas (p9) - Status: Selesai (done)
    // Skenario: Pemeriksaan osteoartritis lutut selesai, rontgen & obat selesai.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_5_rad',
      orderNumber: 'RAD/2026/09/0004',
      patient: DummyPatients.todayList[8], // Bambang Pamungkas
      type: OrderType.radiology,
      items: const ['Genu Bilateral AP/Lateral'],
      clinicalNotes: 'Nyeri sendi lutut bilateral, suspek OA Genu.',
      status: OrderStatus.completed,
      orderTime: '07:48 WIB (2.5 jam lalu)',
      resultSummary:
          'Ekspertise Sp.Rad: Penyempitan celah sendi medial genu bilateral grade 2 (Osteoartritis).',
    ),
    MedicalOrder(
      id: 'ord_5_med',
      orderNumber: 'RSP/2026/09/0064',
      patient: DummyPatients.todayList[8], // Bambang Pamungkas
      type: OrderType.medicine,
      items: const [
        'Meloxicam 7.5 mg (2x1 sesudah makan)',
        'Glucosamine 500 mg (1x1)',
      ],
      clinicalNotes: 'Terapi OA genu.',
      status: OrderStatus.completed,
      orderTime: '07:50 WIB (2.5 jam lalu)',
    ),

    // -------------------------------------------------------------
    // 6. Nn. Nurul Hidayah (p10) - Status: Selesai (done)
    // Skenario: Pemeriksaan alergi makanan/urtikaria selesai.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_6_med',
      orderNumber: 'RSP/2026/09/0060',
      patient: DummyPatients.todayList[9], // Nurul Hidayah
      type: OrderType.medicine,
      items: const [
        'Cetirizine 10 mg (1x1 malam)',
        'Deksametason 0.5 mg (3x1 sesudah makan)',
      ],
      clinicalNotes: 'Antihistamin & antiinflamasi alergi makanan.',
      status: OrderStatus.completed,
      orderTime: '07:52 WIB (2.5 jam lalu)',
    ),

    // -------------------------------------------------------------
    // 7. Tn. Ahmad Fauzi (p11) - Status: Selesai (done)
    // Skenario: Kontrol rutin kolesterol/dislipidemia selesai.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_7_med',
      orderNumber: 'RSP/2026/09/0055',
      patient: DummyPatients.todayList[10], // Ahmad Fauzi
      type: OrderType.medicine,
      items: const [
        'Atorvastatin 20 mg (1x1 malam)',
      ],
      clinicalNotes: 'Terapi hiperkolesterolemia murni 30 hari.',
      status: OrderStatus.completed,
      orderTime: '07:55 WIB (2.5 jam lalu)',
    ),

    // -------------------------------------------------------------
    // 8. Ny. Sri Wahyuni (p12) - Status: Selesai (done)
    // Skenario: Pemeriksaan LBP selesai, rontgen lumbal & obat selesai.
    // -------------------------------------------------------------
    MedicalOrder(
      id: 'ord_8_rad',
      orderNumber: 'RAD/2026/09/0002',
      patient: DummyPatients.todayList[11], // Sri Wahyuni
      type: OrderType.radiology,
      items: const ['Vertebra Lumbal AP/Lateral'],
      clinicalNotes: 'Nyeri punggung bawah menjalar (LBP).',
      status: OrderStatus.completed,
      orderTime: '07:58 WIB (3 jam lalu)',
      resultSummary:
          'Ekspertise Sp.Rad: Spondylosis lumbalis L3-L5 dengan spurring anterior. Diskus intervertebralis normal.',
    ),
    MedicalOrder(
      id: 'ord_8_med',
      orderNumber: 'RSP/2026/09/0052',
      patient: DummyPatients.todayList[11], // Sri Wahyuni
      type: OrderType.medicine,
      items: const [
        'Eperisone HCl 50 mg (3x1 sesudah makan)',
        'Natrium Diklofenak 50 mg (2x1 sesudah makan)',
      ],
      clinicalNotes: 'Muscle relaxant & NSAID untuk LBP.',
      status: OrderStatus.completed,
      orderTime: '08:00 WIB (3 jam lalu)',
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
