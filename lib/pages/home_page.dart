import 'package:flutter/material.dart';
import 'package:zenith/models/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenith/class/level.dart';

//line 406

final List<Actions1> finishedActions = [
  // put it outside of the class so it is accessable from home page
  Actions1(
      title: 'study CS2030S',
      duration: 60,
      difficulty: Difficulty.easy,
      category: Category.study,
      note: 'Learning about asynchronous programming'),
];

class HomePage extends StatefulWidget {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomePage(this._firebaseAuth, this._firestore);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int updatedFinishedActions = finishedActions.length;
  WebViewController? _animationController;
  String currentAction = 'No activity';
  String animation = 'Category.others';
  static TextEditingController _titleController = TextEditingController();
  static TextEditingController _timeController = TextEditingController();
  static TextEditingController _noteController = TextEditingController();
  static Category _selectedCategory = Category.study;
  static Difficulty _selectedDifficulty = Difficulty.easy;
  late User? user = Auth(widget._firebaseAuth).currentUser;
  late int _level;
  late int _exp;
  late int _totalExperience;
  late Level acc;
  late String room;

  final Map<String, String> animationMap = {
    'Category.others': 'others.html',
    'Category.rest': 'sleep.html',
    'Category.workout': 'walk.html',
    'Category.study': 'study.html'
  };

  final Map<String, String> roomMap = {
    'Red': 'red',
    'White': 'white',
    'Black': 'black',
    'Blue': 'blue'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _level = 0;
    _exp = 0;
    _totalExperience = 0;
    room = 'blue';
    _loadFirestoreLevel();

    String roomCol = 'White';

    _getRoomC().then((String result) {
      roomCol = result;
    });

    _animationController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gerardjm018.github.io/animationproto/' +
          roomMap[roomCol]! +
          animationMap[Category.others.toString()]!));
  }

  _loadFirestoreLevel() async {
    final snap = await FirebaseFirestore.instance
        .collection('level')
        .where('email', isEqualTo: user?.email ?? 'User email')
        .withConverter(
            fromFirestore: Level.fromFirestore,
            toFirestore: (level, options) => level.toFirestore())
        .get();
    if (snap.docs.isEmpty) {
      _createLevel();
      return _loadFirestoreLevel();
    }
    for (var doc in snap.docs) {
      final level = doc.data();
      final totalExp = level.experience;
      _totalExperience = totalExp;
      if (totalExp <= 90) {
        _level = 1 + (totalExp / 10).floorToDouble().round();
      } else {
        _level = ((totalExp - 90) / 100).floorToDouble().round() + 10;
      }
      if (totalExp > 90) {
        _exp = (totalExp - 90) - 100 * (_level - 10);
      } else {
        print('asd');
        _exp = totalExp - 10 * (_level - 1);
      }
      acc = level;
      room = level.room;
    }
    setState(() {});
  }

  Future<String> _getRoomC() async {
    final snap = await widget._firestore
        .collection('level')
        .where('email', isEqualTo: user?.email ?? 'User email')
        .withConverter(
            fromFirestore: Level.fromFirestore,
            toFirestore: (level, options) => level.toFirestore())
        .get();

    String abc = 'White';
    for (var doc in snap.docs) {
      final level = doc.data();
      abc = level.room;
    }
    return abc;
  }

  void _createLevel() async {
    await FirebaseFirestore.instance.collection('level').add({
      "experience": 0,
      "email": user?.email ?? 'User email',
      "room": "White",
    });
  }

  void _editExperience(int gainedExp) async {
    print(gainedExp);
    await FirebaseFirestore.instance.collection('level').doc(acc.id).update({
      "experience": _totalExperience + gainedExp,
      "email": user?.email ?? 'User email',
      "room": room,
    });
    _loadFirestoreLevel();
  }

  double getShapeHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight;
  }

  double getShapeWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth;
  }

  void activitySet(TextEditingController title) {
    _titleController = title;
  }

  double progressPercentage =
      0; // 1st bug+ the timer keeps getting faster 2nd = the bar doesnt reset -> fixed
  // when add new action, reset to 0, no wsolve timer getting faster
  Timer? timer;

  void startProgressTimer(int menit) {
    double increment = 1.0 / ((menit));
    const duration = Duration(seconds: 1);
    Timer.periodic(duration, (timer) {
      setState(() {
        if (progressPercentage >= 1.0) {
          timer.cancel();
          setState(() {
            currentAction = 'finished';
          });
        } else {
          progressPercentage += increment;
        }
      });
    });
  }

  void _cancelActivity() {
    setState(() {
      currentAction = 'No activity';
      progressPercentage = 0.0;
      TimerController timerController = Get.find<TimerController>();
      timerController.startTimer(0);
      progressPercentage = -1.0;
      _animationController!.loadRequest(Uri.parse(
          'https://gerardjm018.github.io/animationproto/' +
              roomMap[room]! +
              animationMap[Category.others.toString()]!));
    });
    _titleController.clear();
  }

  int _categoryToInt(Category category) {
    if (category == Category.rest) {
      return 0;
    } else if (category == Category.study) {
      return 1;
    } else {
      return 1;
    }
  }

  int _dificultyToInt(Difficulty difficulty) {
    if (difficulty == Difficulty.easy) {
      return 1;
    } else if (difficulty == Difficulty.hard) {
      return 3;
    } else {
      return 2;
    }
  }

  void _finishActivity() {
    print('cast');
    int selectedCat =
        _categoryToInt(finishedActions[updatedFinishedActions].category);
    int selectedDif =
        _dificultyToInt(finishedActions[updatedFinishedActions].difficulty);
    int selectedDur = finishedActions.last.duration;
    _editExperience(selectedDur * selectedDif * selectedCat);
    setState(() {
      currentAction = 'No activity';
      progressPercentage = 0.0;
      _animationController!.loadRequest(Uri.parse(
          'https://gerardjm018.github.io/animationproto/' +
              roomMap[room]! +
              animationMap[Category.others.toString()]!));
    });
    _titleController.clear();
  }

  void _addActions(Actions1 actions) {
    setState(() {
      currentAction = 'loading';
      progressPercentage = 0;
      finishedActions.add(actions);
      TimerController timerController = Get.find<TimerController>();
      timerController.startTimer(actions.duration * 60);
      startProgressTimer(actions.duration * 60);
      _animationController!.loadRequest(Uri.parse(
          'https://gerardjm018.github.io/animationproto/' +
              roomMap[room]! +
              animationMap[actions.category.toString()]!));
    });
  }

  void _changeRoom(String rooms) {
    String act;

    if (currentAction == 'No activity') {
      act = Category.others.toString();
    } else {
      act = finishedActions[updatedFinishedActions].category.toString();
    }

    setState(() {
      room = rooms;
      _animationController!.loadRequest(Uri.parse(
          'https://gerardjm018.github.io/animationproto/' +
              roomMap[rooms]! +
              animationMap[act]!));
    });
  }

  void _openAddActionsOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewAction(onAddAction: _addActions);
      },
    );
  }

  Widget _activityBar(BuildContext context) {
    final bool isActionFinished = currentAction == 'finished';

    return Container(
      height: getShapeHeight(context) * 0.0625,
      width: getShapeWidth(context) * 0.97,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color(0xFFCED3C4),
            Color(0xFFD8D8D8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _titleController.text.isEmpty
                ? currentAction
                : finishedActions.last.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActionFinished ? Colors.green : Colors.black,
            ),
          ),
          SizedBox(
            width: 100,
            child: TimerClass(isActionFinished: isActionFinished),
          )
        ],
      ),
    );
  }

  void _OpenRoomOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return MyRoom(
          onAddAction: _changeRoom,
        );
      },
    );
  }

  Widget _refresh() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF9F59),
            Color(0xFFF98A4F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          _loadFirestoreLevel();
          print('hi ' + user.toString());
          setState(() {
            if (currentAction == 'loading' || currentAction == 'finished') {
              _animationController!.loadRequest(Uri.parse(
                'https://gerardjm018.github.io/animationproto/' +
                    roomMap[room]! +
                    animationMap[finishedActions[updatedFinishedActions]
                        .category
                        .toString()]!,
              ));
            } else {
              _animationController!.loadRequest(Uri.parse(
                'https://gerardjm018.github.io/animationproto/' +
                    roomMap[room]! +
                    animationMap[Category.others.toString()]!,
              ));
            }
          });
          print(animation);
        },
        icon: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _room(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2, left: 4),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9F59), Color(0xFFF98A4F)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _OpenRoomOverlay,
        icon: Icon(
          Icons.shop,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget _pointsWidget(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
      ),
      child: Center(
        child: Text(
          _level.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _refreshButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        value: _level < 10 ? _exp / 10 : _exp / 100,
        backgroundColor: const Color.fromARGB(255, 199, 200, 196),
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color.fromARGB(255, 11, 122, 68),
        ),
        strokeWidth: 3,
      ),
    );
  }

  Widget _refreshAndPoint(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pointsWidget(context),
        SizedBox(width: 20),
        _refreshButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isActionLoading = currentAction == 'loading';
    Get.put(TimerController());
    Widget progress = Container(
      height: getShapeHeight(context) * 0.020,
      width: getShapeWidth(context) * 0.50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color.fromARGB(255, 250, 249, 249),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          child: LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: const Color.fromARGB(255, 199, 200, 196),
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 11, 122, 68)),
            minHeight: 20,
          )),
    );
    return MaterialApp(
      title: 'Home Page',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 219, 221, 220),
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Home Page',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
              child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      _activityBar(context),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _titleController.text == ''
                              ? Container(
                                  height: getShapeHeight(context) * 0.020,
                                  width: getShapeWidth(context) * 0.50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Color.fromARGB(255, 250, 249, 249),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: LinearProgressIndicator(
                                        value: 0,
                                        backgroundColor: const Color.fromARGB(
                                            255, 199, 200, 196),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(
                                                    255, 11, 122, 68)),
                                        minHeight: 20,
                                      )),
                                )
                              : progress,
                          Row(
                            children: [
                              _refreshAndPoint(context),
                              SizedBox(
                                width: 10,
                              ),
                              _room(context),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          width: 390,
                          height: 430,
                          child:
                              WebViewWidget(controller: _animationController!)),
                    ],
                  ))),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "home",
          onPressed: () {
            if (currentAction == 'No activity') {
              _openAddActionsOverlay();
            } else if (isActionLoading) {
              _cancelActivity();
            } else {
              print('finish');
              _finishActivity();
            }
          },
          backgroundColor: isActionLoading
              ? Color.fromARGB(255, 37, 50, 226)
              : Colors.orange,
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(isActionLoading ? 6.0 : 10.0),
            child: isActionLoading
                ? CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(
                    // Conditionally set the icon here
                    currentAction == 'No activity' ? Icons.add : Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class TimerController extends GetxController {
  Timer? _timer;
  int remainingSeconds = 0;
  final time = '00.00'.obs;

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  startTimer(int menit) {
    const duration = Duration(milliseconds: 1000);
    remainingSeconds = menit;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == -1) {
        timer.cancel();
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = (remainingSeconds % 60);
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }
}

class TimerClass extends GetView<TimerController> {
  const TimerClass({required this.isActionFinished, Key? key})
      : super(key: key);
  final bool isActionFinished;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            color: const Color.fromARGB(255, 199, 200, 196),
            height: 70,
            width: 100,
            child: Obx(
              () => Center(
                child: Text(
                  controller.time.value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isActionFinished ? Colors.green : Colors.black,
                  ),
                ),
              ),
            )),
      ),
    );
  }
}

class NewAction extends StatefulWidget {
  const NewAction(
      {required this.onAddAction,
      super.key}); // called at page controller line 44
  final void Function(Actions1 actions) onAddAction;

  @override
  _NewActionState createState() => _NewActionState();
}

class _NewActionState extends State<NewAction> {
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  final _noteController = TextEditingController();
  Category _selectedCategory = Category.study;
  Difficulty _selectedDifficulty = Difficulty.easy;

  void _submitActionData() {
    final enteredDuration = int.tryParse(_timeController.text);
    final amountIsInvalid = enteredDuration == null || enteredDuration <= 0;
    if (_titleController.text.trim().isEmpty || amountIsInvalid) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure a valid title, amount, difficulty level, and category was entered'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
      return;
    }
    widget.onAddAction(Actions1(
        // onAddAction at line 6
        title: _titleController.text,
        duration: enteredDuration,
        difficulty: _selectedDifficulty,
        category: _selectedCategory,
        note: _noteController.text));
    _HomePageState().activitySet(_titleController);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // or SizedBox(height: 96) for spacing
          height: 28, // Adjust the height to move the app bar down
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text('New Action'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: ListView(
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 20,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey, // Outline color
                            width: 2, // Outline width
                          ),
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                    ),
                    TextField(
                      controller: _timeController,
                      maxLength: 50,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          suffixText: 'minutes ',
                          labelText: 'Duration',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, // Outline color
                              width: 2, // Outline width
                            ),
                            borderRadius: BorderRadius.circular(8),
                            // Rounded corners
                          )),
                    ),
                    TextField(
                      controller: _noteController,
                      maxLength: 100,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          suffixText: ' ',
                          labelText: 'Note',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, // Outline color
                              width: 2, // Outline width
                            ),
                            borderRadius: BorderRadius.circular(8),
                            // Rounded corners
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: DropdownButtonFormField<Category>(
                              value: _selectedCategory,
                              items: Category.values.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Category',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: DropdownButtonFormField<Difficulty>(
                              value: _selectedDifficulty,
                              items: Difficulty.values.map((difficulty) {
                                return DropdownMenuItem(
                                  value: difficulty,
                                  child: Text(
                                    difficulty.name,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedDifficulty = value;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Difficulty',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _submitActionData,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12), // Add padding
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set the text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyRoom extends StatefulWidget {
  const MyRoom(
      {required this.onAddAction,
      super.key}); // called at page controller line 44
  final void Function(String rooms) onAddAction;

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  late int _level;
  late int _exp;
  late int _totalExperience;
  late Level acc;
  late String room;
  final User? user = Auth(FirebaseAuth.instance).currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _level = 0;
    _exp = 0;
    _totalExperience = 0;
    room = 'blue';
    _loadFirestoreLevel();
  }

  _loadFirestoreLevel() async {
    final snap = await FirebaseFirestore.instance
        .collection('level')
        .where('email', isEqualTo: user?.email ?? 'User email')
        .withConverter(
            fromFirestore: Level.fromFirestore,
            toFirestore: (level, options) => level.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final level = doc.data();
      final totalExp = level.experience;
      _totalExperience = totalExp;
      _level = (totalExp / 1000).floorToDouble().round();
      if (totalExp >= 1000) {
        _exp = totalExp - 1000 * _level;
      } else {
        print('asd');
        _exp = totalExp;
      }
      acc = level;
      room = level.room;
    }
    setState(() {});
  }

  void _editRoom(String appliedRoom) async {
    await FirebaseFirestore.instance.collection('level').doc(acc.id).update({
      "experience": _totalExperience,
      "email": user?.email ?? 'User email',
      "room": appliedRoom,
    });
  }

  Widget _cardRoom(String roomStyle, int levelC) {
    if (_level >= levelC) {
      return Card(
          child: Container(
        child: TextButton(
          child: Text(roomStyle),
          onPressed: () {
            _editRoom(roomStyle);
            widget.onAddAction(roomStyle);
            Navigator.pop(context);
          },
        ),
        height: 70,
      ));
    } else {
      return Card(
          child: Container(
        child: Center(child: Text('Unlocked at level' + levelC.toString())),
        height: 70,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room Customization"),
      ),
      body: ListView(
        children: [
          _cardRoom('White', 1),
          _cardRoom('Blue', 10),
          _cardRoom('Red', 20),
          _cardRoom('Black', 30),
        ],
      ),
    );
  }
}
