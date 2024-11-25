import 'package:flutter/material.dart';
import '../classes/dbhelpe.dart';  // Import DbHelper class

class OrdersListScreen extends StatelessWidget {
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Fetching all orders
        future: dbHelper.fetchAllOrders(),  // Calling the method to get orders
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;  // List of orders fetched from the database

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text("Meal Type: ${order['meal_type']}"),
                subtitle: Text("Quantity: ${order['quantity']}"),
                trailing: Text("Order Date: ${order['order_date']}"),
              );
            },
          );
        },
      ),
    );
  }
}
