class MedicineOrder {
  final String id;
  final String name;
  final String form; // Tablet, Kapsul
  final String dosage; // contoh: '3x1 setelah makan'
  final String category; // Generik, Non Generik
  final bool favorite;
  bool selected;

  MedicineOrder({
    required this.id,
    required this.name,
    required this.form,
    required this.dosage,
    required this.category,
    this.favorite = false,
    this.selected = false,
  });
}
