import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/customer/your_cart.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/widgets/addon_widget.dart' as widgets;
import 'package:provider/provider.dart';

class AddOn extends StatefulWidget {
  final Map<String, dynamic> menuData;

  const AddOn({super.key, required this.menuData});

  @override
  AddOnState createState() => AddOnState();
}

class AddOnState extends State<AddOn> {
  Map<String, int> addonCounts = {};
  TextEditingController requestController = TextEditingController();
  int quantity = 1;
  

  @override
  void initState() {
    super.initState();
    final addons = widget.menuData['options'] as List<dynamic>? ?? [];
    for (var addon in addons) {
      final addonName = addon['name'] as String? ?? '';
      addonCounts[addonName] = 0;
    }

  }

  void incrementAddon(String addon) {
    setState(() {
      addonCounts[addon] = (addonCounts[addon] ?? 0) + 1;
    });
  }

  void decrementAddon(String addon) {
    setState(() {
      if ((addonCounts[addon] ?? 0) > 0) {
        addonCounts[addon] = addonCounts[addon]! - 1;
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

 void addToCart() {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);
  final addons = widget.menuData['options'] as List<dynamic>? ?? [];

  List<Map<String, dynamic>> selectedAddons = [];
  for (var addon in addons) {
    final addonName = addon['name'] as String? ?? '';
    final addonPrice = addon['price'] ?? 0;
    final quantity = addonCounts[addonName] ?? 0;
    if (quantity > 0) {
      selectedAddons.add({
        'name': addonName,
        'price': addonPrice,
        'quantity': quantity,
      });
    }
  }

  final orderData = {
    'name': widget.menuData['name'],
    'price': widget.menuData['price'],
    'addons': selectedAddons,
    'quantity': quantity,
    'request': requestController.text,
    'imageUrl': widget.menuData['imageUrl'] ?? '',
    'restaurantId': cartProvider.restaurantId,
    'customerId': cartProvider.customerId,
  };

  cartProvider.addToCart(orderData);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const YourCart(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final addons = widget.menuData['options'] as List<dynamic>? ?? [];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color(0xFFFCF9CA),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ""),
          ),
          Positioned(
            left: screenWidth * 0.1,
            top: screenHeight * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: widget.menuData['imageUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.menuData['imageUrl'],
                              fit: BoxFit.cover,
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.2,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.menuData['name'] ?? 'ชื่อเมนู',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                    color: const Color(0xFFAF1F1F),
                  ),
                ),
                Text(
                  '฿${widget.menuData['price'] ?? '0'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontFamily: 'GeistFont',
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.06,
                    color: const Color(0xFFAF1F1F),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                    color: const Color(0xFFAF1F1F),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: decrementQuantity,
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    IconButton(
                      onPressed: incrementQuantity,
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                    ),
                  ],
                ),
                if (addons.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01),
                    child: Text(
                      'Add-ons',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                        color: const Color(0xFFAF1F1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...addons.map((addon) {
                    final addonName = addon['name'] as String? ?? '';
                    final addonPrice = addon['price'] ?? 0;
                    return Column(
                      children: [
                        widgets.AddOnWidget(
                          label: '$addonName (+฿$addonPrice)',
                          count: addonCounts[addonName] ?? 0,
                          onIncrement: () => incrementAddon(addonName),
                          onDecrement: () => decrementAddon(addonName),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ],
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.01),
                  child: Text(
                    'Special Request',
                    style: TextStyle(
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                      color: const Color(0xFFAF1F1F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: screenWidth * 0.8,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: requestController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your request...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: addToCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAF1F1F),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      //fontFamily: 'GeistFont',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            ),
          ),
        ],
      ),
    );
  }
} 