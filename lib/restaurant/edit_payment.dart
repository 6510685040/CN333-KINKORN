import 'package:flutter/material.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:kinkorn/template/editable_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPayment extends StatefulWidget {
  const EditPayment({super.key});

  @override
  _EditPaymentState createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {
  String? selectedBank;
  File? _selectedImage; // เก็บรูปที่เลือก
  final ImagePicker _picker = ImagePicker(); // ตัวเลือกไฟล์รูป

  // รายชื่อธนาคารแบบสมมติก่อน
  final List<String> bankNames = [
    "ไทยพาณิชย์ (SCB)",
    "กสิกรไทย (KBANK)",
    "กรุงเทพ (BBL)",
    "กรุงไทย (KTB)",
    "ทหารไทยธนชาต (TTB)",
    "ออมสิน (GSB)",
    "กรุงศรีอยุธยา (BAY)"
  ];

  // ฟังก์ชันเลือกรูปภาพจากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAF1F1F),
      body: Stack(
        children: [
          // พื้นหลัง Title
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Color(0xFFFCF9CA),
          ),

          // EDIT YOUR PAYMENT
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "EDIT YOUR PAYMENT",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F),
                ),
              ),
            ),
          ),

          //List of Your Bank Accounts
          /*Padding(
            padding: EdgeInsets.only(top: 130),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9, //กว้าง 90%
                height: 160,
                decoration: BoxDecoration(
                  color: Color(0xFFFCF9CA), //FCF9CA
                  borderRadius: BorderRadius.circular(20), // มุมโค้ง 20px
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // ข้อความเริ่มจากซ้าย (ยกเว้นอันแรก)
                      children: [
                        Align(
                          alignment: Alignment.center, // จัดข้อความแรกตรงกลาง
                          child: Text(
                            "List of Your Bank Accounts",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFFAF1F1F), //AF1F1F
                            ),
                          ),
                        ),
                        SizedBox(height: 5), // เว้นระยะห่าง

                        // Bank list
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1. Account Name : ครัวสุขใจ",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFAF1F1F), //AF1F1F
                                ),
                              ),
                              Text(
                                "    Bank : KBANK        Number : 123-4-56789-0",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFAF1F1F), //AF1F1F
                                ),
                              ),
                              Text(
                                "2. Account Name : ครัวสุขใจ",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFAF1F1F), //AF1F1F
                                ),
                              ),
                              Text(
                                "    Bank : SCB              Number : 123-4-55555-0",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFAF1F1F), //AF1F1F
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),*/

          //Edit Payment Method
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 110),
              child: Text(
                "Edit Payment Method",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFFFCF9CA),
                ),
              ),
            ),
          ),

          // Edit Payment Method Section
          Padding(
            padding: EdgeInsets.only(top: 155),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.66,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Account Name Input
                        Text(
                          "Account Name",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 40,
                            child: EditableTextField(), // ใช้ Widget ที่เราสร้าง
                        ),
                        SizedBox(height: 10),

                        // Bank Name Dropdown
                        Text(
                          "Bank Name",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        //dropdown bank
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 40,
                          child: DropdownButtonFormField<String>(
                            value: selectedBank,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFECECEC),
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9), width: 2),
                              ),
                            ),
                            hint: Center(
                              child: Text(
                                "Choose Your Bank Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            items: bankNames.map((String bank) {
                              return DropdownMenuItem<String>(
                                value: bank,
                                child: Center(
                                  child: Text(
                                    bank,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBank = newValue;
                              });
                            },
                            dropdownColor: Colors.white,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            isExpanded:
                                true, // ขยาย dropdown ให้เต็มความกว้างของ parent
                          ),
                        ),
                        SizedBox(height: 10),

                        // Account Number Input
                        Text(
                          "Account Number",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 40,
                            child: EditableTextField(), // ใช้ Widget ที่เราสร้าง
                        ),
                        SizedBox(height: 15),

                        //Edit QR code
                        // แสดงรูปที่เลือก
                        SizedBox(height: 0),
                        _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text("No image selected", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        SizedBox(height: 10),
                        //ปุ่มให้แก้รูป เลือกรูปใหม่
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9), // สีปุ่ม
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            shadowColor: Colors.black, // สีเงา
                            elevation: 5, // ความสูงของเงา (ค่ามาก = เงาเข้ม)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Edit QR Code",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFAF1F1F)),
                          ),
                        ),
                        SizedBox(height: 10),

                        // ปุ่ม Delete Account
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Delete"),
                                    content: Text("Are you sure you want to delete this account?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context), // ปิด popup
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          print("Account Deleted!"); // ลบบัญชี (ใส่ logic ตรงนี้)
                                          Navigator.pop(context); // ปิด popup
                                        },
                                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFAF1F1F),
                              shadowColor: Colors.black, // สีเงา
                              elevation: 5, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Delete Account",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //ปุ่ม cancel confirm
          Stack(
            children: [
              // เนื้อหาหน้าจอทั้งหมด
              Positioned(
                left: 0,
                right: 0,
                bottom: 20, // ตำแหน่งห่างจากขอบล่าง
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ปุ่ม Cancel
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedBank = null;
                              _selectedImage = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFCF9CA),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            shadowColor: Colors.black, // สีเงา
                            elevation: 8, // ความสูงของเงา (ค่ามาก = เงาเข้ม)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),

                      SizedBox(width: 50), // ระยะห่างระหว่างปุ่ม

                      // ปุ่ม Confirm
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print("Confirmed!");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFCF9CA),
                            padding: EdgeInsets.symmetric(vertical: 0),
                            shadowColor: Colors.black, // สีเงา
                            elevation: 8, // ความสูงของเงา (ค่ามาก = เงาเข้ม)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}