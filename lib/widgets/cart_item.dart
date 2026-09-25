// 📦 widgets/cart_item.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final ValueChanged<bool> onSelect;

  const CartItem({
    super.key,
    required this.product,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final tipoCompra = product.id.contains("pack") ? "Paquete (10u)" : "Unidad";

    return GestureDetector(
      onTap: () => _showProductDetails(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: const Color(0xFFFDF6EC),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Checkbox de selección
              Checkbox(
                value: product.selected,
                activeColor: Colors.brown.shade400,
                onChanged: (value) => onSelect(value ?? false),
              ),

              // 🖼 Imagen del producto
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.imageUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              // 📝 Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // 📦 Tipo de compra
                    Text(
                      "📦 Tipo: $tipoCompra",
                      style: TextStyle(
                        color: Colors.brown.shade600,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 🍪 Descripción corta
                    Text(
                      _shortDescription(),
                      style: TextStyle(
                        color: Colors.brown.shade700,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // 🎛 Controles
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.brown,
                        ),
                        tooltip: "Reducir cantidad",
                        onPressed: onDecrease,
                      ),
                      Text(
                        '${product.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.brown,
                        ),
                        tooltip: "Aumentar cantidad",
                        onPressed: onIncrease,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    tooltip: 'Eliminar producto',
                    onPressed: onRemove,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🧾 Descripción resumida con sabor, licor y % alcohol
  String _shortDescription() {
    final sabor = product.name.replaceFirst("Galleta ", "");
    final licor = product.alcoholType ?? "Sin alcohol";
    final alcohol = product.alcoholPercent.toStringAsFixed(1);
    return "Sabor: $sabor | Licor: $licor | Alcohol: $alcohol%";
  }

  // 🔍 Ventana emergente con detalle del producto
  void _showProductDetails(BuildContext context) {
    final tipoCompra = product.id.contains("pack") ? "Paquete (10u)" : "Unidad";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8E7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  product.imageUrl,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "📦 Tipo: $tipoCompra",
                style: TextStyle(
                  color: Colors.brown.shade700,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                _buildDescriptionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 14),
              Text(
                "Precio: \$${product.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "Eliminar del carrito",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onRemove();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📋 Descripción larga detallada
  String _buildDescriptionText() {
    final sabor = product.name.replaceFirst("Galleta ", "");
    final licor = product.alcoholType ?? "Sin alcohol";
    final alcohol = product.alcoholPercent.toStringAsFixed(1);
    return "Deliciosa galleta artesanal de sabor $sabor, preparada: $licor y un toque de $alcohol% de alcohol para realzar su sabor único.";
  }
}
