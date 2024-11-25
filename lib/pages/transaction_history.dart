import 'package:flutter/material.dart';
import '../classes/dbhelpe.dart';

class TransactionHistory extends StatelessWidget {
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
    future: dbHelper.fetchAllTransactions(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Center(child: Text("Error: ${snapshot.error}"));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return Center(child: Text("No transactions found"));
    }

    final transactions = snapshot.data!;

    return ListView.builder(
    itemCount: transactions.length,
    itemBuilder: (context, index) {
    final transaction = transactions[index];
    return ListTile(
    title: Text("Amount: \$${transaction['amount']}"),
    subtitle: Text("Date: ${transaction['date']}"),
    trailing: Text(transaction['description'] ?? "No description"),
    );
    },
    );
    },
    )
    );
  }
}

