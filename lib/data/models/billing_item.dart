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
