import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool isEditing = false; // เช็กโหมดแก้ไข
  TextEditingController _controller = TextEditingController(text: "Your Account Name"); // ข้อความเริ่มต้น

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEditing = true; // เมื่อคลิกให้เปลี่ยนเป็นโหมดแก้ไข
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: isEditing
            ? TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                autofocus: true, // โฟกัสเมื่อเปลี่ยนเป็น TextField
                onSubmitted: (value) {
                  setState(() {
                    isEditing = false; // เมื่อกด Enter ให้กลับไปเป็น Text
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFD9D9D9), width: 2),
                  ),
                  filled: true,
                  fillColor: Color(0xFFECECEC),
                ),
              )
            : Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFFD9D9D9), width: 2),
                ),
                child: Text(
                  _controller.text, // ใช้ค่าจากตัวแปร
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ),
      ),
    );
  }
}
