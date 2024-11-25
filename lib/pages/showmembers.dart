import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/dbhelpe.dart';
class Showmembers extends StatefulWidget {
  const Showmembers({super.key});

  @override
  State<Showmembers> createState() => _ShowmembersState();
}

class _ShowmembersState extends State<Showmembers> {
  DbHelper dbHelper = DbHelper();
  Database? database;
  List<Map<String, Object?>>? data;
  bool shouldShowDeletionUi = false, shouldShowLoadingUI = false;
  int deletionIndex = 0;

  init() async {
    await dbHelper.initDb();

    data = await dbHelper.fetchUsers();
    setState(() {
      data = data;
    });
    print(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        title: Text(
          "All Members",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.black,
              fontSize: size.width * .055),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: shouldShowLoadingUI
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : (data == null || data!.isEmpty)
            ? const Center(child: Text("No members available"))
            :ListView.builder(

              itemCount: data?.length,


              itemBuilder: (context, index) {
                return Padding(
                  padding: index == 0
                      ? const EdgeInsets.fromLTRB(11, 11, 11, 5.5)
                      : const EdgeInsets.symmetric(
                      horizontal: 11, vertical: 5.5),
                  child: GestureDetector(
                    onTap: shouldShowDeletionUi && index == deletionIndex
                        ? () {
                      dbHelper.deleteUser(
                          int.parse((data?[index]["id"].toString())!));
                      init();
                      setState(() {
                        shouldShowDeletionUi = false;
                      });
                    }
                        : () {},
                    onLongPress: () {
                      setState(() {
                        deletionIndex = index;
                        shouldShowDeletionUi = true;
                      });
                    },
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(width: 1),
                          color: shouldShowDeletionUi && deletionIndex == index
                              ? Colors.red
                              : Colors.transparent),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 555),
                            curve: Curves.linearToEaseOut,
                            opacity:
                            shouldShowDeletionUi && index == deletionIndex
                                ? 0
                                : 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child: Container(
                                  //  decoration: BoxDecoration(
                                       // color: Colors.black,
                                      //  borderRadius:
                                      //  BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 7,25, 0),
                                      child: Text(
                                        " ${data?[index]["name"]} ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: size.width * .051,
                                            height: 0),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(21, 0, 21, 11),
                                      child: Text(
                                        data == null
                                            ? ""
                                            : (data?[index]["number"].toString())!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: size.width * .041,
                                            height: 0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(50, 0, 21, 11),
                                      child: Text(
                                        data == null
                                            ? ""
                                            : (data?[index]["email"].toString())!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: size.width * .041,
                                            height: 0),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 555),
                            curve: Curves.linearToEaseOut,
                            opacity:
                            shouldShowDeletionUi && index == deletionIndex
                                ? 1
                                : 0,
                            child: Text(
                              "delete leaf",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: size.width * .055),
                            ),

                          ),
                          Visibility(
                              visible: shouldShowLoadingUI,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },


      ),
        ),

    );
  }
}
