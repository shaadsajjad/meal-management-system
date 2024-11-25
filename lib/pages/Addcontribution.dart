import 'package:flutter/material.dart';
//import 'package:meal_management_system/pages/transaction%20history.dart';
import '../classes/dbhelpe.dart';
import 'transaction_history.dart'; // Import the new screen

class AddContribution extends StatefulWidget {
  final String userEmail;  // Change this to String instead of int

  const AddContribution({super.key, required this.userEmail});

  @override
  State<AddContribution> createState() => _AddContributionState();
}

class _AddContributionState extends State<AddContribution> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contribution"),
        backgroundColor: Colors.orangeAccent,
        actions: [
          // Menu icon to view transaction history
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navigate to the transaction history screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionHistory(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Amount Input Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Description Input Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: () async {
                // Fetch the values
                final amountText = _amountController.text;
                final description = _descriptionController.text;

                // Validate the input
                if (amountText.isEmpty || description.isEmpty) {
                  _showDialog("Please fill in all fields");
                  return;
                }

                final amount = double.tryParse(amountText);
                if (amount == null || amount <= 0) {
                  _showDialog("Please enter a valid amount");
                  return;
                }

                // Get the current date
                String currentDate = DateTime.now().toIso8601String();

                // Insert contribution into the database
                await dbHelper.insertUserContribution(
                    widget.userEmail, amount, currentDate, description);

                // Navigate back
                Navigator.pop(context);
              },
              child: Text("Add Contribution"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show a dialog
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
