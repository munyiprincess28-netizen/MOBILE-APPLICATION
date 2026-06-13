class StationeryItem {
  int? id;
  String name;
  String category;
  int quantity;
  double price;
  String description;
  DateTime dateAdded;

  StationeryItem({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    required this.description,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
      'description': description,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory StationeryItem.fromMap(Map<String, dynamic> map) {
    return StationeryItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      quantity: map['quantity'],
      price: map['price'],
      description: map['description'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}