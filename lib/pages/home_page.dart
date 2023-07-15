import 'package:flutter/material.dart';
import 'package:zenith/models/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenith/class/level.dart';

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
  final User? user = Auth().currentUser;
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
  ..loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
    + animationMap[Category.others.toString()]!));
  }

  _loadFirestoreLevel() async {
  final snap = await FirebaseFirestore.instance
        .collection('level')
        .where('email', isEqualTo: user?.email ?? 'User email')
        .withConverter(
            fromFirestore: Level.fromFirestore, 
            toFirestore: (level, options) => level.toFirestore())
        .get();
  if (snap.docs.isEmpty)  {
      _createLevel();
      return _loadFirestoreLevel();
  } 
  for (var doc in snap.docs)  { 
    final level = doc.data();
    final totalExp = level.experience;
    _totalExperience = totalExp;
    _level = (totalExp / 1000).floorToDouble().round();
    if (totalExp >= 1000) {
      _exp = totalExp - 1000 * _level;
    } else  {
      print('asd');
      _exp = totalExp;
    }
    acc = level;
    room = level.room;
  }
  setState(() {});
  }

  void _createLevel() async {
    await FirebaseFirestore.instance.collection('level').add({
      "experience": 1000,
      "email": user?.email ?? 'User email',
      "room": "White",
    });
  }

  void _editExperience(int gainedExp) async  {
    print(gainedExp);
    await FirebaseFirestore.instance.collection('level').doc(acc.id).update({
      "experience": _totalExperience + gainedExp,
      "email": user?.email ?? 'User email',
      "room": room,
    });
    _loadFirestoreLevel();
  }

  // at page controller, problem is start action doesnt add the action

  // not, it is updated since the length of the list change, but why index error?
  // how to debug? the print is at page controller line 33
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

  Future<void> signOut() async{
    await Auth().signOut();
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
      startProgressTimer(0);
      progressPercentage = 0;
      _animationController!.loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
      + roomMap[room]! + animationMap[Category.others.toString()]!));
    });
    _titleController.clear();
  }

  int _categoryToInt(Category category) {
    if (category == Category.rest)  {
      return 0;
    } else if (category == Category.study)  {
      return 1;
    } else {
      return 1;
    }
  }

  int _dificultyToInt(Difficulty difficulty)  {
    if (difficulty == Difficulty.easy)  {
      return 1;
    } else if (difficulty == Difficulty.hard) {
      return 3;
    } else {
      return 2;
    }
  }

  void _finishActivity() {
    print('cast');
    int selectedCat = _categoryToInt(finishedActions[updatedFinishedActions].category);
    int selectedDif = _dificultyToInt(finishedActions[updatedFinishedActions].difficulty);
    int selectedDur = finishedActions[updatedFinishedActions].duration;
    _editExperience(selectedDur*selectedDif*selectedCat);
    setState(() {
      currentAction = 'No activity';
      progressPercentage = 0.0;
      _animationController!.loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
      + roomMap[room]! + animationMap[Category.others.toString()]!));
    });
    _titleController.clear();
  }

  void _addActions(Actions1 actions) {
    print(room);
    setState(() {
      currentAction = 'loading';
      progressPercentage = 0;
      finishedActions.add(actions);
      TimerController timerController = Get.find<TimerController>();
      timerController.startTimer(actions.duration);
      startProgressTimer(actions.duration);
      _animationController!.loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
      + roomMap[room]! + animationMap[actions.category.toString()]!));

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
    return Container(
      height: getShapeHeight(context) * 0.0625,
      width: getShapeWidth(context) * 0.97,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 199, 200, 196)),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_titleController.text == ''
              ? currentAction
              : finishedActions[updatedFinishedActions].title),
          SizedBox(width: 100, child: const TimerClass())
        ],
      ),
    );
  }


  Widget _refreshButton(BuildContext context) {
    // return IconButton( onPressed: (){_editExperience(100);
    // _loadFirestoreLevel();},icon: Icon(Icons.autorenew));
    return SizedBox(
      child: LinearProgressIndicator(value: _exp / 1000,
              backgroundColor: const Color.fromARGB(255, 199, 200, 196),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 11, 122, 68)),
              minHeight: 20,),
      width: 300,);
  }
  

  Widget _pointsWidget(BuildContext context) {
    // return Container(
    //   child: Wrap(children: [Icon(Icons.currency_exchange), Text(_level.toString())]),
    // );
    return Container(child: Center(child: Text(_level.toString())), height: 50, width: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber));
  }

  void _OpenRoomOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return MyRoom();
      },
    );
  }

  Widget _refresh() {
    return IconButton(onPressed:() { _loadFirestoreLevel();
    setState(() {
      if (currentAction == 'loading' || currentAction == 'finished')  {      
        _animationController!.loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
      + roomMap[room]! + animationMap[finishedActions[updatedFinishedActions].category.toString()]!));
      } else {
        _animationController!.loadRequest(Uri.parse( 'https://gerardjm018.github.io/animationproto/' 
      + roomMap[room]! + animationMap[Category.others.toString()]!));
      }
    });
    print(animation);}, icon: Icon(Icons.refresh));
  }

  Widget _room(BuildContext context)  {
    return IconButton(onPressed:
        _OpenRoomOverlay
        , icon: Icon(Icons.shop));
  }

  Widget _refreshAndPoint(BuildContext context) {
    return Row(
      children: [
        _pointsWidget(
          context,
        ),
        _refreshButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TimerController());
    Widget progress = Container(
      height: getShapeHeight(context) * 0.025,
      width: getShapeWidth(context) * 0.97,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color.fromARGB(255, 250, 249, 249),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      _activityBar(
                          context), // need to change this -> need to have access to actions list in
                      const SizedBox(
                        // page controller finishedActions but how to access?-> imitate expenses list
                        height: 5,
                      ),
                      _titleController.text == '' ? SizedBox(height: 20,) : progress,
                      const SizedBox(
                        height: 5,
                      ),
                      _refreshAndPoint(context),
                      _room(context),
                      _refresh(),
                      Container(width: 300, height: 300, child: WebViewWidget(controller: _animationController!)),
                    ],
                  ))),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "home",
          backgroundColor: Colors.orange,
          onPressed: () {
            if (currentAction == 'No activity')   {
              _openAddActionsOverlay();
            } else if(currentAction == 'loading') {
              _cancelActivity();
            } else {
              print('finish');
              _finishActivity();
            }
          },
          child: currentAction == 'No activity' ? Icon(Icons.add) : currentAction == 'loading' ? Icon(Icons.cancel) : Icon(Icons.check),
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
  const TimerClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        color: const Color.fromARGB(255, 199, 200, 196),
        height: 70,
        width: 100,
        child: Obx(() => Center(
              child: Text(
                controller.time.value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            )),
      ),
    ));
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 20,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _timeController,
                  maxLength: 50,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    suffixText: 'minutes ',
                    label: Text('Duration'),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          TextField(
            controller: _noteController,
            maxLength: 100,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(label: Text('Notes')),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name,
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const SizedBox(
                width: 5,
              ),
              DropdownButton(
                  value: _selectedDifficulty,
                  items: Difficulty.values
                      .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(
                            difficulty.name,
                          )))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedDifficulty = value;
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('cancle')),
          ElevatedButton(
            onPressed: _submitActionData,
            child: const Text('Start Action'),
          ),
        ],
      ),
    );
  }
}

class MyRoom extends StatefulWidget {
  const MyRoom({super.key});

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  late int _level;
  late int _exp;
  late int _totalExperience;
  late Level acc;
  late String room;
  final User? user = Auth().currentUser;

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
  for (var doc in snap.docs)  { 
    final level = doc.data();
    final totalExp = level.experience;
    _totalExperience = totalExp;
    _level = (totalExp / 1000).floorToDouble().round();
    if (totalExp >= 1000) {
      _exp = totalExp - 1000 * _level;
    } else  {
      print('asd');
      _exp = totalExp;
    }
    acc = level;
    room = level.room;
  }
  setState(() {});
  }


  void _editRoom(String appliedRoom) async  {
    await FirebaseFirestore.instance.collection('level').doc(acc.id).update({
      "experience": _totalExperience,
      "email": user?.email ?? 'User email',
      "room": appliedRoom,
    });
    print(room);
  }

  Widget _cardRoom(String roomStyle, int levelC)  {
    if (_level >= levelC)  {
      return Card(child: Container( child: TextButton(child: Text(roomStyle), 
          onPressed: () {
            _editRoom(roomStyle);
            Navigator.pop(context);
          },), height: 70,));      
    } else {
      return Card(child: Container(child: Center( child: Text('Unlocked at level' + levelC.toString())), height: 70,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Room Customization"),),
      body: ListView(children: [
        _cardRoom('White', 1),
        _cardRoom('Blue', 10),
        _cardRoom('Red', 20),
        _cardRoom('Black', 30),
      ],),);
  }
}