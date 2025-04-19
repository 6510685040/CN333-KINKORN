import 'package:flutter/material.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  String? selectedBank;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  final List<String> bankNames = [
    "ไทยพาณิชย์ (SCB)",
    "กสิกรไทย (KBANK)",
    "กรุงเทพ (BBL)",
    "กรุงไทย (KTB)",
    "ทหารไทยธนชาต (TTB)",
    "ออมสิน (GSB)",
    "กรุงศรีอยุธยา (BAY)"
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPaymentMethod() async {
    if (accountNameController.text.isEmpty ||
        selectedBank == null ||
        accountNumberController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image.")),
      );
      return;
    }

    try {
      final restaurantId = FirebaseAuth.instance.currentUser!.uid;;
      final uuid = Uuid().v4();

      final ref = FirebaseStorage.instance
          .ref()
          .child('qr_codes')
          .child('$uuid.png');

      await ref.putFile(_selectedImage!);
      final qrUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('paymentMethods')
          .add({
        'accountName': accountNameController.text,
        'bankName': selectedBank,
        'accountNumber': accountNumberController.text,
        'qrImageUrl': qrUrl,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment method added successfully!")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<String?> _getRestaurantIdFromUser() async {
  final user = FirebaseAuth.instance.currentUser;

  return FirebaseAuth.instance.currentUser!.uid;;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAF1F1F),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: Color(0xFFFCF9CA),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "ADD YOUR PAYMENT",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F),
                ),
              ),
            ),
          ),
          Padding(
  padding: EdgeInsets.only(top: 130),
  child: Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFFFCF9CA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              "List of Your Bank Accounts",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFFAF1F1F),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<String?>(
                future: _getRestaurantIdFromUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("No restaurant ID found."));
                  }

                  final restaurantId = snapshot.data!;

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('restaurants')
                        .doc(restaurantId)
                        .collection('paymentMethods')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("No bank accounts found."),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      return Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final accountName = data['accountName'] ?? '';
                            final bankName = data['bankName'] ?? '';
                            final accountNumber = data['accountNumber'] ?? '';
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${index + 1}. Account Name : $accountName"),
                                Text("    Bank : $bankName        Number : $accountNumber"),
                                SizedBox(height: 4),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),

          Padding(
            padding: EdgeInsets.only(top: 325),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.47,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Add Payment Method",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Account Name", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                            controller: accountNameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: "Enter Your Account Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Color(0xFFECECEC),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Bank Name", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: DropdownButtonFormField<String>(
                            value: selectedBank,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFECECEC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            hint: Text("Choose Your Bank Name", textAlign: TextAlign.center),
                            items: bankNames.map((String bank) {
                              return DropdownMenuItem<String>(
                                value: bank,
                                child: Center(child: Text(bank)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedBank = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Account Number", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: TextField(
                            controller: accountNumberController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: "Enter Your Account Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Color(0xFFECECEC),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                            : Text("No image selected", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text("Add QR Code", style: TextStyle(color: Color(0xFFAF1F1F))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBank = null;
                          _selectedImage = null;
                          accountNameController.clear();
                          accountNumberController.clear();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFCF9CA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("Cancel", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 50),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _uploadPaymentMethod,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFCF9CA),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("Confirm", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
