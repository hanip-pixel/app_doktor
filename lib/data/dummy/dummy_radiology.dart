import '../models/radiology_order.dart';

class DummyRadiology {
  static List<RadiologyOrder> get list => [
        RadiologyOrder(id: 'r1', name: 'Thorax AP/PA', category: 'Konvensional', selected: true),
        RadiologyOrder(id: 'r2', name: 'Thorax Lateral', category: 'Konvensional'),
        RadiologyOrder(id: 'r3', name: 'Abdomen Polos', category: 'Konvensional'),
        RadiologyOrder(id: 'r4', name: 'CT Scan Kepala', category: 'CT Scan'),
        RadiologyOrder(id: 'r5', name: 'CT Scan Abdomen', category: 'CT Scan'),
        RadiologyOrder(id: 'r6', name: 'USG Abdomen', category: 'USG'),
        RadiologyOrder(id: 'r7', name: 'USG Tiroid', category: 'USG'),
        RadiologyOrder(id: 'r8', name: 'MRI Lumbal', category: 'MRI'),
      ];

  static const List<String> filters = ['Semua', 'Konvensional', 'CT Scan', 'USG', 'MRI'];
}
