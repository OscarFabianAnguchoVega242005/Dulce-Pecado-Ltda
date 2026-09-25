import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'create_cookie_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🧁 Catálogo oficial Dulce Pecado Ltda
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Café Relleno Ganache',
      description:
          'Galleta artesanal con relleno cremoso de ganache de café. Ideal para los amantes del sabor fuerte ☕🍫',
      price: 10998,
      imageUrl: 'lib/assets/galleta_cafe.jpg',
      alcoholPercent: 0.0,
      alcoholType: null, // ← sin alcohol = null
    ),
    Product(
      id: '2',
      name: 'Bocadillo Llanero',
      description:
          'Suave galleta artesanal con trozos de guayaba deshidratada y queso crema. El auténtico sabor del llano 🍓🧀',
      price: 10993,
      imageUrl: 'lib/assets/galleta_bocadillo.jpg',
      alcoholPercent: 0.0,
      alcoholType: null,
    ),
    Product(
      id: '3',
      name: 'Chocolate con Crema de Whiskey',
      description:
          'Galleta de chocolate intenso con un toque cremoso de crema de whiskey. Dulce, potente y elegante 🍫🥃',
      price: 10980,
      imageUrl: 'lib/assets/galleta_whiskey.jpg',
      alcoholPercent: 4.0,
      alcoholType: 'Crema de Whiskey',
    ),
    Product(
      id: '4',
      name: 'Clavos y Canela con Ganache de Ron',
      description:
          'Sabor cálido de canela y clavos con un suave ganache de ron. Un clásico con personalidad 🍪🔥',
      price: 10982,
      imageUrl: 'lib/assets/galleta_ron.jpg',
      alcoholPercent: 4.0,
      alcoholType: 'Ron',
    ),
    Product(
      id: '5',
      name: 'Panela con Aguardiente',
      description:
          'Galleta tradicional de panela con cacao puro y un toque de aguardiente. Dulce, colombiana y con carácter 🍬🇨🇴',
      price: 10990,
      imageUrl: 'lib/assets/galleta_aguardiente.jpg',
      alcoholPercent: 4.0,
      alcoholType: 'Aguardiente',
    ),
  ];

  List<Product> _cart = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // 🔄 Cargar carrito guardado
  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCart = prefs.getString('cart');
      if (savedCart != null) {
        final List decoded = jsonDecode(savedCart);
        setState(() {
          _cart = decoded.map((e) => Product.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error cargando carrito: $e");
    }
  }

  // 💾 Guardar carrito
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_cart.map((e) => e.toJson()).toList());
      await prefs.setString('cart', encoded);
    } catch (e) {
      debugPrint("Error guardando carrito: $e");
    }
  }

  // 🛒 Agregar producto
  void _addToCart(Product product) {
    final existing = _cart
        .where((p) => p.uniqueKey == product.uniqueKey)
        .toList();

    setState(() {
      if (existing.isEmpty) {
        _cart.add(Product.copy(product));
      } else {
        existing.first.quantity++;
      }
    });

    _saveCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado 🛒'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // 🧁 Crear galleta personalizada
  Future<void> _goToCreateCookie() async {
    final newCookie = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const CreateCookieScreen()),
    );

    if (newCookie != null) {
      _addToCart(newCookie);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // 🔧 Ajuste para evitar overflow:
    // childAspectRatio = width / height → si BAJAS el ratio, sube la altura.
    int crossAxisCount;
    double childAspectRatio;
    if (width < 500) {
      crossAxisCount = 1;
      childAspectRatio = 0.65; // ← más alto en móvil
    } else if (width < 900) {
      crossAxisCount = 2;
      childAspectRatio = 0.78;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 0.80;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        centerTitle: true, // ← centra el título
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Image.asset(
                'lib/assets/logo.png',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Dulce Pecado Ltda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // 🔽 Encabezado + grid
      body: Column(
        children: [
          const SizedBox(height: 8),

          // 🔘 Botones centrados bajo el encabezado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.cookie_outlined),
                  label: const Text("Crear tu galleta"),
                  onPressed: _goToCreateCookie,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text("Ver carrito"),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(cart: _cart),
                      ),
                    );
                    await _loadCart();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 🧱 Grid expandible
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: childAspectRatio, // ← clave contra overflow
              ),
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onAddToCart: (updated) => _addToCart(updated),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
