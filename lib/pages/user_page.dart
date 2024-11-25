import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/userDashboard.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isObsecure = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  DbHelper dbHelper = DbHelper();
  Database? database;

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
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/images/Logo1.png",
                        width: size.width * 0.5,
                        height: size.width * 0.5,
                      ),
                    ),
                  ),
                  Text(
                    "Student Panel",
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }
                              return "enter your email";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: TextFormField(
                            controller: passController,
                            obscureText: isObsecure,
                            decoration: InputDecoration(
                              hintText: "Enter your password.",
                              hintStyle: TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObsecure = !isObsecure;
                                  });
                                },
                                icon: Icon(
                                  isObsecure
                                      ? Icons.remove_red_eye_rounded
                                      : Icons.visibility_off_rounded,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }
                              return "enter your pass";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final db = await dbHelper.database;
                                var res = await dbHelper.userLoginCheck(
                                    emailController.text, passController.text);

                                if (res != null) {
                                  // Safely check for 'userId' in the result
                                  if (res['id'] != null) {
                                    int userId = res['id']; // Extract userId safely

                                    // Navigate to UserDashboard, passing userId
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserDashboard(userId: userId),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Login successful")),
                                    );
                                  } else {
                                    // If userId is null, show an error
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("UserId is missing in the database.")),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Invalid email or password.")),
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
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
