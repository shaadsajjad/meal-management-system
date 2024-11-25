import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/showmeal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';
import 'admin_panel.dart';

class Addmeal extends StatefulWidget {
  const Addmeal({super.key});

  @override
  State<Addmeal> createState() => _AddmealState();
}

class _AddmealState extends State<Addmeal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController menuController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  DbHelper dbHelper = DbHelper();
  Database? database;
  String? value;
  List<Map<String, Object?>>? data;
final type=["Breakfast","Lunch","Dinner"];
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    database = await dbHelper.database;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                )),
            child: Column(
                children: [
              Row(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (value)=>Showmeal()));
                        },
                        child: Icon(
                          Icons.list,
                          color: Colors.black,
                          textDirection: TextDirection.ltr,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Add Meal",
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                      child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                              hintText: "Date",
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.05)
                          ),
                          readOnly: true,
                          onTap: () {
                            selectDate(context);
                          },
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              return null;
                            }
                            return "enter date";
                          },
                       ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1), // Underline style
                            ),
                          ),
                          child: DropdownButton<String>(
                           isExpanded: true,
                            hint: Text("Meal-type"),
                              value: value,
                              items: type.map(buildMenuItem).toList(),
                              onChanged: (value)=> setState(()=>
                                this.value=value,
                              )
                          ),
                        ),

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: TextFormField(
                        controller: menuController,
                        decoration: InputDecoration(
                            hintText: "Menu",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.05)),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty
                            ) {
                            return null;
                          }
                          return "Menu cant be empty";
                        },
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {

                                await dbHelper.insertMenu(
                                  dateController.text,
                                  value.toString(),
                                  menuController.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "Meal Added Successfully")),

                                );
                              } catch (e) {
                                print("Error inserting data: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "Error: Could not register user. Make sure the database is correctly set up.")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,
                                horizontal: 45),
                            child: Text(
                              "Add",
                              style: TextStyle(fontSize: size.width * 0.05,
                                  color: Colors.black),
                            ),
                          ),
                        )

                    ),

                  ],
                ),
              ),
            ])),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      if (picked.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text("The selected date is in the past")));
      }
      else {
        setState(() {
          dateController.text=picked.toString().split(" ")[0];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
              Text("No date Selected")));
    }
  }
  DropdownMenuItem<String> buildMenuItem(String type)=> DropdownMenuItem(
    value: type,
    child: Text(
      type,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
    ),

  );
}

