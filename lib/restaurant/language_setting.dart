import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kinkorn/template/curve_app_bar.dart';

class LanguageSettingRestaurant extends StatefulWidget {
  const LanguageSettingRestaurant({super.key});

  @override
  State<LanguageSettingRestaurant> createState() => _LanguageSettingRestaurantState();
}

class _LanguageSettingRestaurantState extends State<LanguageSettingRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFFCF9CA)),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CurveAppBar(title: ''),
          ),
          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.chevron_left, size: 40, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'language_title'.tr(), 
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 200,
            child: Column(
              children: [
                const SizedBox(height: 50),
                _buildDropdown(
                  label: 'app_language'.tr(),
                  value: context.locale.languageCode, 
                  items: ['en', 'th'], 
                  onChanged: (value) {
                    if (value == 'th') {
                      context.setLocale(const Locale('th'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB71C1C),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                isDense: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFAF1F1F)),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFAF1F1F),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                menuMaxHeight: 300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
