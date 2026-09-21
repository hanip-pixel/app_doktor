import '../models/billing_item.dart';

class DummyBilling {
  static List<ServiceItem> get serviceCatalog => const [
    ServiceItem(
      id: 'svc-001',
      name: 'Konsultasi Dokter Spesialis Penyakit Dalam',
      code: 'KON-SPPD-001',
      standard: ServiceStandard.kris,
      price: 150000,
      category: 'Konsultasi',
    ),
    ServiceItem(
      id: 'svc-002',
      name: 'Pemeriksaan Fisik Lengkap Poliklinik',
      code: '89.7',
      standard: ServiceStandard.kris,
      price: 50000,
      category: 'Tindakan Medis',
    ),
    ServiceItem(
      id: 'svc-003',
      name: 'Elektrokardiogram (EKG 12-Lead)',
      code: '89.52',
      standard: ServiceStandard.nonKris,
      price: 125000,
      category: 'Tindakan Medis',
    ),
    ServiceItem(
      id: 'svc-004',
      name: 'Nebulisasi Dewasa',
      code: 'TIN-NEB-001',
      standard: ServiceStandard.kris,
      price: 85000,
      category: 'Tindakan Medis',
    ),
    ServiceItem(
      id: 'svc-005',
      name: 'Injeksi Intravena / Intramuskular',
      code: 'TIN-INJ-001',
      standard: ServiceStandard.kris,
      price: 35000,
      category: 'Tindakan Medis',
    ),
    ServiceItem(
      id: 'svc-006',
      name: 'Paket MCU Basic',
      code: 'MCU-BASIC',
      standard: ServiceStandard.nonKris,
      price: 450000,
      category: 'Paket MCU',
    ),
    ServiceItem(
      id: 'svc-007',
      name: 'Paket MCU Executive',
      code: 'MCU-EXEC',
      standard: ServiceStandard.nonKris,
      price: 1250000,
      category: 'Paket MCU',
    ),
    ServiceItem(
      id: 'svc-008',
      name: 'Perawatan Luka Ringan',
      code: 'TIN-LUKA-001',
      standard: ServiceStandard.kris,
      price: 95000,
      category: 'Tindakan Medis',
    ),
    ServiceItem(
      id: 'svc-009',
      name: 'Konseling Gizi Singkat',
      code: 'KON-GIZI-001',
      standard: ServiceStandard.nonKris,
      price: 75000,
      category: 'Konsultasi',
    ),
    ServiceItem(
      id: 'svc-010',
      name: 'Observasi Pasien Rawat Jalan',
      code: 'OBS-RJ-001',
      standard: ServiceStandard.kris,
      price: null,
      category: 'Observasi',
    ),
  ];

  static List<BillingGroup> get groups => [
    BillingGroup(
      category: 'Konsultasi Dokter',
      items: const [BillingItem(name: 'Jasa Dokter Spesialis', price: 150000)],
    ),
    BillingGroup(
      category: 'Tindakan',
      items: const [BillingItem(name: 'Pemeriksaan Fisik', price: 50000)],
    ),
  ];
}
