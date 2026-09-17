class RadiologyOrder {
  final String id;
  final String name;
  final String category; // Konvensional, CT Scan, USG, MRI
  bool selected;

  RadiologyOrder({
    required this.id,
    required this.name,
    required this.category,
    this.selected = false,
  });
}
