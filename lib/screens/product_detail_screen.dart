// 📦 screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final licor = product.alcoholType ?? "Sin alcohol";
    final alcohol = product.alcoholPercent > 0
        ? "${product.alcoholPercent.toStringAsFixed(1)}%"
        : "0%";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🍪 Imagen principal con animación Hero
            Hero(
              tag: product.uniqueKey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  height: 260,
                  width: double.infinity,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🌟 Nombre
            Center(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📝 Descripción
            Text(
              product.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            // 🥃 Detalle del licor
            Card(
              color: const Color(0xFFFDF6EC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_bar, color: Colors.brown),
                        const SizedBox(width: 10),
                        Text(
                          "Licor: $licor",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.brown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Alcohol: $alcohol",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 💰 Precio
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.attach_money, color: Colors.green, size: 26),
                Text(
                  "${product.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 🛒 Botón agregar al carrito
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              label: const Text(
                "Agregar al carrito",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                onAddToCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} añadida al carrito 🛒'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
