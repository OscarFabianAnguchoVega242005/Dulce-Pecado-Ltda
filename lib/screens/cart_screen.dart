// 📦 screens/cart_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;
  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> _cart = []; // ✅ Inicializado directamente

  /// 🟢 mi número de WhatsApp
  final String _whatsappNumber = "573025129990";

  @override
  void initState() {
    super.initState();
    _cart = List<Product>.from(widget.cart);
    _saveCart();
  }

  // 💾 Guardar carrito localmente
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_cart.map((p) => p.toJson()).toList());
    await prefs.setString('cart', encoded);
  }

  // 💰 Calcular total de productos seleccionados
  double get _totalPrice {
    double total = 0;
    for (final p in _cart) {
      if (p.selected) total += p.price * p.quantity;
    }
    return total;
  }

  void _increaseQuantity(Product product) {
    setState(() => product.quantity++);
    _saveCart();
  }

  void _decreaseQuantity(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
      } else {
        _cart.remove(product);
      }
    });
    _saveCart();
  }

  void _removeProduct(Product product) {
    setState(() => _cart.remove(product));
    _saveCart();
  }

  void _toggleSelect(Product product, bool selected) {
    setState(() => product.selected = selected);
    _saveCart();
  }

  void _clearCart() {
    setState(() => _cart.clear());
    _saveCart();
  }

  /// ✅ Seleccionar o deseleccionar todos los productos
  void _toggleSelectAll() {
    final bool allSelected = _cart.every((p) => p.selected);
    setState(() {
      for (final p in _cart) {
        p.selected = !allSelected;
      }
    });
    _saveCart();
  }

  /// 🟢 Enviar pedido por WhatsApp
  Future<void> _sendOrder() async {
    final selected = _cart.where((p) => p.selected).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un producto 🍪')),
      );
      return;
    }

    final total = _totalPrice.toStringAsFixed(0);
    final buffer = StringBuffer(
      "🛍 *Nuevo Pedido de Galletas Dulce Pecado Ltda*\n\n",
    );

    for (final p in selected) {
      final licor = (p.alcoholType != null && p.alcoholType!.isNotEmpty)
          ? p.alcoholType
          : "Sin alcohol";
      final alcohol = p.alcoholPercent > 0
          ? "${p.alcoholPercent.toStringAsFixed(1)}%"
          : "0%";
      final tipoCompra = p.id.contains("pack") ? "Paquete (10u)" : "Unidad";

      buffer.writeln("🍪 *${p.name}* (${p.quantity}x)");
      buffer.writeln("   🔸 ${p.description}");
      buffer.writeln("   📦 *Tipo:* $tipoCompra");
      buffer.writeln("   🥃 *Licor:* $licor | *Alcohol:* $alcohol");
      buffer.writeln("   💰 *Subtotal:* \$${p.price * p.quantity}\n");
    }

    buffer.writeln("💵 *Total a pagar:* \$${total}");
    buffer.writeln("🙏 ¡Gracias por tu compra! ❤️");

    final encoded = Uri.encodeComponent(buffer.toString());
    final uri = Uri.parse("https://wa.me/$_whatsappNumber?text=$encoded");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir WhatsApp 😢")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: const Text(
          '🛒 Tu carrito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 🔘 Botón seleccionar/deseleccionar todo
          IconButton(
            tooltip: _cart.every((p) => p.selected)
                ? 'Deseleccionar todo'
                : 'Seleccionar todo',
            icon: Icon(
              _cart.every((p) => p.selected)
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.white,
            ),
            onPressed: _cart.isEmpty ? null : _toggleSelectAll,
          ),

          // 🗑 Vaciar carrito
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Vaciar carrito',
            onPressed: _cart.isEmpty
                ? null
                : () {
                    _clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Carrito vacío 🧹')),
                    );
                  },
          ),
        ],
      ),
      body: _cart.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío 💤',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final product = _cart[index];
                      return CartItem(
                        product: product,
                        onIncrease: () => _increaseQuantity(product),
                        onDecrease: () => _decreaseQuantity(product),
                        onRemove: () => _removeProduct(product),
                        onSelect: (value) => _toggleSelect(product, value),
                      );
                    },
                  ),
                ),

                // 🧾 Barra inferior con total y botón de WhatsApp
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${_totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          "Comprar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _sendOrder,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
