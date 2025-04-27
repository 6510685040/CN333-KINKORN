import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kinkorn/customer/add_on.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/provider/cartprovider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ChooseMenuScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ChooseMenuScreen({
    Key? key,
    required this.restaurantId,
    required this.restaurantName,
  }) : super(key: key);

  @override
  State<ChooseMenuScreen> createState() => ChooseMenuScreenState();
}

class ChooseMenuScreenState extends State<ChooseMenuScreen> {
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;
  bool isRestaurantOpen = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    await fetchRestaurantStatus();
    await fetchMenuItems();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchRestaurantStatus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .get();
      if (doc.exists) {
        final status = doc.data()?['openStatus'] ?? '';
        isRestaurantOpen = status.toString().toLowerCase() == 'open';
      }
    } catch (e) {
      print('Error fetching restaurant status: $e');
    }
  }

  Future<void> fetchMenuItems() async {
    try {
      final menuSnapshot = await FirebaseFirestore.instance
          .collection('menuItems')
          .where('restaurantId', isEqualTo: widget.restaurantId)
          .where('status', isEqualTo: 'available')
          .get();
      menuItems = menuSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "name": data['name'] ?? '',
          "price": data['price'] ?? 0,
          "imageUrl": data['imageUrl'] ?? '',
          "options": data['options'] ?? [],
        };
      }).toList();
      filteredItems = menuItems;
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = menuItems.where((item) {
        final name = item['name']?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            right: screenWidth * 0.07,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: AutoSizeText(
                    widget.restaurantName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFCF9CA),
                    ),
                    presetFontSizes: [
                      screenWidth * 0.08,
                      screenWidth * 0.07,
                      screenWidth * 0.06,
                      16,
                    ],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRestaurantOpen ? const Color(0xFF35AF1F) : Colors.grey,
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Text(
                    isRestaurantOpen ? "open_to_order".tr() : "closed".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.03,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.22, 
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.006,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1.0),
                borderRadius: BorderRadius.circular(screenWidth * 0.1),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "search_menu".tr(),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: screenWidth * 0.06),
                  border: InputBorder.none,
                  filled: false,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.045),
              ),
            ),
          ),


          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Positioned(
              top: screenHeight * 0.26,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  itemCount: filteredItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return buildMenuItem(context, filteredItems[index]);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, Map<String, dynamic> menuItem) {
    final user = FirebaseAuth.instance.currentUser;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    return Opacity(
      opacity: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFAF1F1F),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.25,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
                image: menuItem['imageUrl'] != ''
                    ? DecorationImage(
                        image: NetworkImage(menuItem['imageUrl']),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: menuItem['imageUrl'] == ''
                  ? const Icon(Icons.image_not_supported, size: 40, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              menuItem["name"],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Color(0xFFFCF9CA),
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            AutoSizeText(
              "฿${menuItem["price"]}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: isRestaurantOpen && user != null
                  ? () {
                      cartProvider.setRestaurantId(widget.restaurantId);
                      cartProvider.setCustomerId(user.uid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddOn(menuData: {
                            'name': menuItem['name'],
                            'price': menuItem['price'],
                            'imageUrl': menuItem['imageUrl'],
                            'restaurantId': widget.restaurantId,
                            'options': menuItem['options'] ?? [],
                          }),
                        ),
                      );
                    }
                  : null,
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 103,
                height: 32,
                decoration: BoxDecoration(
                  color: isRestaurantOpen ? const Color(0xFFFDDC5C) : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(64),
                ),
                alignment: Alignment.center,
                child: AutoSizeText(
                  isRestaurantOpen ? "add".tr() : "closed".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isRestaurantOpen ? const Color(0xFFAF1F1F) : Colors.white70,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
