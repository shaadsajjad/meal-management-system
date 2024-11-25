import 'package:flutter/material.dart';
import 'package:meal_management_system/pages/admin_panel.dart';
import 'package:meal_management_system/pages/user_page.dart';

class Landing_page extends StatefulWidget {
  const Landing_page({super.key});

  @override
  State<Landing_page> createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            ClipRRect(
              child: Image.asset(
                "assets/images/Logo1.png",
                width: size.width * 0.9,
                height: size.width * 0.9,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (value) => const Admin_panel()));
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.orangeAccent),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                child: Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (value)=>UserPage()));
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.orangeAccent),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Text(
                    "Student",
                    style: TextStyle(
                        fontSize: size.width * 0.05, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
