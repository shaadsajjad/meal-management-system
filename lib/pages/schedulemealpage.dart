import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/dbhelpe.dart';

class SchedulePage extends StatefulWidget {
  final int userId;

  const SchedulePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DbHelper dbHelper = DbHelper();
  Database? database;
  List<Map<String, Object?>>? data;
  bool shouldShowDeletionUi = false, shouldShowLoadingUI = false;
  int deletionIndex = 0;

  init() async {
    await dbHelper.initDb();

    data = await dbHelper.fetchMenus();
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2),
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Container(
                                //  decoration: BoxDecoration(
                                // color: Colors.black,
                                //  borderRadius:
                                //  BorderRadius.circular(100)),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 7,20, 0),
                                  child: Text(
                                    " ${data?[index]["date"]} ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: size.width * .051,
                                        height: 0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 7, 20, 0),
                              child: Text(
                                data == null
                                    ? ""
                                    : (data?[index]["type"].toString())!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * .051,
                                    height: 0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 7, 0, 0),
                              child: Text(
                                data == null
                                    ? ""
                                    : (data?[index]["menu"].toString())!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * .051,
                                    height: 0),
                                textAlign: TextAlign.center,
                              ),
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
