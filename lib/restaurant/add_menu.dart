import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? category;
  File? imageFile;
  final picker = ImagePicker();
  List<String> categoriesList = [];
  List<TextEditingController> _optionNameControllers = [];
  List<TextEditingController> _optionPriceControllers = [];


  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  Future<void> fetchCategories() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    final fetchedCategories = snapshot.docs.first['categories'] as List<dynamic>;
    
    setState(() {
      categoriesList = fetchedCategories.map((e) => e.toString()).toList();
    });
  } catch (e) {
    print("Error fetching categories: $e");
  }
}
@override
  void initState() {
    super.initState();
    fetchCategories(); 
  }
  Future<void> saveMenu() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final description = descriptionController.text.trim();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final List<Map<String, dynamic>> options = [];
    for (int i = 0; i < _optionNameControllers.length; i++) {
      final name = _optionNameControllers[i].text.trim();
      final price = double.tryParse(_optionPriceControllers[i].text.trim()) ?? 0.0;
      if (name.isNotEmpty) {
        options.add({'name': name, 'price': price});
      }
    }


    if (imageFile == null || name.isEmpty || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_fill_fields').tr()),
      );
      return;
    }

    final menuItemId = const Uuid().v4();

    final ref = FirebaseStorage.instance.ref().child('menu_images/$menuItemId.jpg');
    await ref.putFile(imageFile!);
    final imageUrl = await ref.getDownloadURL();

    final menuItem = {
      'menuItemId': menuItemId,
      'restaurantId': uid,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'status': 'available',
      'options': options,
      'orderCount': 0,
      'created_at': FieldValue.serverTimestamp(),
    };

    // Save to main menuItems collection
    await FirebaseFirestore.instance.collection('menuItems').doc(menuItemId).set(menuItem);

    // Save to subcollection under restaurants
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(uid)
        .collection('menuItems')
        .doc(menuItemId)
        .set(menuItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('menu_added_success').tr()),
    );
    Navigator.pop(context);
  }
  void _addOptionField() {
  setState(() {
    _optionNameControllers.add(TextEditingController());
    _optionPriceControllers.add(TextEditingController());
  });
}

void _removeOptionField(int index) {
  setState(() {
    _optionNameControllers.removeAt(index);
    _optionPriceControllers.removeAt(index);
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        title: Text(
          'add_menu'.tr(),
          style: TextStyle(
            color: Color(0xFFB71C1C),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        leadingWidth: 120,
        leading: IconButton(
          padding: const EdgeInsets.only(right: 40),
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB71C1C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'please_add_manu'.tr(),
                        style: TextStyle(
                          color: Color(0xFFB71C1C),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('take_photo').tr(),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('choose_your_photo').tr(),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickImage(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                          child: Container(
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
                              image: imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageFile == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'add_your_picture'.tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFB71C1C),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('name_of_menu'.tr(), controller: nameController , keyboardType: TextInputType.text,),
                      const SizedBox(height: 10),
                      _buildTextField('price'.tr(), controller: priceController, keyboardType: TextInputType.number),
                      const SizedBox(height: 10),
                      _buildTextField('about_manu'.tr(), controller: descriptionController, maxLines: 3, keyboardType: TextInputType.text,),
                      const SizedBox(height: 10),
                      _buildDropdownField('category'.tr()),
                      const SizedBox(height: 20),
                      _buildOptionFields(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: saveMenu,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB71C1C),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('save'.tr(),
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                          ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
        value: category,
        isExpanded: true,
        items: categoriesList.isEmpty
            ? [] 
            : categoriesList.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
        onChanged: (value) {
          setState(() {
            category = value; 
          });
        },
      ),
    ),
  );
}
Widget _buildOptionFields() {
  final screenWidth = MediaQuery.of(context).size.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'addons'.tr(),
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
      ),
      const SizedBox(height: 10),
      ...List.generate(_optionNameControllers.length, (index) {
        bool isSmallScreen = screenWidth < 400;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: isSmallScreen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameField(index),
                    const SizedBox(height: 8),
                 
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: _buildNameField(index)),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _buildPriceField(index)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFB71C1C)),
                      onPressed: () => _removeOptionField(index),
                    ),
                  ],
                ),
        );
      }),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: _addOptionField,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16),
              SizedBox(width: 5),
              Text('add_options'.tr(), style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildNameField(int index) {
  return TextField(
    controller: _optionNameControllers[index],
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    minLines: 1,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: 'Option name',
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

Widget _buildPriceField(int index) {
  return TextField(
    controller: _optionPriceControllers[index],
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    textInputAction: TextInputAction.done,
    minLines: 1,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: '0.00',
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}



}
