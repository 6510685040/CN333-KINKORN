import 'package:flutter/material.dart';
import 'package:kinkorn/customer/language_setting.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/customer/contact_us.dart';
import 'package:kinkorn/customer/edit_profile_cus.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class MoreCus extends StatelessWidget {
  const MoreCus({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9CA),
      body: Stack(
        children: [
          Positioned.fill(
            top: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.error, color: Colors.red),
                                          );
                                        }
                                        if (!snapshot.hasData || !snapshot.data!.exists) {
                                          return const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          );
                                        }
                                        final data = snapshot.data!.data()! as Map<String, dynamic>;
                                        final imageProfileUrl = data['imageProfileUrl'] as String?;
                                        return CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          backgroundImage: imageProfileUrl != null && imageProfileUrl.isNotEmpty
                                              ? NetworkImage(imageProfileUrl)
                                              : null,
                                          child: imageProfileUrl == null || imageProfileUrl.isEmpty
                                              ? const Icon(Icons.person, color: Colors.red)
                                              : null,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text('error_loading'.tr(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFAF1F1F),
                                            ),
                                          );
                                        }
                                        if (!snapshot.hasData || !snapshot.data!.exists) {
                                          return const SizedBox(
                                            width: 16, height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          );
                                        }
                                        final data = snapshot.data!.data()! as Map<String, dynamic>;
                                        final firstName = data['firstName'] as String? ?? '';
                                        final lastName = data['lastName'] as String? ?? '';
                                        final name = (firstName + ' ' + lastName).trim().isNotEmpty ? '$firstName $lastName' : 'no_name'.tr();

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFAF1F1F),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileCustomer())),
                                                  child: Text(
                                                    'edit_my_profile'.tr(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFFAF1F1F),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFAF1F1F)),
                                                  onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => const EditProfileCustomer()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),

                          // Language
                          _buildMenuButton(context, "language".tr(), () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSettingCustomer()));
                          }),
                          const SizedBox(height: 30),

                          // Notification
                          _buildMenuButton(context, "notification".tr(), () {
                            // Future use
                          }),
                          const SizedBox(height: 30),

                          // Contact us
                          _buildMenuButton(context, "contact_us".tr(), () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUs()));
                          }),
                          const SizedBox(height: 30),

                          // Log out
                          _buildMenuButton(context, "logout".tr(), () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          }, color: const Color(0xFFB7B7B7)),
                          const SizedBox(height: 30),

                          // Delete account
                          _buildMenuButton(context, "delete_account".tr(), () {
                            // Future use
                          }, color: const Color(0xFFFF0606)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
              initialIndex: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, VoidCallback onPressed, {Color color = const Color(0xFFAF1F1F)}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
