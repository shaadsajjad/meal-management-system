import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/viewbazar.dart';
import '../classes/dbhelpe.dart'; // Assuming you have a DbHelper to insert data
//import 'package:meal_management_system/pages/view_bazaar_page.dart'; // Import the view page

class AddBazaarPage extends StatefulWidget {
  @override
  _AddBazaarPageState createState() => _AddBazaarPageState();
}

class _AddBazaarPageState extends State<AddBazaarPage> {
  TextEditingController bazaarNameController = TextEditingController();
  TextEditingController bazaarPriceController = TextEditingController();

  // Method to add bazaar item to the database
  Future<void> addBazaarItem() async {
    if (bazaarNameController.text.isEmpty || bazaarPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    double price = double.tryParse(bazaarPriceController.text) ?? 0.0;
    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid price")),
      );
      return;
    }

    try {
      final db = DbHelper();
      DbHelper().insertBazaarItem(bazaarNameController.text, bazaarPriceController.text); // Corrected price type

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bazaar item added successfully")),
      );

      setState(() {
        bazaarNameController.clear();
        bazaarPriceController.clear();
      });
    } catch (e) {
      print("Error adding item: $e"); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding bazaar item: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("Add Bazaar Item"),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list), // Icon to view bazaar items
            onPressed: () {
              // Navigate to the page where bazaar items are listed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewBazaarPage(), // Assuming you have this page to view bazaar items
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: bazaarNameController,
              decoration: InputDecoration(
                labelText: "Bazaar Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: bazaarPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addBazaarItem,
              child: Text("Add Item"),
            ),
          ],
        ),
      ),
    );
  }
}
