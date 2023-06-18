import 'package:flutter/material.dart';
import 'package:zenith/helpers/mooddata.dart';
import 'package:zenith/models/moodcard.dart';
import 'package:zenith/widgets/mooddaycard.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_core/firebase_core.dart';
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
                    onPressed: () => Navigator.of(context).pushNamed('/chart'))
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

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, int position) {
                    var doc = docs[position];
                    var data = doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return SizedBox
                          .shrink(); // Return an empty widget or handle the null case appropriately
                    }

                    var imageString = data['actimage'];
                    List<String> img = imageString.split('_');
                    List<String> name = data['actname'].split("_");
                    Provider.of<MoodCard>(context, listen: false)
                        .actiname
                        .addAll(name);

                    Provider.of<MoodCard>(context, listen: false).data.add(
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
                            data['date'],
                            data['mood'] == 'Angry'
                                ? charts.ColorUtil.fromDartColor(Colors.red)
                                : data['mood'] == 'Happy'
                                    ? charts.ColorUtil.fromDartColor(
                                        Colors.blue)
                                    : data['mood'] == 'Sad'
                                        ? charts.ColorUtil.fromDartColor(
                                            Colors.green)
                                        : data['mood'] == 'Surprised'
                                            ? charts.ColorUtil.fromDartColor(
                                                Colors.pink)
                                            : data['mood'] == 'Loving'
                                                ? charts.ColorUtil
                                                    .fromDartColor(
                                                        Colors.purple)
                                                : data['mood'] == 'Scared'
                                                    ? charts.ColorUtil
                                                        .fromDartColor(
                                                            Colors.black)
                                                    : charts.ColorUtil
                                                        .fromDartColor(
                                                            Colors.white),
                          ),
                        );

                    return MoodDay(
                      doc.id,
                      data['image'],
                      data['datetime'],
                      data['mood'],
                      img.toList(), // problems are here
                      name.toList(), //
                    );
                  },
                );
              },
            ),
          );
  }
}
