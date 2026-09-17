import 'patient.dart';

enum OrderType {
  radiology,
  medicine,
  billing,
}

enum OrderStatus {
  pendingRadiology,
  pendingPharmacy,
  resultsReady,
  pendingBilling,
  completed,
}

class MedicalOrder {
  final String id;
  final String orderNumber;
  final Patient patient;
  final OrderType type;
  final List<String> items;
  final String? clinicalNotes;
  final OrderStatus status;
  final String orderTime;
  final String? resultSummary;
  final String? doctorName;

  const MedicalOrder({
    required this.id,
    required this.orderNumber,
    required this.patient,
    required this.type,
    required this.items,
    this.clinicalNotes,
    required this.status,
    required this.orderTime,
    this.resultSummary,
    this.doctorName = 'dr. Sarah Wijaya, Sp.PD',
  });

  String get typeLabel {
    switch (type) {
      case OrderType.radiology:
        return 'Radiologi';
      case OrderType.medicine:
        return 'Resep Obat';
      case OrderType.billing:
        return 'Billing Kasir';
    }
  }

  String get statusLabel {
    switch (status) {
      case OrderStatus.pendingRadiology:
        return 'Antrean Radiologi';
      case OrderStatus.pendingPharmacy:
        return 'Diproses Farmasi';
      case OrderStatus.resultsReady:
        return 'Hasil Tersedia';
      case OrderStatus.pendingBilling:
        return 'Menunggu Kasir';
      case OrderStatus.completed:
        return 'Selesai';
    }
  }
}
