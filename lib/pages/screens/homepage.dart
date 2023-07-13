import 'package:flutter/material.dart';
import 'package:zenith/helpers/mooddata.dart';
import 'package:zenith/models/moodcard.dart';
import 'package:zenith/widgets/mooddaycard.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    loader = Provider.of<MoodCard>(context, listen: true).isloading;
    return loader
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text('Your Moods'),
              backgroundColor: Colors.red,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.show_chart),
                  onPressed: () => Navigator.of(context).pushNamed('/chart'),
                ),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_moods')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data!.docs;
                int count = 0;

                var moodCardProvider =
                    Provider.of<MoodCard>(context, listen: false);
                moodCardProvider.actiname.clear();
                moodCardProvider.data.clear();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, int position) {
                    var doc = docs[position];
                    var data = doc.data() as Map<String, dynamic>?;
                    count++;

                    if (data == null) {
                      return SizedBox.shrink();
                    }

                    var imageString = data['actimage'];
                    List<String> img = [];
                    if (imageString != null) {
                      img = imageString.split('_');
                    }
                    var nameString = data['actname'];
                    List<String> name = [];
                    if (nameString != null) {
                      name = nameString.split('_');
                    }
                    moodCardProvider.actiname.addAll(name);

                    moodCardProvider.data.add(
                      MoodData(
                        data['mood'] == 'Angry'
                            ? 1
                            : data['mood'] == 'Happy'
                                ? 2
                                : data['mood'] == 'Sad'
                                    ? 3
                                    : data['mood'] == 'Surprised'
                                        ? 4
                                        : data['mood'] == 'Loving'
                                            ? 5
                                            : data['mood'] == 'Scared'
                                                ? 6
                                                : 7,
                        doc.id, // Use the document ID as the date for the mood card
                        data['mood'] == 'Angry'
                            ? charts.ColorUtil.fromDartColor(Colors.red)
                            : data['mood'] == 'Happy'
                                ? charts.ColorUtil.fromDartColor(Colors.blue)
                                : data['mood'] == 'Sad'
                                    ? charts.ColorUtil.fromDartColor(
                                        Colors.green)
                                    : data['mood'] == 'Surprised'
                                        ? charts.ColorUtil.fromDartColor(
                                            Colors.pink)
                                        : data['mood'] == 'Loving'
                                            ? charts.ColorUtil.fromDartColor(
                                                Colors.purple)
                                            : data['mood'] == 'Scared'
                                                ? charts.ColorUtil
                                                    .fromDartColor(Colors.black)
                                                : charts.ColorUtil
                                                    .fromDartColor(
                                                        Colors.white),
                      ),
                    );

                    return MoodDay(
                      doc.id,
                      data['image'],
                      data['date'],
                      data['mood'],
                      img.toList(),
                      name.toList(),
                    );
                  },
                );
              },
            ),
          );
  }
}