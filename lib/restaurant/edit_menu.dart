import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart';

class EditMenuPage extends StatefulWidget {
  final String restaurantId;
  final String menuItemId;

  const EditMenuPage({
    Key? key,
    required this.restaurantId,
    required this.menuItemId,
  }) : super(key: key);

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? category;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  List<String> categoriesList = [];
  List<Map<String, dynamic>> options = [];


  @override
  void initState() {
    super.initState();
    _loadMenuData();
    fetchCategories();
  }
  Future<void> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      List<String> categoriesListTemp = [];
      snapshot.docs.forEach((doc) {
        var categories = List.from(doc['categories']);
        categoriesListTemp.addAll(categories.map((category) => category.toString()).toList());
      });
      setState(() {
        categoriesList = categoriesListTemp;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> _loadMenuData() async {
    final doc = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('menuItems')
        .doc(widget.menuItemId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      priceController.text = data['price']?.toString() ?? '';
      descriptionController.text = data['description'] ?? '';
      category = data['category'];
      imageUrl = data['imageUrl'];
      options = List<Map<String, dynamic>>.from(data['options'] ?? []);

      setState(() {});
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> saveMenu() async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final description = descriptionController.text.trim();

    if (imageFile == null && imageUrl == null || name.isEmpty || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and add an image')),
      );
      return;
    }

    final imageUrlToSave = imageFile != null
        ? await _uploadImage(widget.menuItemId)
        : imageUrl;

    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('menuItems')
        .doc(widget.menuItemId)
        .update({
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrlToSave,
      'options': options,

    });

    await FirebaseFirestore.instance
        .collection('menuItems')
        .doc(widget.menuItemId)
        .update({
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrlToSave,
      'options': options,

    });

    

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu updated successfully')),
    );
    Navigator.pop(context);
  }

  Future<String> _uploadImage(String menuItemId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('menu_images/${widget.restaurantId}/$menuItemId.jpg');
    await ref.putFile(imageFile!);
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        title: const Text(
          'EDIT MENU',
          style: TextStyle(
            color: Color(0xFFB71C1C),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB71C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[900]),
            onPressed: () => _confirmDelete(context),
          )
        ],
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
                      const Text(
                        'Edit your menu details',
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
                                  title: const Text('Take a photo'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickImage(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('Choose from gallery'),
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
                                  : (imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(imageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null),
                            ),
                            child: imageFile == null && imageUrl == null
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
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField('Name of menu', controller: nameController),
                      const SizedBox(height: 10),
                      _buildTextField('Price', controller: priceController, keyboardType: TextInputType.number),
                      const SizedBox(height: 10),
                      _buildTextField('About', controller: descriptionController, maxLines: 3),
                      const SizedBox(height: 10),
                      _buildDropdownField('Category'),
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
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white),
                          ),
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
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Menu'),
        content: const Text('Are you sure you want to delete this menu?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMenu();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMenu() async {
    await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(widget.restaurantId)
        .collection('menuItems')
        .doc(widget.menuItemId)
        .delete();
    
    await FirebaseFirestore.instance
        .collection('menuItems')
        .doc(widget.menuItemId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu deleted successfully')),
    );

    Navigator.pop(context);
  }
  Widget _buildOptionFields() {
  final screenWidth = MediaQuery.of(context).size.width;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Add-ons',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
      ),
      const SizedBox(height: 10),
      ...options.asMap().entries.map((entry) {
        int index = entry.key;
        var option = entry.value;
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
                  children: [
                    Expanded(flex: 2, child: _buildNameField(index)),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _buildPriceField(index)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          options.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
        );
      }).toList(),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          setState(() {
            options.add({'name': '', 'price': 0.0});
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16),
              SizedBox(width: 5),
              Text('Add new options', style: TextStyle(fontSize: 11, color: Color(0xFF848484))),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildNameField(int index) {
  return TextFormField(
    initialValue: options[index]['name'],
    onChanged: (val) => options[index]['name'] = val,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      hintText: 'Option name',
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
    ),
  );
}

Widget _buildPriceField(int index) {
  return TextFormField(
    initialValue: options[index]['price'].toString(),
    onChanged: (val) => options[index]['price'] = double.tryParse(val) ?? 0.0,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      hintText: '0.00',
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white),
      ),
    ),
  );
}



}

