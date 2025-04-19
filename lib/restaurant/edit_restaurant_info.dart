import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditRestaurantPage extends StatefulWidget {
  const EditRestaurantPage({Key? key}) : super(key: key);

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCanteenId;
  File? _imageFile;
  String? _logoUrl;
  bool _isLoading = false;
  List<Map<String, dynamic>> _canteens = [];


  final List<String> _categories = ['อาหารตามสั่ง', 'เครื่องดื่ม', 'อาหารว่าง', 'ของหวาน'];

  Map<String, bool> _openingDays = {
  'Monday': false,
  'Tuesday': false,
  'Wednesday': false,
  'Thursday': false,
  'Friday': false,
  'Saturday': false,
  'Sunday': false,
};


  @override
  void initState() {
    super.initState();
    _loadRestaurantData();
    _loadCanteens();
  }

  Future<void> _loadRestaurantData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('restaurants').doc(userId).get();
    

    if (doc.exists) {
      final data = doc.data()!;
      _selectedCanteenId = data['canteenId'];
      final openingDays = Map<String, dynamic>.from(data['openingDays'] ?? {});
      _openingDays = _openingDays.map((key, value) => MapEntry(key, openingDays[key] ?? false));

      setState(() {
        _nameController.text = data['restaurantName'] ?? '';
        _selectedCategory = data['category'];
        _timeController.text = data['openingTime'] ?? '';
        _logoUrl = data['logoUrl'];
      });
    }
  }

  Future<void> _loadCanteens() async {
    final snapshot = await FirebaseFirestore.instance.collection('canteens').get();
    setState(() {
      _canteens = snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['name']
      }).toList();
    });
  }

  Future<void> _saveRestaurantData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    setState(() {
      _isLoading = true;
    });

    String? imageUrl = _logoUrl;

    if (_imageFile != null) {
      if (_logoUrl != null) {
        try {
          await FirebaseStorage.instance.refFromURL(_logoUrl!).delete();
        } catch (e) {}
      }

      final ref = FirebaseStorage.instance.ref().child('restaurant_logos/$userId.jpg');
      await ref.putFile(_imageFile!);
      imageUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('restaurants').doc(userId).set({
      'restaurantName': _nameController.text.trim(),
      'category': _selectedCategory,
      'openingTime': _timeController.text.trim(),
      'canteenId': _selectedCanteenId,
      'logoUrl': imageUrl,
      'openingDays': _openingDays,
    }, SetOptions(merge: true));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully')),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        _timeController.text = time.format(context);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        title: const Text(
          'EDIT RESTAURANT',
          style: TextStyle(color: Color(0xFFB71C1C), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB71C1C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                            'Please edit your restaurant',
                            style: TextStyle(color: Color(0xFFB71C1C), fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    image: _imageFile != null
                                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                                        : _logoUrl != null
                                            ? DecorationImage(image: NetworkImage(_logoUrl!), fit: BoxFit.cover)
                                            : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: _imageFile == null && _logoUrl == null
                                      ? const Center(
                                          child: Text(
                                            'Add\nyour\nPicture',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Color(0xFFB71C1C), fontSize: 16),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'edit logo',
                                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildLabeledTextField('Restaurant Name', _nameController),
                          const SizedBox(height: 15),
                          _buildLabeledDropdownField('Category'),
                          const SizedBox(height: 20),
                          _buildTimePickerField('Time', _timeController),
                          const SizedBox(height: 15),
                          _buildCanteenDropdown(),
                          const SizedBox(height: 15),
                          _buildOpeningDaysCheckboxes(),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveRestaurantData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB71C1C),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('save',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
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
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: label == 'Canteen',
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Color(0xFFB71C1C)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCanteenDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Canteen', style: TextStyle(color: Color(0xFFB71C1C), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCanteenId,
              hint: const Text('เลือกโรงอาหาร', style: TextStyle(color: Color(0xFFB71C1C))),
              isExpanded: true,
              items: _canteens.map((canteen) {
                return DropdownMenuItem<String>(
                  value: canteen['id'] as String,
                  child: Text(canteen['name'] as String),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  _selectedCanteenId = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              hint: const Text('เลือกหมวดหมู่', style: TextStyle(color: Color(0xFFB71C1C))),
              isExpanded: true,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpeningDaysCheckboxes() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Days Open',
        style: TextStyle(color: Color(0xFFB71C1C), fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ..._openingDays.keys.map((day) {
        return CheckboxListTile(
          title: Text(day, style: const TextStyle(color: Color(0xFFB71C1C))),
          value: _openingDays[day],
          activeColor: const Color(0xFFB71C1C),
          onChanged: (bool? value) {
            setState(() {
              _openingDays[day] = value ?? false;
            });
          },
        );
      }).toList(),
    ],
  );
}


  Widget _buildTimePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFB71C1C), fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickTime,
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(color: Color(0xFFB71C1C)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
