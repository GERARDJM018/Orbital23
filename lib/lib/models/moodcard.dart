import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenith/helpers/mooddata.dart';
import 'package:zenith/models/activity.dart';

class MoodCard extends ChangeNotifier {
  List<Activity> activities = [];

  void clearSelectedActivities() {
    activities.clear();
  }

  void add(Activity activity) {
    // Check if the activity already exists in the activities list
    if (!activities.contains(activity)) {
      activities.add(activity);
      activityimage.add(activity.image);
      activityname.add(activity.name);
      notifyListeners();
    }
  }

  void delete(Activity activity) {
    activities.remove(activity);
    activityimage.remove(activity.image);
    activityname.remove(activity.name);

    notifyListeners();
  }

  String? mood;
  List<String> activityname = [];
  List<String> activityimage = [];
  String? image;
  String? actimage;
  String? actname;
  MoodCard({this.actimage, this.actname, this.date, this.image, this.mood});
  late List items;
  List<MoodData> data = [];

  late String? date;
  bool isloading = false;
  List<String> actiname = [];

  Future<void> addPlace(String date, String mood, String image, String actimage,
      String actname) async {
    List<String> uniqueActivityImage = activityimage.toSet().toList();
    List<String> uniqueActivityName = activityname.toSet().toList();
    await FirebaseFirestore.instance.collection('user_moods').add({
      'date': date,
      'mood': mood,
      'image': image,
      'actimage': actimage,
      'actname': actname,
    });
    Activity activity = Activity(actimage, actname, false);
    add(activity);
    activityimage.clear();
    activityname.clear();

    // Add the unique activity images and names back to the lists
    activityimage.addAll(uniqueActivityImage);
    activityname.addAll(uniqueActivityName);
    notifyListeners();
  }

  Future<void> deletePlaces(String docId) async {
    await FirebaseFirestore.instance
        .collection('user_moods')
        .doc(docId)
        .delete();
    notifyListeners();
    activities.clear();
  }
}
