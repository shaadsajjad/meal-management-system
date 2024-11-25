import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/dbhelpe.dart';

class OrderMealPage extends StatefulWidget {
  final int userId;

  const OrderMealPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<OrderMealPage> createState() => _OrderMealPageState();
}

class _OrderMealPageState extends State<OrderMealPage> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String? selectedMealType;
  final List<String> mealTypes = ["Breakfast", "Lunch", "Dinner"];
  List<String> scheduledMeals = [];

  @override
  void initState() {
    super.initState();
  }

  // Fetch scheduled meals for the selected date
  Future<void> fetchScheduledMeals(String date) async {
    try {
      final db = DbHelper();
      final meals = await db.fetchScheduledMealsByDate(date);
      print("Scheduled meals fetched for $date: $meals"); // Debugging line
      setState(() {
        scheduledMeals = meals.map((meal) => meal['meal_type'] as String).toList();
        if (scheduledMeals.isEmpty) {
          print("No meals scheduled for $date.");
        }
      });
    } catch (e) {
      print("Error fetching scheduled meals: $e");
    }
  }

  // Order meal and insert into DB
  void orderMeal() async {
    if (selectedMealType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a meal type.")),
      );
      return;
    }

    if (dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date.")),
      );
      return;
    }

    if (!scheduledMeals.contains(selectedMealType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("The selected meal is not in the schedule for the chosen date.")),
      );
      return;
    }

    if (quantityController.text.isEmpty || int.tryParse(quantityController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid quantity.")),
      );
      return;
    }

    int quantity = int.parse(quantityController.text);

    try {
      final db = DbHelper();
      await db.insertMealOrder(
        widget.userId,
        selectedMealType!,
        quantity,
        dateController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
      setState(() {
        selectedMealType = null;
        quantityController.clear();
        dateController.clear();
      });
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to place order.")),
      );
    }
  }

  // Select date function
  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        dateController.text = formattedDate;
        fetchScheduledMeals(formattedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Order Meal", style: TextStyle(color: Colors.black, fontSize: size.width * 0.055)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(),
              ),
              onTap: selectDate,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMealType,
              onChanged: (value) {
                setState(() {
                  selectedMealType = value;
                });
              },
              hint: const Text("Select Meal Type"),
              items: mealTypes.map((mealType) {
                return DropdownMenuItem(
                  value: mealType,
                  child: Text(mealType),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: orderMeal,
              child: const Text("Order Meal"),
            ),
          ],
        ),
      ),
    );
  }
}
