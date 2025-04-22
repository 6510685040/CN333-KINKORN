import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/payment_list.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';
import 'package:kinkorn/template/editable_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPayment extends StatefulWidget {
  final String restaurantId;
  final String paymentMethodId;
  
  const EditPayment({
    Key? key,
    required this.restaurantId,
    required this.paymentMethodId,
  }) : super(key: key);

  @override
  _EditPaymentState createState() => _EditPaymentState();
}

class _EditPaymentState extends State<EditPayment> {
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();

  String? selectedBank;
  String? qrImageUrl;
  File? qrImageFile;
  final picker = ImagePicker();
  //final ImagePicker _picker = ImagePicker(); // ตัวเลือกไฟล์รูป

  @override
  void initState() {
    super.initState();
    _loadPaymentMethodData();
  }

  Future<void> _loadPaymentMethodData() async {
    final doc = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('paymentMethods')
        .doc(widget.paymentMethodId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      accountNameController.text = data['accountName'] ?? '';
      accountNumberController.text = data['accountNumber'] ?? '';
      selectedBank = data['bankName'];
      qrImageUrl = data['qrImageUrl'];
      setState(() {});
    }
  }
  

  // ฟังก์ชันเลือกรูปภาพจากแกลเลอรี

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        qrImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> savePaymentMethod() async {
    final accountName = accountNameController.text.trim();
    final accountNumber = accountNumberController.text.trim();

    if (qrImageFile == null && qrImageUrl == null || accountName.isEmpty || selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and add an image')),
      );
      return;
    }

    final imageUrlToSave = qrImageFile != null
        ? await _uploadImage(widget.paymentMethodId)
        : qrImageUrl;

    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('paymentMethods')
        .doc(widget.paymentMethodId)
        .update({
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': selectedBank,
      'qrImageUrl': imageUrlToSave,
    });  

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment method updated successfully')),
    );
    Navigator.pop(context, true);
  }

  Future<String> _uploadImage(String paymentMethodId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('paymentMethod_images/${widget.restaurantId}/$paymentMethodId.jpg');
    await ref.putFile(qrImageFile!);
    return await ref.getDownloadURL();
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
                  //fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.087,
                  color: Color(0xFFAF1F1F),
                ),
              ),
            ),
          ),

          //Edit Payment Method
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 110),
              child: Text(
                "Edit Payment Method",
                style: TextStyle(
                  //fontFamily: 'Montserrat',
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
                height: MediaQuery.of(context).size.height * 0.74,
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
                            //fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildTextField('Account name', controller: accountNameController),
                        const SizedBox(height: 10),

                        // Bank Name Dropdown
                        Text(
                          "Bank Name",
                          style: TextStyle(
                            //fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        //dropdown bank
                        _buildDropdownField('Category'),
                        const SizedBox(height: 20),

                        // Account Number Input
                        Text(
                          "Account Number",
                          style: TextStyle(
                            //fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFFAF1F1F),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildTextField('Account number', controller: accountNumberController),
                        const SizedBox(height: 15),

                        //Edit QR code
                        // แสดงรูปที่เลือก
                        SizedBox(height: 0),
                        Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: qrImageFile != null
                                  ? DecorationImage(
                                      image: FileImage(qrImageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : (qrImageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(qrImageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                            ),
                            child: qrImageFile == null && qrImageUrl == null
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Edit\nyour\nPicture',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFB71C1C),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '...',
                                          style: TextStyle(
                                            color: Color(0xFFB71C1C),
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),
                        //ปุ่มให้แก้รูป เลือกรูปใหม่
                        ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a photo'),
                                  onTap: () {
                                    Navigator.pop(context, true);
                                    pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    Navigator.pop(context, true);
                                    pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
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
                              _confirmDelete(context);
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
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditPaymentPage()),
                                  );
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
                            savePaymentMethod();
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
      //bottomNavigationBar: const CustomBottomNav(),
    );
  }

  Widget _buildTextField(String hint, {TextEditingController? controller, TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB71C1C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: const TextStyle(color: Color(0xFFB71C1C)),
          ),
          value: selectedBank,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'ไทยพาณิชย์ (SCB)', child: Text('ไทยพาณิชย์ (SCB)')),
            DropdownMenuItem(value: 'กสิกรไทย (KBANK)', child: Text('กสิกรไทย (KBANK)')),
            DropdownMenuItem(value: 'กรุงเทพ (BBL)', child: Text('กรุงเทพ (BBL)')),
            DropdownMenuItem(value: 'กรุงไทย (KTB)', child: Text('กรุงไทย (KTB)')),
            DropdownMenuItem(value: 'ทหารไทยธนชาต (TTB)', child: Text('ทหารไทยธนชาต (TTB)')),
            DropdownMenuItem(value: 'ออมสิน (GSB)', child: Text('ออมสิน (GSB)')),
            DropdownMenuItem(value: 'กรุงศรีอยุธยา (BAY)', child: Text('กรุงศรีอยุธยา (BAY)')),
          ],
          onChanged: (value) {
            setState(() {
              selectedBank = value;
            });
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text('Are you sure you want to delete this payment method?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              _deletePaymentMethod();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePaymentMethod() async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('paymentMethods')
        .doc(widget.paymentMethodId)
        .delete();
  
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment method deleted successfully')),
    );

    Navigator.pop(context, true);
  }

}