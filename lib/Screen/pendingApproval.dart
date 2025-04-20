import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:kinkorn/customer/choose_canteen.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerId = FirebaseAuth.instance.currentUser!.uid;


    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .where('ownerId', isEqualTo: ownerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Restaurant not found"));
        }

        final restaurantData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
        final isApproved = restaurantData['isApproved'] ?? false;

        if (isApproved) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RestaurantDashboard()),
            );
          });
          return const SizedBox();
        }

        return Scaffold(
          backgroundColor: const Color(0xFFFFF8E1),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_empty, size: 80, color: Colors.brown),
                const SizedBox(height: 20),
                const Text(
                  'Your restaurant is pending approval...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ChooseCanteen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAF1F1F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
