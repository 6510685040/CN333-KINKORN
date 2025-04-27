import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinkorn/customer/choose_restaurant.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart'; 

class ChooseCanteen extends StatefulWidget {
  const ChooseCanteen({super.key});

  @override
  State<ChooseCanteen> createState() => _ChooseCanteenState();
}

class _ChooseCanteenState extends State<ChooseCanteen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double horizontalPadding = screenWidth * 0.07;
    final double titleTopPadding = screenHeight * 0.09;
    final double titleFontSize = screenWidth * 0.087;
    final double listTopPadding = screenHeight * 0.3;
    final double bottomPadding = screenHeight * 0.08;

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
            left: horizontalPadding,
            top: titleTopPadding,
            child: Text(
              'where_to_eat'.tr(), 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
                color: const Color(0xFFFCF9CA),
              ),
            ),
          ),
          Positioned.fill(
            top: listTopPadding,
            bottom: bottomPadding,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('canteens').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      'no_canteens_available'.tr(), 
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final canteenId = doc.id;

                    final name = data['name'] ?? '';
                    final location = data['location'] ?? '';
                    final imageUrl = data['imageUrl'] ?? '';

                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.025),
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
    final double containerWidth = screenWidth * 0.82;
    final double containerHeight = screenHeight * 0.16;
    final double imageWidth = screenWidth * 0.27;
    final double imageHeight = screenHeight * 0.13;
    final double imageMargin = screenWidth * 0.025;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseRestaurantScreen(canteenId: canteenId),
          ),
        );
      },
      child: Container(
        width: containerWidth,
        height: containerHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFAF1F1F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: imageWidth,
              height: imageHeight,
              margin: EdgeInsets.all(imageMargin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 40),
                    )
                  : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.025, bottom: screenHeight * 0.025, right: screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.05,
                        color: const Color(0xFFFCF9CA),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * 0.03,
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
