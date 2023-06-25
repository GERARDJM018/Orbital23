import 'package:flutter/material.dart';
import 'package:zenith/models/activity.dart';

import 'package:zenith/models/mood.dart';
import 'package:zenith/models/moodcard.dart';
import 'package:zenith/widgets/activity.dart';
import 'package:zenith/widgets/moodicon.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Activity> selectedActivities =
      []; // Temporary list to store selected activities
  late MoodCard moodCard;
  String? mood = '';
  String? image = '';
  late String datepicked;
  late String timepicked;
  String? date = "";
  String? time = "";
  late int currentindex;
  int ontapcount = 0;
  List<Mood> moods = [
    Mood('assets/smile.png', 'Happy', false),
    Mood('assets/sad.png', 'Sad', false),
    Mood('assets/angry.png', 'Angry', false),
    Mood('assets/surprised.png', 'Surprised', false),
    Mood('assets/loving.png', 'Loving', false),
    Mood('assets/scared.png', 'Scared', false)
  ];

  List<Activity> act = [
    Activity('assets/sports.png', 'Sports', false),
    Activity('assets/sleeping.png', 'Sleep', false),
    Activity('assets/shop.png', 'Shop', false),
    Activity('assets/relax.png', 'Relax', false),
    Activity('assets/reading.png', 'Read', false),
    Activity('assets/movies.png', 'Movies', false),
    Activity('assets/gaming.png', 'Gaming', false),
    Activity('assets/friends.png', 'Friends', false),
    Activity('assets/family.png', 'Family', false),
    Activity('assets/excercise.png', 'Excercise', false),
    Activity('assets/eat.png', 'Eat', false),
    Activity('assets/date.png', 'Date', false),
    Activity('assets/clean.png', 'Clean', false)
  ];
  Color colour = Colors.white;
  void initState() {
    super.initState();
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now()
          .subtract(Duration(days: 365, hours: 0, minutes: 0, seconds: 0)),
      lastDate: DateTime.now()
          .add(Duration(days: 365, hours: 0, minutes: 0, seconds: 0)),
    );
    return picked;
  }

  late String dateonly;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('MOOD Dairy',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.insert_emoticon, color: Colors.white, size: 25)
              ],
            ),
            backgroundColor: Colors.red),
        body: Container(
          child: Column(children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/home_screen');
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          child: CircleAvatar(
                              child: Icon(Icons.dashboard,
                                  color: Colors.green, size: 30),
                              radius: 25,
                              backgroundColor: Colors.white),
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(height: 2.5),
                        Text('Dashboard',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 15))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final selectedDate = await _selectDate(context);
                      if (selectedDate != null) {
                        setState(() {
                          datepicked =
                              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                          date =
                              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                          dateonly =
                              "${selectedDate.day}/${selectedDate.month}";
                        });
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          child: CircleAvatar(
                            child: Icon(Icons.calendar_today,
                                color: Colors.blue, size: 30),
                            radius: 25,
                            backgroundColor: Colors.white,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        SizedBox(height: 2.5),
                        Text(
                          'Pick a date',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((x) => {
                                setState(() {
                                  time = x!.format(context).toString();
                                })
                              });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          child: CircleAvatar(
                              child: Icon(Icons.timer,
                                  color: Colors.red, size: 30),
                              radius: 25,
                              backgroundColor: Colors.white),
                          backgroundColor: Colors.red,
                        ),
                        SizedBox(
                          height: 2.5,
                        ),
                        Text('Pick a time',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                                fontSize: 15))
                      ],
                    ),
                  ),
                ]),
            SizedBox(height: 20),
            Text('How are you feeling?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('(Tap to Select and Tap again to deselect!)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moods.length,
                  itemExtent: MediaQuery.of(context).size.width / 4.5,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        SizedBox(width: 15),
                        GestureDetector(
                            child: MoodIcon(
                                image: moods[index].moodimage,
                                name: moods[index].name,
                                colour: moods[index].iselected
                                    ? Colors.black
                                    : Colors.white),
                            onTap: () => {
                                  if (ontapcount == 0)
                                    {
                                      setState(() {
                                        mood = moods[index].name;
                                        image = moods[index].moodimage;
                                        moods[index].iselected = true;
                                        ontapcount = ontapcount + 1;
                                        print(mood);
                                      }),
                                    }
                                  else if (moods[index].iselected)
                                    {
                                      setState(() {
                                        moods[index].iselected = false;
                                        ontapcount = 0;
                                      })
                                    }
                                }),
                      ],
                    );
                  }),
            ),
            Text('What have you been doing?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Tap the activity to select,You can choose multiple',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: act.length,
                  itemExtent: MediaQuery.of(context).size.width / 4.5,
                  itemBuilder: (context, index) {
                    return Row(children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                          child: ActivityIcon(
                              act[index].image,
                              act[index].name,
                              act[index].selected
                                  ? Colors.black
                                  : Colors.white),
                          onTap: () {
                            setState(() {
                              // Toggle the selection of the activity
                              act[index].selected = !act[index].selected;

                              // Update the temporary list of selected activities
                              if (act[index].selected) {
                                selectedActivities.add(act[index]);
                                Provider.of<MoodCard>(context, listen: false)
                                    .add(act[index]);
                                print(selectedActivities
                                    .length); // find selected activities
                              } else {
                                selectedActivities.remove(act[index]);
                                Provider.of<MoodCard>(context, listen: false)
                                    .delete(act[index]);
                              }
                            });
                          }),
                    ]);
                  }),
            ),
            GestureDetector(
              onTap: () {
                if (date == null ||
                    time == null ||
                    mood == null ||
                    image == null ||
                    Provider.of<MoodCard>(context, listen: false)
                        .activityimage
                        .isEmpty ||
                    Provider.of<MoodCard>(context, listen: false)
                        .activityname
                        .isEmpty) {
                  print('Warning condition triggered!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all the required inputs.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else if (Provider.of<MoodCard>(context, listen: false)
                        .activityimage
                        .isEmpty ||
                    Provider.of<MoodCard>(context, listen: false)
                        .activityname
                        .isEmpty) {
                  print('Warning condition triggered!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one activity.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  setState(() {
                    MoodCard moodCard =
                        Provider.of<MoodCard>(context, listen: false);
                    moodCard.addPlace(
                      date!,
                      time!,
                      mood!,
                      image!,
                      moodCard.activityimage.toSet().join('_'),
                      moodCard.activityname.toSet().join('_'),
                    );
                    moodCard.activities
                        .clear(); // Clear the selected activities
                  });
                  Navigator.of(context).pushNamed('/home_screen');
                  setState(() {
                    selectedActivities
                        .clear(); // Clear the local selectedActivities list
                  });
                }
              },
              child: Container(
                height: 38.00,
                width: 117.00,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 21.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.save_alt, size: 20, color: Colors.white)
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffff3d00),
                  border: Border.all(
                    width: 1.00,
                    color: Color(0xffff3d00),
                  ),
                  borderRadius: BorderRadius.circular(19.00),
                ),
              ),
            ),
            SizedBox(height: 15)
          ]),
        ));
  }
}
