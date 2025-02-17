import 'package:flutter/material.dart';
import 'package:kinkorn/template/curve_app_bar.dart';
import 'package:kinkorn/template/restaurant_bottom_nav.dart'; 

class LanguageSettingRestaurant extends StatefulWidget {
  const LanguageSettingRestaurant({super.key});

  @override
  State<LanguageSettingRestaurant> createState() => _LanguageSettingRestaurantState();
}

class _LanguageSettingRestaurantState extends State<LanguageSettingRestaurant> {
  String appLanguage = 'American English'; // ✅ ค่าเริ่มต้นของแอป
  String menuLanguage = 'Thai'; // ✅ ค่าเริ่มต้นของเมนู

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFFCF9CA)),
          ),
          // 🔹 App Bar โค้ง
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ''),
          ),
          // ✅ ปุ่มย้อนกลับ
          Positioned(
            top: 40, // ✅ ตำแหน่งด้านซ้ายบน
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Language',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 200,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(height: 50),
                // ✅ Dropdown - Application Language
                _buildDropdown(
                  label: 'Application language',
                  value: appLanguage,
                  items: ['American English', 'British English', 'Thai'],
                  onChanged: (value) {
                    setState(() {
                      appLanguage = value!;
                    });
                  },
                ),
                const SizedBox(height: 40),
                // ✅ Dropdown - Menu Language
                _buildDropdown(
                  label: 'Menu language',
                  value: menuLanguage,
                  items: ['Thai', 'English'],
                  onChanged: (value) {
                    setState(() {
                      menuLanguage = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(), // เพิ่มแถบเมนูด้านล่าง
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color:Color(0xFFAF1F1F)),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
