import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/schedulemealpage.dart';

import 'bazarexpense.dart';
import 'ordermealpage.dart';

class UserDashboard extends StatefulWidget {
  final int userId; // Add userId as a parameter

  const UserDashboard({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("User Dashboard", style: TextStyle(color: Colors.black, fontSize: size.width * 0.055)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text("Order a Meal", style: TextStyle(fontSize: size.width * 0.05)),
                leading: Icon(Icons.restaurant_menu),
                onTap: () {
                  // Pass userId to OrderMealPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderMealPage(userId: widget.userId),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Scheduled Meals", style: TextStyle(fontSize: size.width * 0.05)),
                leading: Icon(Icons.schedule),
                onTap: () {
                  // Pass userId to SchedulePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchedulePage(userId: widget.userId),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Bazaar Expense", style: TextStyle(fontSize: size.width * 0.05)),
                leading: Icon(Icons.shopping_cart),
                onTap: () {
                  // Pass userId to BazaarExpensePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BazaarExpensePage(userId: widget.userId),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
