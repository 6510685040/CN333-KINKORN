import 'package:flutter/material.dart';
import 'package:kinkorn/template/bottom_bar.dart';
import 'package:kinkorn/customer/contact_us.dart';
import 'package:kinkorn/Screen/home.dart';

class MoreCus extends StatelessWidget {
  const MoreCus({super.key});

  @override
  Widget build(BuildContext context) {
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
                                    // ส่วนของ CircleAvatar (รูปคน)
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.person, // ใช้ไอคอนรูปคน
                                        color: Colors.red, // สีของไอคอน
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    // ส่วนของข้อความ
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "เจนรดา",
                                          style: TextStyle(
                                            //fontFamily: 'Montserrat',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFAF1F1F),
                                          ),
                                        ),
                                        // ปุ่ม Edit and IconButton
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Edit my profile",
                                                style: TextStyle(
                                                  //fontFamily: 'Montserrat',
                                                  fontSize: 14,
                                                  color: Color(0xFFAF1F1F),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                icon: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFAF1F1F)),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        )
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
                            onPressed: () {},
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
                            backgroundColor:Color(0xFFB7B7B7),
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 5, // ✅ ทำให้ปุ่มลอยขึ้น
                              shadowColor: Colors.black.withOpacity(0.3),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
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