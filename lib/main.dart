import 'package:flutter/material.dart';

void main() {
  runApp(const JitketCafechApp());
}

// Jitket Cafech colour palette
const Color cafeCream = Color(0xFFFFF8EF);
const Color cafeBrown = Color(0xFF6D4C41);
const Color darkBrown = Color(0xFF4E342E);
const Color cafeGreen = Color(0xFF65815B);
const Color lightBrown = Color(0xFFE8D8C3);
const Color cafePink = Color(0xFFF5DCE0);

class CafeItem {
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final Color background;
  final String badge;
  final IconData fallbackIcon;

  const CafeItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.background,
    required this.badge,
    required this.fallbackIcon,
  });
}

const List<CafeItem> cafeMenu = [
  CafeItem(
    name: 'Iced Latte',
    description:
        'Smooth espresso blended with chilled milk and served over ice.',
    price: 8.00,
    category: 'COFFEE',
    imageUrl:
        'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=400',
    background: Color(0xFFE8D8C3),
    badge: 'BEST SELLER',
    fallbackIcon: Icons.coffee,
  ),
  CafeItem(
    name: 'Matcha Latte',
    description: 'Smooth Japanese matcha with creamy milk.',
    price: 12.00,
    category: 'MATCHA',
    imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400',
    background: Color(0xFFDDE8D5),
    badge: 'POPULAR',
    fallbackIcon: Icons.local_cafe,
  ),
  CafeItem(
    name: 'Iced Lemon Tea',
    description:
        'Refreshing black tea with fresh lemon, served chilled over ice.',
    price: 11.00,
    category: 'SPECIALS',
    imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
    background: Color(0xFFF5DCE0),
    badge: 'CUSTOMER FAVOURITE',
    fallbackIcon: Icons.local_drink,
  ),
  CafeItem(
    name: 'Cheesecake',
    description: 'A rich, creamy and delicious treat.',
    price: 10.00,
    category: 'DESSERTS',
    imageUrl:
        'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400',
    background: Color(0xFFF2E5CF),
    badge: 'MUST TRY',
    fallbackIcon: Icons.cake,
  ),
];

class JitketCafechApp extends StatelessWidget {
  const JitketCafechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jitket Cafech',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cafeCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cafeBrown,
          primary: cafeBrown,
          secondary: cafeGreen,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cafeCream,
          foregroundColor: darkBrown,
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Map<String, int> cart = {};
  String selectedCategory = 'ALL';

  int get totalItems =>
      cart.values.fold(0, (total, quantity) => total + quantity);

  double get totalPrice {
    double total = 0;

    for (final item in cafeMenu) {
      total += item.price * (cart[item.name] ?? 0);
    }

    return total;
  }

  List<CafeItem> get visibleItems {
    if (selectedCategory == 'ALL') {
      return cafeMenu;
    }

    return cafeMenu.where((item) => item.category == selectedCategory).toList();
  }

  void addToCart(CafeItem item) {
    setState(() {
      cart[item.name] = (cart[item.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to your order!'),
        duration: const Duration(seconds: 1),
        backgroundColor: cafeGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void changeQuantity(CafeItem item, int change) {
    setState(() {
      final current = cart[item.name] ?? 0;
      final updated = current + change;

      if (updated <= 0) {
        cart.remove(item.name);
      } else {
        cart[item.name] = updated;
      }
    });
  }

  void showCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cafeCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, refreshSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your Order ☕',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                              color: darkBrown,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (cart.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 54,
                                color: cafeBrown,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Your order is empty!',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Add something delicious to begin.'),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.35,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: cafeMenu
                                .where((item) => (cart[item.name] ?? 0) > 0)
                                .map(
                                  (item) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: item.background,
                                      child: Icon(
                                        item.fallbackIcon,
                                        color: cafeBrown,
                                      ),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: darkBrown,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'RM ${item.price.toStringAsFixed(2)} each',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            changeQuantity(item, -1);
                                            refreshSheet(() {});
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: cafeBrown,
                                          ),
                                        ),
                                        Text(
                                          '${cart[item.name] ?? 0}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            changeQuantity(item, 1);
                                            refreshSheet(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: cafeGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const Divider(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),
                          Text(
                            'RM ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: cafeGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final orderTotal = totalPrice;
                            final itemCount = totalItems;

                            Navigator.pop(sheetContext);

                            showDialog<void>(
                              context: this.context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  backgroundColor: cafeCream,
                                  title: const Text(
                                    'Thank You! ☕',
                                    style: TextStyle(
                                      color: darkBrown,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  content: Text(
                                    'Your Jitket Cafech order is ready for '
                                    'confirmation.\n\n'
                                    'Items: $itemCount\n'
                                    'Total: RM ${orderTotal.toStringAsFixed(2)}\n\n'
                                    'This is a demonstration checkout.',
                                    style: const TextStyle(height: 1.5),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        setState(() {
                                          cart.clear();
                                        });
                                      },
                                      child: const Text(
                                        'Done',
                                        style: TextStyle(
                                          color: cafeBrown,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.coffee),
                          label: const Text('Confirm Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cafeBrown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: lightBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.coffee, size: 27, color: cafeBrown),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jitket Cafech',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'A little cup of happiness',
                  style: TextStyle(
                    color: cafeGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: showCart,
                  tooltip: 'View order',
                  icon: const Icon(Icons.shopping_bag_outlined, size: 27),
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 1,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: cafeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              // Welcome banner
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: lightBrown,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'BREWED WITH LOVE~',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                color: cafeBrown,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Your daily cup of joy.',
                            style: TextStyle(
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              color: darkBrown,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Good drinks, better moods.',
                            style: TextStyle(fontSize: 13, color: darkBrown),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = 'ALL';
                              });
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: cafeBrown,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Explore Menu'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.local_cafe, size: 105, color: cafeBrown),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Menu heading
              const Text(
                'Our Menu',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: darkBrown,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Find your favourite drink and treat.',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 18),

              // Category filters
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['ALL', 'COFFEE', 'MATCHA', 'SPECIALS', 'DESSERTS']
                      .map((category) {
                        final isSelected = selectedCategory == category;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              category == 'ALL' ? 'All Items' : category,
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            selectedColor: lightBrown,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: darkBrown,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide.none,
                          ),
                        );
                      })
                      .toList(),
                ),
              ),

              const SizedBox(height: 18),

              // Menu cards
              ...visibleItems.map((item) => buildMenuCard(item)),

              const SizedBox(height: 20),

              // Footer
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.favorite, color: cafeGreen, size: 28),
                    const SizedBox(height: 8),
                    const Text(
                      'SIP, SMILE, REPEAT',
                      style: TextStyle(
                        color: cafeBrown,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Made with love at Jitket Cafech.',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard(CafeItem item) {
    final quantity = cart[item.name] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      elevation: 2,
      shadowColor: cafeBrown.withValues(alpha: 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: quantity > 0
              ? cafeGreen.withValues(alpha: 0.5)
              : cafeBrown.withValues(alpha: 0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 92,
                height: 105,
                color: item.background,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(item.fallbackIcon, size: 48, color: cafeBrown);
                  },
                ),
              ),
            ),

            const SizedBox(width: 13),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: item.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: darkBrown,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: cafeGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 4),

            // Add and remove controls
            if (quantity == 0)
              IconButton(
                onPressed: () => addToCart(item),
                tooltip: 'Add ${item.name}',
                style: IconButton.styleFrom(
                  backgroundColor: cafeBrown,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                icon: const Icon(Icons.add, size: 23),
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => changeQuantity(item, 1),
                    tooltip: 'Add one',
                    style: IconButton.styleFrom(
                      backgroundColor: cafeBrown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(34, 34),
                    ),
                    icon: const Icon(Icons.add, size: 19),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        color: darkBrown,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => changeQuantity(item, -1),
                    tooltip: 'Remove one',
                    style: IconButton.styleFrom(
                      backgroundColor: lightBrown,
                      foregroundColor: cafeBrown,
                      minimumSize: const Size(34, 34),
                    ),
                    icon: const Icon(Icons.remove, size: 19),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
