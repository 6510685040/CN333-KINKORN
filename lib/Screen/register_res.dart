import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinkorn/Screen/pendingApproval.dart';
import 'dart:io';
import 'login.dart';
import 'package:kinkorn/customer/choose_canteen.dart';
import 'package:kinkorn/restaurant/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';



class RegisterRes extends StatefulWidget {
  const RegisterRes({super.key});

  @override
  State<RegisterRes> createState() => RegisterRestaurantScreenState();
}

class RegisterRestaurantScreenState extends State<RegisterRes> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController openingTimeController = TextEditingController();

  File? image;
  final ImagePicker picker = ImagePicker();

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

  List<Map<String, dynamic>> canteens = [];

  String? selectedCanteenId;


  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = 'restaurant_logos/${DateTime.now().millisecondsSinceEpoch}.png';
    final imageRef = storageRef.child(fileName);

    await imageRef.putFile(imageFile);
    final downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>> fetchCanteens() async {
  final snapshot = await FirebaseFirestore.instance.collection('canteens').get();
  return snapshot.docs.map((doc) {
    return {
      'id': doc.id,
      'name': doc['name'],
    };
  }).toList();
}

  
  @override
  void initState() {
    super.initState();
   
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
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      const Text(
                        "Add Your Logo",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                      child: GestureDetector(
                      
                      onTap: pickImage, 
                      child: image == null
                          ? Container(
                               height: MediaQuery.of(context).size.width * 0.3, 
                               width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFD9D9D9)),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    image!,
                                    height: MediaQuery.of(context).size.width * 0.3,
                                    width: MediaQuery.of(context).size.width * 0.3,
               
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text( 'Tap image to change',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),)
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
                         validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select opening time';
                            }
                            return null;
                          },
                        decoration: InputDecoration(
                          hintText: "Select opening time",
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,/*const BorderSide(
                                color: Color(0xFFD9D9D9), width: 5),*/
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
                      FormField<bool>(
                          validator: (value) {
                            if (!selectedDays.containsValue(true)) {
                              return 'Please select at least one opening day';
                            }
                            return null;
                          },
                          builder: (FormFieldState<bool> field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...days.map((day) {
                                  return CheckboxListTile(
                                    title: Text(day),
                                    value: selectedDays[day],
                                    activeColor: const Color(0xFFAF1F1F),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        selectedDays[day] = value ?? false;
                                        field.didChange(value);
                                      });
                                    },
                                  );
                                }).toList(),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                      const SizedBox(height: 15),
                      const Text(
                        "Choose Canteen",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFFAF1F1F),
                        ),
                      ),
                      const SizedBox(height: 10),
               FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchCanteens(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error loading canteens');
                  } else {
                    final canteenItems = snapshot.data ?? [];

                    return DropdownButtonFormField<String>(
                      value: selectedCanteenId,
                      hint: const Text("Choose canteen"),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a canteen' : null,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCanteenId = newValue;
                        });
                      },
                      items: canteenItems.map((canteen) {
                        return DropdownMenuItem<String>(
                          value: canteen['id'],
                          child: Text(canteen['name']),
                        );
                      }).toList(),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        );
                      }
                    },
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
                            if (formKey.currentState?.validate() ?? false) {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                DocumentReference userRef =
                                    FirebaseFirestore.instance.collection('users').doc(user.uid);

                                DocumentSnapshot userDoc = await userRef.get();

                                String? imageLogoURL;
                                if (image != null) {
                                  imageLogoURL = await uploadImageToFirebase(image!);
                                }

                                if (userDoc.exists) {
                                  List<dynamic> currentRoles =
                                      (userDoc['roles'] as List<dynamic>?) ?? [];

                                  if (!currentRoles.contains('customer')) {
                                    currentRoles.add('customer');
                                  }

                                  if (!currentRoles.contains('res')) {
                                    currentRoles.add('res');
                                  }

                                  try {
                                   
                                    await userRef.update({
                                      'restaurantName': restaurantNameController.text,
                                      'ownerName': ownerNameController.text,
                                      'openingTime': openingTimeController.text,
                                      'openingDays': selectedDays,
                                      'canteenId': selectedCanteenId,
                                      'roles': currentRoles,
                                      'logoUrl': imageLogoURL,
                                      
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('restaurants')
                                        .doc(user.uid)
                                        .set({
                                      'restaurantId': user.uid,
                                      'restaurantName': restaurantNameController.text,
                                      'ownerId': user.uid,
                                      'ownerName': ownerNameController.text,
                                      'canteenId': selectedCanteenId,
                                      'logoUrl': imageLogoURL,
                                      'openingDays': selectedDays,
                                      'openingTime': openingTimeController.text,
                                      'openStatus': 'open',
                                      'category': '',
                                      'description': '',
                                      'created_at': FieldValue.serverTimestamp(),
                                      'isApproved': false,
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Restaurant registered successfully!')),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PendingApprovalScreen()),
                                    );
                                  } catch (e) {
                                    print('Error updating Firestore: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Something went wrong')),
                                    );
                                  }
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
        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
        child: TextFormField(
          controller: controller,
          validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
            )
          ),
        ),
        ),
        const SizedBox(height: 20),      
      ],
    );
  }
}
