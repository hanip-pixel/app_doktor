import '../models/medicine_order.dart';

class DummyMedicines {
  static List<MedicineOrder> get list => [
    MedicineOrder(
      id: 'm1',
      name: 'Metformin 500 mg',
      form: 'Tablet',
      dosage: '3x1 setelah makan',
      category: 'Generik',
      favorite: true,
    ),
    MedicineOrder(
      id: 'm2',
      name: 'Amlodipine 5 mg',
      form: 'Tablet',
      dosage: '1x1 pagi',
      category: 'Generik',
      favorite: true,
    ),
    MedicineOrder(
      id: 'm3',
      name: 'Simvastatin 20 mg',
      form: 'Tablet',
      dosage: '1x1 malam',
      category: 'Generik',
      favorite: true,
    ),
    MedicineOrder(
      id: 'm4',
      name: 'Omeprazole 20 mg',
      form: 'Kapsul',
      dosage: '1x1 pagi',
      category: 'Non Generik',
      favorite: true,
    ),
    MedicineOrder(
      id: 'm5',
      name: 'Paracetamol 500 mg',
      form: 'Tablet',
      dosage: '3x1 bila demam',
      category: 'Generik',
      favorite: true,
    ),
    MedicineOrder(
      id: 'm6',
      name: 'Cefixime 200 mg',
      form: 'Kapsul',
      dosage: '2x1 setelah makan',
      category: 'Non Generik',
      favorite: false,
    ),
    MedicineOrder(
      id: 'm7',
      name: 'Cetirizine 10 mg',
      form: 'Tablet',
      dosage: '1x1 malam',
      category: 'Generik',
      favorite: false,
    ),
  ];

  static const List<String> filters = [
    'Favorit',
    'Semua Obat',
    'Generik',
    'Non Generik',
  ];
}
