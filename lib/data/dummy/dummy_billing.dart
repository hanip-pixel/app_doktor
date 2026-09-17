import '../models/billing_item.dart';

class DummyBilling {
  static List<BillingGroup> get groups => [
        BillingGroup(
          category: 'Konsultasi Dokter',
          items: const [BillingItem(name: 'Jasa Dokter Spesialis', price: 150000)],
        ),
        BillingGroup(
          category: 'Tindakan',
          items: const [BillingItem(name: 'Pemeriksaan Fisik', price: 50000)],
        ),
        BillingGroup(
          category: 'Penunjang',
          items: const [BillingItem(name: 'Thorax AP/PA', price: 250000)],
        ),
        BillingGroup(
          category: 'Obat',
          items: const [
            BillingItem(name: 'Metformin 500 mg (30)', price: 15000),
            BillingItem(name: 'Amlodipine 5 mg (30)', price: 12000),
          ],
        ),
      ];
}
