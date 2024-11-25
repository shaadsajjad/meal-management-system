import 'package:flutter/material.dart';
import '../classes/dbhelpe.dart'; // Assuming you have a DbHelper to fetch data

class ViewBazaarPage extends StatefulWidget {
  @override
  _ViewBazaarPageState createState() => _ViewBazaarPageState();
}

class _ViewBazaarPageState extends State<ViewBazaarPage> {
  List<Map<String, dynamic>> _bazaarItems = [];

  // Fetching Bazaar items from the database
  Future<void> fetchBazaarItems() async {
    final db = DbHelper(); // Get database instance
    List<Map<String, dynamic>> items = await db.fetchAllBazaarItems();
    setState(() {
      _bazaarItems = items;
    });
    print("Fetched items: $_bazaarItems"); // Debugging to see if items are fetched
  }

  @override
  void initState() {
    super.initState();
    fetchBazaarItems();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text("View Bazaar Items"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _bazaarItems.isEmpty
            ? Center(child: Text("No Bazaar items found"))
            : ListView.builder(
          itemCount: _bazaarItems.length,
          itemBuilder: (context, index) {
            var item = _bazaarItems[index];
            return ListTile(
              title: Text(item['name']),
              subtitle: Text("Price: \$${item['price']}"),
            );
          },
        ),
      ),
    );
  }
}


