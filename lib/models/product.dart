// 📦 models/product.dart
class Product {
  String id;
  String name;
  String description;
  int price;
  String imageUrl;
  int quantity;
  bool selected;

  double alcoholPercent; // 🔹 Porcentaje de alcohol
  String? alcoholType; // 🔹 Tipo de licor (Ron, Whisky, etc.)

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.selected = false,
    this.alcoholPercent = 0.0,
    this.alcoholType,
  });

  // 📋 Copia exacta (incluye licor y porcentaje)
  factory Product.copy(Product p) => Product(
    id: p.id,
    name: p.name,
    description: p.description,
    price: p.price,
    imageUrl: p.imageUrl,
    quantity: p.quantity,
    selected: p.selected,
    alcoholPercent: p.alcoholPercent,
    alcoholType: p.alcoholType,
  );

  // 🔄 Crear desde JSON
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    price: json['price'] ?? 0,
    imageUrl: json['imageUrl'] ?? '',
    quantity: json['quantity'] ?? 1,
    selected: json['selected'] ?? false,
    alcoholPercent: (json['alcoholPercent'] is int)
        ? (json['alcoholPercent'] as int).toDouble()
        : (json['alcoholPercent'] ?? 0.0),
    alcoholType: json['alcoholType'],
  );

  // 🧩 Convertir a JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'selected': selected,
    'alcoholPercent': alcoholPercent,
    'alcoholType': alcoholType,
  };

  // ⚡ Identificador único extendido (evita duplicados por tipo o licor)
  String get uniqueKey =>
      '$id-${alcoholType ?? "SinLicor"}-${alcoholPercent.toStringAsFixed(1)}';

  // 💬 Texto breve para mostrar en WhatsApp o carrito
  String get resumenPedido {
    final tipo = alcoholType ?? "Sin alcohol";
    final grado = alcoholPercent > 0
        ? "${alcoholPercent.toStringAsFixed(1)}%"
        : "0%";
    return "$name\nLicor: $tipo | Alcohol: $grado\nPrecio: \$${price * quantity}";
  }
}
