import 'package:flutter/material.dart';
import 'package:zenith/models/actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenith/auth.dart';
import 'package:zenith/pages/webview.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

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
  String currentAction = 'No activity';
  static TextEditingController _titleController = TextEditingController();
  static TextEditingController _timeController = TextEditingController();
  static TextEditingController _noteController = TextEditingController();
  static Category _selectedCategory = Category.study;
  static Difficulty _selectedDifficulty = Difficulty.easy;



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
    });
    _titleController.clear();
  }

  void _addActions(Actions1 actions) {
    setState(() {
      currentAction = 'loading';
      progressPercentage = 0;
      finishedActions.add(actions);
      TimerController timerController = Get.find<TimerController>();
      timerController.startTimer(actions.duration);
      startProgressTimer(actions.duration);
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
    return IconButton( onPressed: (){signOut();},icon: Icon(Icons.autorenew));
  }

  Widget _pointsWidget(BuildContext context) {
    return Container(
      child: Wrap(children: [Icon(Icons.currency_exchange), Text('123')]),
    );
  }

  Widget _refreshAndPoint(BuildContext context) {
    return Wrap(
      spacing: getShapeWidth(context) * 2 / 3,
      children: [
        _refreshButton(context),
        _pointsWidget(
          context,
        )
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
                      Container(width: 400, height: 400, child: Webview()),
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
              _cancelActivity();
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
