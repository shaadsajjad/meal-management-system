import 'package:flutter/material.dart';

class BazaarExpensePage extends StatefulWidget {
  final int userId;

  const BazaarExpensePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<BazaarExpensePage> createState() => _BazaarExpensePageState();
}

class _BazaarExpensePageState extends State<BazaarExpensePage> {
  TextEditingController expenseController = TextEditingController();
  List<String> expenses = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Bazaar Expenses", style: TextStyle(color: Colors.black, fontSize: size.width * 0.055)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: expenseController,
              decoration: InputDecoration(
                labelText: "Expense Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  expenses.add(expenseController.text);
                  expenseController.clear();
                });
              },
              child: Text("Add Expense"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Expense: ${expenses[index]}"),
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
