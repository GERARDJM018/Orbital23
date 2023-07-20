import 'package:flutter/material.dart';
import 'package:zenith/models/activity.dart';
import 'package:zenith/models/mood.dart';
import 'package:zenith/models/moodcard.dart';
import 'package:zenith/widgets/activity.dart';
import 'package:zenith/widgets/moodicon.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//394

//https://lottiefiles.com/search?q=happy+emotion&category=animations&animations-page=3

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int numberOfDays = 0;
  String? selectedMood;
  String? selectedMoodImage;
  bool canSaveMood = false;

  @override
  void initState() {
    calculateConsecutiveDays();
    calculateWeekly();
    super.initState();
  }

  String _formatDate(DateTime date) {
    return date.toString().substring(0, 10);
  }

  void calculateWeekly() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('user_moods').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> moodDocs = snapshot.docs;
    DateTime currentDate = DateTime.now();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> weeklyMood =
        []; // list of moods with in a week

    for (var moodDoc in moodDocs) {
      DateTime MoodDate = DateTime.parse(moodDoc['date']);
      if (MoodDate.difference(currentDate) <= Duration(days: 7)) {
        weeklyMood.add(moodDoc);
      }
    }
    List<String> moodString = [];
    for (var moodDoc in weeklyMood) {
      String Mood = moodDoc['mood'];
      moodString.add(Mood);
    }
    int happy = 0;
    int sad = 0;
    int angry = 0;
    int surprised = 0;
    int loving = 0;
    int scared = 0;
    String highestMood;

    for (String mood in moodString) {
      if (mood == 'Happy') {
        happy++;
      } else if (mood == 'Sad') {
        sad++;
      } else if (mood == 'Angry') {
        angry++;
      } else if (mood == 'Surprised') {
        surprised++;
      } else if (mood == 'Loving') {
        loving++;
      } else {
        scared++;
      }
    }
    if (happy >= sad &&
        happy >= angry &&
        happy >= surprised &&
        happy >= loving &&
        happy >= scared) {
      highestMood = 'happy';
    } else if (sad >= angry &&
        sad >= surprised &&
        sad >= loving &&
        sad >= scared) {
      highestMood = 'sad';
    } else if (angry >= surprised && angry >= loving && angry >= scared) {
      highestMood = 'angry';
    } else if (surprised >= loving && surprised >= scared) {
      highestMood = 'surprised';
    } else if (loving >= scared) {
      highestMood = 'loving';
    } else {
      highestMood = 'scared';
    }
    if (highestMood == 'happy') {
      currentLottie = happyLottie;
    } else if (highestMood == 'sad') {
      currentLottie = sadLottie;
    } else if (highestMood == 'angry') {
      currentLottie = angryLottie;
    } else if (highestMood == 'surprised') {
      currentLottie = surprisedLottie;
    } else if (highestMood == 'loving') {
      currentLottie = lovingLottie;
    } else {
      currentLottie = scaredLottie;
    }
    print(currentLottie);
    print(111);
  }

  LottieBuilder happyLottie = Lottie.network(
      'https://assets4.lottiefiles.com/private_files/lf30_xpbapt6u.json',
      animate: true);
  LottieBuilder sadLottie = Lottie.asset('assets/sad.json', animate: true);
  LottieBuilder angryLottie = Lottie.asset('assets/angry.json', animate: true);
  LottieBuilder surprisedLottie =
      Lottie.asset('assets/surprised.json', animate: true);
  LottieBuilder lovingLottie = Lottie.asset('assets/love.json', animate: true);
  LottieBuilder scaredLottie =
      Lottie.asset('assets/scared.json', animate: true);

  LottieBuilder currentLottie =
      Lottie.asset('assets/surprised.json', animate: true);

  void calculateConsecutiveDays() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('user_moods').get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> moodDocs = snapshot.docs;
    List<String> uniqueDates = [];

    for (var moodDoc in moodDocs) {
      DateTime currentDate = DateTime.parse(moodDoc['date']);
      uniqueDates.add(_formatDate(currentDate));
    }
    uniqueDates.sort();

    int consecutiveDays = 1;
    if (uniqueDates.length == 0) {
      consecutiveDays = 0;
    } else if (DateTime.parse(uniqueDates[uniqueDates.length -
            1]) == // check that the previous day is not empty
        _formatDate(DateTime.now().add(const Duration(days: -1)))) {
      print(_formatDate(DateTime.now().add(const Duration(days: -1))));
      consecutiveDays = 0;
    } else {
      for (int i = uniqueDates.length - 1; i > 0; i--) {
        //[2023-07-10, 2023-07-10, 2023-07-10, 2023-07-12, 2023-07-13, 2023-07-13, 2023-07-14, 2023-07-14]
        DateTime currentDate = DateTime.parse(uniqueDates[i]);
        DateTime previousDate = DateTime.parse(uniqueDates[i - 1]);
        print(currentDate);
        // Check if the current date is consecutive to the previous date

        if (currentDate.difference(previousDate).inDays == -1 ||
            currentDate.difference(previousDate).inDays == 1) {
          consecutiveDays++;
          print(consecutiveDays);

          // Update the longest consecutive streak if necessary
        } else if (currentDate.difference(previousDate).inDays == 0) {
          continue;
        } else {
          break;
        }
      }
    }

    setState(() {
      numberOfDays = consecutiveDays;
      print(numberOfDays);
    });
  }

  bool isConsecutiveDay(DateTime currentDate, DateTime previousDate) {
    // Compare only the dates without considering the time
    DateTime currentDateWithoutTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime previousDateWithoutTime =
        DateTime(previousDate.year, previousDate.month, previousDate.day);

    // Check if the difference between the dates is 1 day
    return currentDateWithoutTime.difference(previousDateWithoutTime).inDays ==
        1;
  }

  List<Activity> selectedActivities =
      []; // Temporary list to store selected activities
  late MoodCard moodCard;
  String? mood = '';
  String? image = '';

  int ontapcount = 0;
  void _toggleActivitySelection(int index) {
    bool isSelected = act[index].selected;
    bool reachedMaxActivities = selectedActivities.length >= 5;

    setState(() {
      if (!isSelected && !reachedMaxActivities) {
        act[index].selected = true;
        selectedActivities.add(act[index]);
        Provider.of<MoodCard>(context, listen: false).add(act[index]);
      } else if (isSelected) {
        act[index].selected = false;
        selectedActivities.remove(act[index]);
        Provider.of<MoodCard>(context, listen: false).delete(act[index]);
      }

      // Update the mood and activity selections
      bool moodSelected = moods.any((mood) => mood.iselected);
      bool activitiesSelected = selectedActivities.isNotEmpty;
      canSaveMood = moodSelected && activitiesSelected;

      // Reset the ontapcount when no mood is selected
      if (!moodSelected) {
        ontapcount = 0;
      }
    });

    calculateConsecutiveDays();
    calculateWeekly();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              // Add padding for better spacing
              child: Row(
                children: [
                  Expanded(
                    flex:
                        1, // Flex factor 1 to occupy the remaining space on the left
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/home_screen');
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 27,
                            child: CircleAvatar(
                              child: Icon(Icons.dashboard,
                                  color: const Color.fromARGB(255, 56, 62, 56),
                                  size: 30),
                              radius: 25,
                              backgroundColor: Colors.white,
                            ),
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(height: 2.5),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex:
                        2, // Flex factor 2 to occupy the remaining space in the middle
                    child: Text(
                      "MOODFIT",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex:
                        1, // Flex factor 1 to occupy the remaining space on the right
                    child: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 150,
                child: currentLottie,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 205, 225, 231),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 9, 9, 9),
                    ),
                    children: [
                      TextSpan(
                          text: 'MOOD SAVED: ', style: TextStyle(fontSize: 20)),
                      TextSpan(
                        text: '  $numberOfDays',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text: '  days in a row',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              width: 400,
            ),
            Text(
              'How are you feeling?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3),
            Container(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moods.length,
                itemExtent: MediaQuery.of(context).size.width / 4.5,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      GestureDetector(
                        child: MoodIcon(
                          image: moods[index].moodimage,
                          name: moods[index].name,
                          colour: moods[index].iselected
                              ? Colors.black
                              : Colors.white,
                        ),
                        onTap: () => {
                          if (ontapcount == 0)
                            {
                              setState(() {
                                mood = moods[index].name;
                                image = moods[index].moodimage;
                                selectedMood = moods[index].name;
                                selectedMoodImage = moods[index].moodimage;
                                moods[index].iselected = true;
                                ontapcount = ontapcount + 1;
                                if (selectedActivities.isNotEmpty) {
                                  canSaveMood = true;
                                }
                              }),
                            }
                          else if (moods[index].iselected)
                            {
                              setState(() {
                                moods[index].iselected = false;
                                selectedMood = null;
                                selectedMoodImage = null;
                                ontapcount = 0;
                                canSaveMood = false;
                              }),
                            }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'What have you been doing?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: act.length,
                itemExtent: MediaQuery.of(context).size.width / 4.5,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: ActivityIcon(
                          act[index].image,
                          act[index].name,
                          act[index].selected ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          _toggleActivitySelection(index);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/home_screen');
                    },
                    child: Column(
                      children: [],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (canSaveMood) {
                        print(12345);
                        print(selectedMood);
                        setState(() {
                          moodCard =
                              Provider.of<MoodCard>(context, listen: false);
                          moodCard.activities.clear();
                          selectedActivities.clear();
                          moodCard.addPlace(
                            DateTime.now().toString(),
                            selectedMood!,
                            selectedMoodImage!,
                            moodCard.activityimage.toSet().join('_'),
                            moodCard.activityname.toSet().join('_'),
                          );
                          Navigator.of(context).pushNamed('/home_screen');
                        });
                        calculateConsecutiveDays();
                        calculateWeekly();
                      } else {
                        // Show a friendly instruction using SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Please pick a mood and at least one activity!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: canSaveMood
                                ? Colors.orange
                                : Colors
                                    .grey, // Disable the button if canSaveMood is false
                          ),
                          child: Center(
                            child: Icon(
                              Icons.save_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
