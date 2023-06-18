import 'package:flutter/material.dart';
import 'package:zenith/components/habit_tile.dart';
import 'package:zenith/components/my_fab.dart';
import 'package:zenith/components/new_habit_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenith/components/edit_habit_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/datetime/date_time.dart';
import 'package:zenith/monthly_summary.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int length = 0;
  int countCompleted = 0;
  Map<DateTime, int> heatMapDataSet = {};
  DateTime? firstLoginDate;

  @override
  void initState() {
    super.initState();
    retrieveFirstLoginDate();
  }

  Future<void> retrieveFirstLoginDate() async {
    DateTime? loginDate = await getFirstLoginDate();
    setState(() {
      firstLoginDate = loginDate;
    });
    calculateHeatMapData();
  }

  Future<DateTime?> getFirstLoginDate() async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentSnapshot<Object?> userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      if (userData.containsKey('firstLoginDate')) {
        Timestamp timestamp = userData['firstLoginDate'] as Timestamp;
        return timestamp.toDate();
      }
    }

    return null;
  }

  Future<void> calculateHeatMapData() async {
    if (firstLoginDate == null) {
      return;
    }

    int daysInBetween = DateTime.now().difference(firstLoginDate!).inDays;
    DateTime startDate =
        createDateTimeObject(convertDateTimeToString(firstLoginDate!));

    for (int i = 0; i < daysInBetween + 2; i++) {
      double parsedPercentage = 0.0;
      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      String currentDateStr = convertDateTimeToString(firstLoginDate!);
      int modifiedDate = int.parse(currentDateStr) + i;
      DateTime modifiedDateTime = createDateTimeObject(modifiedDate.toString());

      Future<void> fetchPercentageValue() async {
        DocumentReference userDoc =
            firestore.collection("users").doc(getUserId());
        DocumentReference percentageCollection = userDoc
            .collection("percentage_summary")
            .doc(convertDateTimeToString(modifiedDateTime));

        DocumentSnapshot percentageSnapshot = await percentageCollection.get();

        Map<String, dynamic>? data =
            percentageSnapshot.data() as Map<String, dynamic>?;
        String? percentage = data?['percentage'] as String?;

        parsedPercentage = double.tryParse(percentage!)!; //correct

        final percentForEachDay = <DateTime, int>{
          DateTime(year, month, day): (parsedPercentage * 10).toInt(),
        };
        print(parsedPercentage * 10);
        heatMapDataSet.addEntries(percentForEachDay.entries);

        // Use the parsedPercentage variable as needed
      }

      fetchPercentageValue();
    }
  }

  /*void checkBoxTapped(bool? value, String habitId) async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentReference habit = userDoc.collection("habits").doc(habitId);

    DocumentSnapshot<Object?> snapshot = await habit.get();
    if (snapshot.exists) {
      Map<String, dynamic> habitData = snapshot.data() as Map<String, dynamic>;
      String habitName = habitData['habit'][0];

      await habit.update({
        'habit': [habitName, value],
      });
      calculateHeatMapData();
    }
  }*/
  void checkBoxTapped(bool? value, String habitId) async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentReference habit = userDoc.collection("habits").doc(habitId);

    DocumentSnapshot<Object?> snapshot = await habit.get();
    if (snapshot.exists) {
      Map<String, dynamic> habitData = snapshot.data() as Map<String, dynamic>;
      String habitName = habitData['habit'][0];

      await habit.update({
        'habit': [habitName, value],
      });

      await calculateHeatMapData(); // Wait for the completion of calculateHeatMapData()

      setState(() {}); // Trigger a rebuild of the widget
    }
  }


  _StatisticsState();

  void editHabit(String id, TextEditingController controller) async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentReference habits = userDoc.collection("habits").doc(id);

    await habits.update({
      'habit': [controller.text, false]
    });
    controller.clear();
    await calculateHeatMapData();

    setState(() {});

    // pop dialog box
    Navigator.of(context).pop();
  }

  void openHabitSettings(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return EditHabitBox(
          onSave: () => editHabit(id, _newHabitNameController),
          docId: id,
          controller: _newHabitNameController,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void deleteHabit(String docId) async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentReference docRef = userDoc.collection("habits").doc(docId);
    await docRef.delete();
    await calculateHeatMapData();

    setState(() {});
  }

  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  final _newHabitNameController = TextEditingController();

  void saveNewHabit2() async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    CollectionReference habits = userDoc.collection("habits");

    await habits.add({
      "habit": [_newHabitNameController.text, false],
    });
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
    await calculateHeatMapData();

    setState(() {});
  }

  void cancelNewHabit() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
            controller: _newHabitNameController,
            hintText: 'Enter Habit Name...',
            onSave: saveNewHabit2,
            onCancel: cancelNewHabit,
          );
        });
  }

  String getUserId() {
    // new change
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    // If the user is not authenticated or null, handle the case accordingly
    // For example, you can return a default or empty string
    return '';
  }

  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference userDoc = firestore.collection("users").doc(getUserId());
    DocumentReference habits = userDoc.collection("habits").doc(docID);
    return habits.get();
  }

  Future<DocumentSnapshot<Object?>> getPercentageSummary(String date) async {
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    DocumentReference percentageSummary =
        userDoc.collection("percentage_summary").doc(date);
    return percentageSummary.get();
  }

  Future<void> calculateHabitPercentage() async {
    int countCompleted = 0;
    String userID = getUserId();
    DocumentReference userDoc = firestore.collection("users").doc(userID);
    CollectionReference habitsCollection = userDoc.collection("habits");

    QuerySnapshot snapshot = await habitsCollection.get();
    // snapshot is habits
    // habitsnapshot are all the habits
    int x = 0;
    for (QueryDocumentSnapshot habitSnapshot in snapshot.docs) {
      // there are 5 habits
      Map<String, dynamic> habitData =
          habitSnapshot.data() as Map<String, dynamic>;

      if (habitData.containsKey("habit")) {
        List<dynamic> habitList = habitData["habit"] as List<dynamic>;

        if (habitList.length >= 2) {
          bool habitCompleted = habitList[1];
          // Perform your desired operations with habitCompleted value
          if (habitCompleted) {
            countCompleted++;
          }
        }
      }
    }

    String percent = length == 0
        ? '0.0'
        : (countCompleted / length)
            .toStringAsFixed(1); //here percent is correct

    String yyyymmdd = convertDateTimeToString(DateTime.now());
    DocumentReference percentageSummaryDoc =
        userDoc.collection("percentage_summary").doc(yyyymmdd);
    await percentageSummaryDoc.set({
      "percentage": percent,
    });
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    String userID = getUserId();
    print(userID);
    CollectionReference habits =
        firestore.collection("users").doc(userID).collection("habits");
    calculateHabitPercentage();
    print(habits);
    return habits.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      body: StreamBuilder<QuerySnapshot<Object?>>(
        stream: streamData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print("asd");
            return Text('No data available');
            
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          var listAllhabits = snapshot.data!.docs;
          length = listAllhabits.length;

          return FutureBuilder<DateTime?>(
            future: getFirstLoginDate(),
            builder: (context, dateSnapshot) {
              if (!dateSnapshot.hasData) {
                return Text('No first login date available');
              }
              firstLoginDate = dateSnapshot.data;

              return ListView(
                // percentage updated only when statistics is reset
                children: [
                  MonthlySummary(
                    datasets: heatMapDataSet,
                    startDate: convertDateTimeToString(firstLoginDate!),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listAllhabits.length,
                    itemBuilder: (context, index) {
                      return HabitTile(
                        habitName:
                            "${(listAllhabits[index].data() as Map<String, dynamic>)["habit"][0]}"
                                .toString(),
                        habitCompleted: (listAllhabits[index].data()
                            as Map<String, dynamic>)["habit"][1],
                        onChanged: (value) =>
                            checkBoxTapped(value, listAllhabits[index].id),
                        settingsTapped: (context) =>
                            openHabitSettings(listAllhabits[index].id),
                        deleteTapped: (context) =>
                            deleteHabit(listAllhabits[index].id),
                        habitId: listAllhabits[index].id,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
