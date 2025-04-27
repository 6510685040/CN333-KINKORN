import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/add_menu.dart';
import 'package:kinkorn/restaurant/edit_menu.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFFBE6),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.red[800]),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 110),
                  Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),

          // Title Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Menus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu List
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBE6),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(12),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurants')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('menuItems')
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No menu items found.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  final menuDocs = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: menuDocs.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final doc = menuDocs[index];
                      final name = doc['name'] ?? 'Unnamed';
                      final price = doc['price']?.toDouble() ?? 0.0;
                      final imageUrl = doc['imageUrl'] ?? '';

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '฿${price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMenuPage(
                                restaurantId: FirebaseAuth.instance.currentUser!.uid,
                                menuItemId: doc.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB71C1C),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Edit'),
                      ),

                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Add Menu Button
          Padding(
            padding: const EdgeInsets.all(50),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMenuPage()),
                  );
                },
                child: const Text(
                  'ADD MENU',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),

          // Bottom Navigation
          //const CustomBottomNav(),
        ],
      ),
    );
  }
}
