import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  static const List<double> _alcoholPercents = <double>[
    0.0,
    2.0,
    3.0,
    4.0,
    5.0,
  ];

  double _selectedAlcoholPercent = 0.0;
  bool _isPack = false;

  @override
  void initState() {
    super.initState();
    _selectedAlcoholPercent = widget.product.alcoholPercent > 0
        ? widget.product.alcoholPercent
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final displayedPrice = _isPack ? 110000 : widget.product.price.toDouble();
    final hasAlcohol =
        (widget.product.alcoholType != null &&
        widget.product.alcoholType!.isNotEmpty &&
        widget.product.alcoholPercent > 0);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFFDF6EC),
      shadowColor: Colors.brown.shade300,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🖼 Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.product.imageUrl,
                height: isMobile ? 140 : 150, // un poco más alta
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),

            // 🍪 Nombre
            Text(
              widget.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.brown,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 6),

            // 📄 Descripción
            Text(
              widget.product.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.brown.shade700,
                fontSize: 13.5,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),

            // 💰 Precio visible dinámico
            Text(
              "\$${displayedPrice.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // 🥃 Info de licor (tipo fijo) + % Alc (editable solo si aplica)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Licor: ${widget.product.alcoholType ?? 'Sin alcohol'}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                hasAlcohol
                    ? _buildDropdown<double>(
                        label: '% Alc',
                        value: _selectedAlcoholPercent,
                        items: _alcoholPercents.where((p) => p > 0).toList(),
                        itemBuilder: (p) => '${p.toStringAsFixed(0)}%',
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() => _selectedAlcoholPercent = val);
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                          color: Colors.white,
                        ),
                        child: Text(
                          "% Alc: 0%",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
              ],
            ),

            const SizedBox(height: 12),

            // 🧁 Selector de compra (unidad o paquete)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Unidad"),
                  selected: !_isPack,
                  selectedColor: Colors.brown.shade400,
                  labelStyle: TextStyle(
                    color: !_isPack ? Colors.white : Colors.brown.shade800,
                  ),
                  onSelected: (_) => setState(() => _isPack = false),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Paquete (10u – \$110000)"),
                  selected: _isPack,
                  selectedColor: Colors.brown.shade400,
                  labelStyle: TextStyle(
                    color: _isPack ? Colors.white : Colors.brown.shade800,
                    fontSize: 12,
                  ),
                  onSelected: (_) => setState(() => _isPack = true),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 🛒 Botón agregar
            SizedBox(
              height: 44, // altura fija estable
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  _isPack ? "Agregar paquete" : "Agregar unidad",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                onPressed: () {
                  final updated = Product.copy(widget.product)
                    ..alcoholPercent = hasAlcohol
                        ? _selectedAlcoholPercent
                        : 0.0
                    ..price = _isPack ? 110000 : widget.product.price;

                  final String pct =
                      (hasAlcohol ? _selectedAlcoholPercent : 0.0)
                          .toStringAsFixed(1);

                  updated.id =
                      "${widget.product.id}_${widget.product.alcoholType ?? 'SinAlcohol'}_${pct}_${_isPack ? 'pack' : 'unit'}";

                  widget.onAddToCart(updated);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔽 Dropdown genérico solo para % Alc
  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    String Function(T)? itemBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown.shade700, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemBuilder != null ? itemBuilder(item) : item.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
