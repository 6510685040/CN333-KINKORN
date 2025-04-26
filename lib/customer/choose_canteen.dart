import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/customer/choose_restaurant.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChooseCanteen extends StatelessWidget {
  const ChooseCanteen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            left: 0.07 * screenWidth,
            top: 0.09 * screenHeight,
            child: Text(
              "Where to eat?",
              style: TextStyle(
                //fontFamily: 'GeistFont',
                fontWeight: FontWeight.bold,
                fontSize: 0.087 * screenWidth,
                color: const Color(0xFFFCF9CA),
              ),
            ),
          ),
          Positioned(
            left: 36,
            top: 210,
            child: Container(
              width: 340,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFDFD),
                borderRadius: BorderRadius.circular(110),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 260,
            bottom: 70,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('canteens').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No canteens available.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final canteenId = doc.id; 

                    final name = data['name'] ?? '';
                    final location = data['location'] ?? '';
                    final imageUrl = data['imageUrl'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: canteenBox(
                        context,
                        canteenId: canteenId,
                        name: name,
                        location: location,
                        imageUrl: imageUrl,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              initialIndex: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget canteenBox(
    BuildContext context, {
    required String canteenId,
    required String name,
    required String location,
    required String imageUrl,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseRestaurantScreen(canteenId: canteenId,),
          ),
        );
      },
      child: Container(
        width: 0.82 * screenWidth,
        height: 0.16 * screenHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFAF1F1F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 0.27 * screenWidth,
              height: 0.13 * screenHeight,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 40),
                    )
                  : const Icon(Icons.image_not_supported,
                      size: 40, color: Colors.grey),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFFFCF9CA),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
