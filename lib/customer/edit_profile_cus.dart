import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

class EditProfileCustomer extends StatefulWidget {
  const EditProfileCustomer({super.key});

  @override
  State<EditProfileCustomer> createState() => _EditProfileCustomerState();
}

class _EditProfileCustomerState extends State<EditProfileCustomer> {
  File? _image;
  String? imageProfileUrl;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final data = userDoc.data();
      setState(() {
        firstNameController.text = data?['firstName'] ?? '';
        lastNameController.text = data?['lastName'] ?? '';
        mobileController.text = data?['mobile'] ?? '';
        imageProfileUrl = data?['imageProfileUrl'];
      });
    }
  }

  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (firstNameController.text.trim().isEmpty || lastNameController.text.trim().isEmpty || mobileController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('fill_all_fields'.tr())));
      return;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'mobile': mobileController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('profile_update_success'.tr())));
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance.ref().child('user_images/$uid.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(uid).set({'imageProfileUrl': url}, SetOptions(merge: true));

      setState(() {
        _image = file;
        imageProfileUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFFCF9CA)),
          const Positioned(top: 0, left: 0, right: 0, child: CurveAppBar(title: '')),
          Positioned(
            top: screenHeight * 0.08,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('profile'.tr(), style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: _image != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(_image!, fit: BoxFit.cover))
                        : imageProfileUrl != null
                            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(imageProfileUrl!, fit: BoxFit.cover))
                            : const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAF1F1F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text((_image == null ? 'choose_photo' : 'edit_photo').tr(), style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035)),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: screenHeight * 0.42,
            bottom: screenHeight * 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(label: 'first_name'.tr(), controller: firstNameController, screenWidth: screenWidth),
                    _buildTextField(label: 'last_name'.tr(), controller: lastNameController, screenWidth: screenWidth),
                    _buildTextField(label: 'mobile_number'.tr(), controller: mobileController, screenWidth: screenWidth),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAF1F1F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: screenWidth * 0.2),
                        child: Text('save'.tr(), style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold, color: const Color(0xFFAF1F1F))),
          const SizedBox(height: 5),
          SizedBox(
            width: screenWidth * 0.8,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Color(0xFFAF1F1F), width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}