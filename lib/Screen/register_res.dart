import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterRes extends StatefulWidget {
  const RegisterRes({super.key});

  @override
  State<RegisterRes> createState() => _RegisterRestaurantScreenState();
}

class _RegisterRestaurantScreenState extends State<RegisterRes> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController openingTimeController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  Map<String, bool> selectedDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  // เพิ่มตัวแปรสำหรับเลือกประเภทโรงอาหาร
  String? _selectedCanteen = 'sc canteen';

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          restaurantNameController.text =
              userData['firstName'] + "'s Restaurant";
          ownerNameController.text =
              userData['firstName'] + " " + userData['lastName'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color(0xFFAF1F1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFAF1F1F),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.08),
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: screenWidth * 0.8,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                width: screenWidth * 0.85,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCF9CA),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼 Add Your Logo
                      const Text(
                        "Add Your Logo",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _image == null
                            ? Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFFD9D9D9)),
                                ),
                                child: const Center(
                                    child: Icon(Icons.add_a_photo,
                                        size: 40, color: Colors.grey)),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(_image!,
                                    height: 100, fit: BoxFit.cover),
                              ),
                      ),
                      const SizedBox(height: 20),

                      buildTextField("Restaurant Name", "Enter restaurant name",
                          restaurantNameController),
                      buildTextField("Owner Name", "Enter owner name",
                          ownerNameController),

                      const Text(
                        "What time does the restaurant open?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: openingTimeController,
                        decoration: InputDecoration(
                          hintText: "Select opening time",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              openingTimeController.text =
                                  pickedTime.format(context);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Choose canteen opening days",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      Column(
                        children: days.map((day) {
                          return CheckboxListTile(
                            title: Text(day),
                            value: selectedDays[day],
                            activeColor: const Color(0xFFAF1F1F),
                            onChanged: (bool? value) {
                              setState(() {
                                selectedDays[day] = value ?? false;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Choose Canteen Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedCanteen,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCanteen = newValue;
                          });
                        },
                        items: <String>['sc canteen', 'jc canteen']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9D9D9), width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAF1F1F),
                            minimumSize: const Size(152, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                DocumentReference userRef = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(user.uid);

                                DocumentSnapshot userDoc = await userRef.get();

                                if (userDoc.exists) {
                                  List<dynamic> currentRoles =
                                      (userDoc['roles'] as List<dynamic>?) ?? [];

                                  if (!currentRoles.contains('customer')) {
                                    currentRoles.add('customer');
                                  }

                                  if (!currentRoles.contains('res')) {
                                    currentRoles.add('res');
                                  }

                                  await userRef.update({
                                    'restaurantName':
                                        restaurantNameController.text,
                                    'ownerName': ownerNameController.text,
                                    'openingTime': openingTimeController.text,
                                    'openingDays': selectedDays,
                                    'canteenType': _selectedCanteen,  
                                    'roles': currentRoles,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Restaurant registered successfully!')),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChooseCanteen()),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(
                            'Create Restaurant',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFFAF1F1F))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
