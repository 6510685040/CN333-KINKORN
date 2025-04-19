import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/customer/choose_menu.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChooseRestaurantScreen extends StatelessWidget {
  final String canteenId;

  const ChooseRestaurantScreen({super.key, required this.canteenId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ""),
          ),
          Positioned(
            left: screenWidth * 0.07,
            top: screenHeight * 0.09,
            child: Text(
              "Choose Restaurant....",
              style: TextStyle(
                fontFamily: 'GeistFont',
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.08,
                color: const Color(0xFFFCF9CA),
              ),
            ),
          ),
          Positioned(
            left: screenWidth * 0.1,
            top: screenHeight * 0.26,
            child: Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.04,
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
            top: screenHeight * 0.32,
            bottom: screenHeight * 0.09,
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('canteens').doc(canteenId).get(),
              builder: (context, canteenSnapshot) {
                if (!canteenSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final canteenData = canteenSnapshot.data!.data() as Map<String, dynamic>?;
                final canteenLocation = canteenData?['location'] ?? 'Unknown Location';

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .where('canteenId', isEqualTo: canteenId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(child: Text("No restaurants found."));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        final name = data['restaurantName'] ?? '';
                        final status = data['openStatus'] ?? '';
                        final logoUrl = data['logoUrl'] ?? '';
                        final restaurantId = docs[index].id;

                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.025),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseMenuScreen(
                                    restaurantId: restaurantId,
                                    restaurantName: name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.84,
                              height: screenHeight * 0.16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFAF1F1F),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 0.27 * screenWidth,
                                      height: 0.13 * screenHeight,
                                      margin: EdgeInsets.all(screenWidth * 0.025),
                                      color: Colors.white,
                                      child: logoUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: logoUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.broken_image),
                                            )
                                          : const Center(child: Icon(Icons.restaurant)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.01,
                                        horizontal: screenWidth * 0.02,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontFamily: 'GeistFont',
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.05,
                                              color: const Color(0xFFFCF9CA),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02,
                                              vertical: screenHeight * 0.003,
                                            ),
                                            decoration: BoxDecoration(
                                              color: status == 'open'
                                                  ? const Color(0xFF35AF1F)
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.circular(21),
                                            ),
                                            child: Text(
                                              status == 'open' ? "open to order" : "closed",
                                              style: TextStyle(
                                                fontFamily: 'GeistFont',
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth * 0.03,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              "Location: $canteenLocation",
                                              style: TextStyle(
                                                fontFamily: 'GeistFont',
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth * 0.03,
                                                color: const Color(0xFFFCF9CA),
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
            ),
          ),
        ],
      ),
    );
  }
}
