import 'package:flutter/material.dart';
import 'package:kinkorn/customer/language_setting.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/customer/contact_us.dart';
import 'package:kinkorn/customer/edit_profile_cus.dart';
import 'package:kinkorn/Screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kinkorn/customer/notification_cus.dart';

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
                    // ✅ การ์ดแดงหลัก
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        //color: const Color(0xFFB71C1C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // กรอบชื่อสีเทา
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEC), // สีพื้นหลังของกรอบ
                                  borderRadius: BorderRadius.circular(10), // มุมโค้งของกรอบ
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10),
                                    
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

                                    SizedBox(width: 20),

                                    // ดึงชื่อผู้ใช้มา
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text('Error',
                                            style: TextStyle(
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
                                        final name = (firstName + ' ' + lastName).trim().isNotEmpty ? '$firstName $lastName' : 'ไม่มีชื่อ';

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
                                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileCustomer()),),
                                                  child: const Text(
                                                    "Edit my profile",
                                                    style: TextStyle(
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFFAF1F1F),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LanguageSettingCustomer()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Language',
                                  style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Notification
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFFAF1F1F),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              //NotificationCus().showNotification();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Notification',
                                  style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Contact us
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xFFAF1F1F),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContactUs()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Contact us',
                                  style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Log out
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB7B7B7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Log out',
                                  style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Delete account
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF0606),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: Text(
                                  'Delete account',
                                  style: TextStyle(color: Color(0xFFFCF9CA), fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomBar(
              screenHeight: MediaQuery.of(context).size.height,
              screenWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}