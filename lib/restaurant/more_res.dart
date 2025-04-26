import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/contactus_restaurant.dart';
import 'package:kinkorn/restaurant/language_setting.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:kinkorn/Screen/home.dart';

class MoreRes extends StatelessWidget {
  const MoreRes({super.key});

  Future<String> fetchRestaurantName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      return snapshot['restaurantName'] ?? 'ร้านใหม่';
    } else {
      return 'ร้านใหม่';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchRestaurantName(),
      builder: (context, snapshot) {
        String title = 'ร้านใหม่!';

        if (snapshot.connectionState == ConnectionState.waiting) {
          title = 'กำลังโหลดชื่อร้าน...';
        } else if (snapshot.hasData) {
          title = '${snapshot.data}';
        }
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
                                  color: Color(0xFFEEEEEC),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 10),
                                    // ส่วนของ CircleAvatar (รูปคน)
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.person, // ใช้ไอคอนรูปคน
                                        color: Color(0xFFAF1F1F), // สีของไอคอน
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // ส่วนของข้อความ
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                            //fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFAF1F1F),
                                          ),
                                        ),
                                        // ปุ่ม Edit and IconButton
                                        GestureDetector(
                                          onTap: () {
                                            /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ),
                                            );*/
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Edit my profile",
                                                style: TextStyle(
                                                  //fontFamily: 'Montserrat',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFAF1F1F),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      5), // เพิ่มระยะห่างเล็กน้อย
                                              Icon(
                                                Icons
                                                    .chevron_right, // ไอคอนลูกศร >
                                                size: 18, // ปรับขนาดให้ดูพอดี
                                                color: Color(0xFFAF1F1F),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                MaterialPageRoute(builder: (context) => LanguageSettingRestaurant()),
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
                            onPressed: () {},
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
                                MaterialPageRoute(builder: (context) => ContactUsRestaurant()),
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
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
      },
    );
  }
}
