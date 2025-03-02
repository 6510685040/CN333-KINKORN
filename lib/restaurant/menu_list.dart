import 'package:flutter/material.dart';
import 'package:kinkorn/restaurant/add_menu.dart';
import 'package:kinkorn/restaurant/edit_menu.dart';

class MenuItem {
  final int id;
  //final String picture;
  final String name;
  final double cost;

  MenuItem({
    required this.id,
    //required this.picture,
    required this.name,
    required this.cost,
  });
}

class MenuPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(
      id: 1,
      //picture: 'assets/food1.jpg',
      name: 'สามชั้นคั่วพริกเกลือ',
      cost: 50.00,
    ),
    MenuItem(
      id: 2,
      //picture: 'assets/food2.jpg',
      name: 'ข้าวหมูกระเทียม',
      cost: 55.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB71C1C), // Red background
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            color: Color(0xFFFFFBE6), // Light yellow background
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.red[800]),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'MENU',
                            style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Title Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Menus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ร้าน ครัวสุขใจ - อาหารนานาชาติ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Menu List
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFFBE6),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                children: [
                  // Table Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#', style: _headerStyle()),
                        Text('Picture', style: _headerStyle()),
                        Text('Menu', style: _headerStyle()),
                        Text('Cost (Baht)', style: _headerStyle()),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black),

                  // Menu Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('${item.id}', style: _rowStyle()),
                              /** 
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item.picture,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: _rowStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),*/
                              Text(
                                '${item.cost.toStringAsFixed(2)}',
                                style: _rowStyle(),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMenuPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(0xFFB71C1C), // Red button
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('edit'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add Menu Button
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMenuPage()),
                  );
                },
                child: Text(
                  'ADD MENU',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFFFBE6),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home, 'home'),
                _buildNavItem(Icons.notifications, 'status'),
                _buildNavItem(Icons.bar_chart, 'sales report'),
                _buildNavItem(Icons.menu, 'more'),
                _buildNavItem(Icons.person, 'customer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Style
  TextStyle _headerStyle() {
    return TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  }

  // Row Text Style
  TextStyle _rowStyle() {
    return TextStyle(fontSize: 14);
  }

  // Bottom Navigation Icon
  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey.shade600),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
