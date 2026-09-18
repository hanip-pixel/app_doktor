import 'patient.dart';

enum OrderType {
  radiology,
  medicine,
  lab,
  surgery,
  billing,
}

enum OrderStatus {
  pendingRadiology,
  pendingPharmacy,
  pendingLab,
  pendingSurgery,
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
      case OrderType.lab:
        return 'Laboratorium';
      case OrderType.surgery:
        return 'Kamar Operasi (OK)';
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
      case OrderStatus.pendingLab:
        return 'Diproses Laboratorium';
      case OrderStatus.pendingSurgery:
        return 'Penjadwalan OK';
      case OrderStatus.resultsReady:
        return 'Hasil Tersedia';
      case OrderStatus.pendingBilling:
        return 'Menunggu Kasir';
      case OrderStatus.completed:
        return 'Selesai';
    }
  }
}