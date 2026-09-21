class ServiceItem {
  final String id;
  final String name;
  final String code;
  final ServiceStandard standard;
  final int? price;
  final String category;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.code,
    required this.standard,
    this.price,
    required this.category,
  });
}

enum ServiceStandard { kris, nonKris }

extension ServiceStandardX on ServiceStandard {
  String get label => this == ServiceStandard.kris ? 'KRIS' : 'NON-KRIS';
}

class BillingItem {
  final String name;
  final int price;

  const BillingItem({required this.name, required this.price});
}

class BillingGroup {
  final String category;
  final List<BillingItem> items;
  bool checked;

  BillingGroup({
    required this.category,
    required this.items,
    this.checked = true,
  });

  int get subtotal => items.fold(0, (sum, item) => sum + item.price);
}
