// 📦 screens/create_cookie_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class CreateCookieScreen extends StatefulWidget {
  const CreateCookieScreen({super.key});

  @override
  State<CreateCookieScreen> createState() => _CreateCookieScreenState();
}

class _CreateCookieScreenState extends State<CreateCookieScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _selectedAlcoholPercent = 0.0;
  String? _selectedFlavor;
  String? _selectedLiquor;
  bool _isPack = false;

  // 🍪 Sabores disponibles
  final List<Map<String, dynamic>> _flavors = [
    {"name": "Café", "image": "lib/assets/galleta_cafe.jpg"},
    {"name": "Bocadillo Llanero", "image": "lib/assets/galleta_bocadillo.jpg"},
    {"name": "Chocolate", "image": "lib/assets/galleta_whiskey.jpg"},
    {"name": "Clavos y Canela", "image": "lib/assets/galleta_ron.jpg"},
    {"name": "Panela", "image": "lib/assets/galleta_aguardiente.jpg"},
  ];

  // 🥃 Tipos de licor
  final List<String> _liquors = [
    "Sin alcohol",
    "Ron",
    "Aguardiente",
    "Crema de Whiskey",
  ];

  // 💰 Precios base
  static const int _priceUnit = 10998;
  static const int _pricePack = 110000;

  String get _currentImage {
    if (_selectedFlavor == null) return "lib/assets/galleta_cafe.jpg";
    return _flavors.firstWhere(
      (f) => f["name"] == _selectedFlavor,
      orElse: () => {"image": "lib/assets/galleta_cafe.jpg"},
    )["image"]!;
  }

  void _createCookie() {
    if (_selectedFlavor == null || _selectedLiquor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un sabor y un tipo de alcohol 🍪🥃'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final productName = _nameController.text.trim().isEmpty
        ? "Galleta Personalizada"
        : _nameController.text.trim();

    final description =
        "Sabor: $_selectedFlavor | Licor: $_selectedLiquor | ${_selectedAlcoholPercent.toStringAsFixed(1)}% de alcohol";

    final Product customCookie = Product(
      id: "${DateTime.now().millisecondsSinceEpoch}_${_isPack ? "pack" : "unit"}",
      name: productName,
      description: description,
      price: _isPack ? _pricePack : _priceUnit,
      imageUrl: _currentImage,
      alcoholPercent: _selectedAlcoholPercent,
      alcoholType: _selectedLiquor == "Sin alcohol" ? null : _selectedLiquor,
    );

    Navigator.pop(context, customCookie);
  }

  @override
  Widget build(BuildContext context) {
    final displayedPrice = _isPack ? _pricePack : _priceUnit;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade400,
        title: Row(
          children: [
            Image.asset('lib/assets/logo.png', height: 36),
            const SizedBox(width: 10),
            const Text(
              "Crea Tu Galleta",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),

      // 🎨 Cuerpo principal
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 Vista previa
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: Card(
                color: const Color(0xFFFDF6EC),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          _currentImage,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _nameController.text.isEmpty
                            ? "Tu galleta personalizada 🍪"
                            : _nameController.text,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _selectedFlavor == null
                            ? "Selecciona sabor y licor"
                            : "Sabor: $_selectedFlavor | Licor: ${_selectedLiquor ?? "-"} | ${_selectedAlcoholPercent.toStringAsFixed(1)}%",
                        style: TextStyle(color: Colors.brown.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🏷 Nombre
            const Text(
              "Nombre de tu galleta:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Ej: Galleta del Chef",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🍫 Sabor
            const Text(
              "Sabor de tu galleta:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _flavors.map((flavor) {
                final isSelected = _selectedFlavor == flavor["name"];
                return ChoiceChip(
                  label: Text(flavor["name"]),
                  selected: isSelected,
                  selectedColor: Colors.brown.shade300,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  onSelected: (_) {
                    setState(() => _selectedFlavor = flavor["name"]);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // 🥃 Tipo de alcohol
            const Text(
              "Tipo de alcohol:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _liquors.map((liquor) {
                final isSelected = _selectedLiquor == liquor;
                return ChoiceChip(
                  label: Text(liquor),
                  selected: isSelected,
                  selectedColor: Colors.brown.shade300,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  onSelected: (_) {
                    setState(() {
                      _selectedLiquor = liquor;
                      if (liquor == "Sin alcohol") {
                        _selectedAlcoholPercent = 0.0;
                      } else if (_selectedAlcoholPercent == 0.0) {
                        _selectedAlcoholPercent = 2.0;
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // 🍾 Porcentaje de alcohol
            Row(
              children: [
                const Text(
                  "Porcentaje de alcohol:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<double>(
                  value: _selectedAlcoholPercent,
                  items: const [
                    DropdownMenuItem(value: 0.0, child: Text("0%")),
                    DropdownMenuItem(value: 2.0, child: Text("2%")),
                    DropdownMenuItem(value: 3.0, child: Text("3%")),
                    DropdownMenuItem(value: 4.0, child: Text("4%")),
                    DropdownMenuItem(value: 5.0, child: Text("5%")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAlcoholPercent = value ?? 0.0;
                      if (_selectedAlcoholPercent == 0.0) {
                        _selectedLiquor = "Sin alcohol";
                      } else if (_selectedLiquor == "Sin alcohol") {
                        _selectedLiquor = "Ron";
                        if (_selectedAlcoholPercent < 2.0) {
                          _selectedAlcoholPercent = 2.0;
                        }
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 📦 Unidad / Paquete — versión segura
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text(
                    "Unidad (\$10.998)",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: !_isPack,
                  selectedColor: Colors.brown.shade400,
                  labelStyle: TextStyle(
                    color: !_isPack ? Colors.white : Colors.brown.shade800,
                    fontSize: 13,
                  ),
                  onSelected: (_) => setState(() => _isPack = false),
                ),
                ChoiceChip(
                  label: const Text(
                    "Paquete (10u – \$110000)",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  selected: _isPack,
                  selectedColor: Colors.brown.shade400,
                  labelStyle: TextStyle(
                    color: _isPack ? Colors.white : Colors.brown.shade800,
                    fontSize: 12.5,
                  ),
                  onSelected: (_) => setState(() => _isPack = true),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 💰 Precio
            Center(
              child: Text(
                "Precio estimado: \$${displayedPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🛒 Botón final
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text(
                  "Agregar al carrito",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: _createCookie,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
