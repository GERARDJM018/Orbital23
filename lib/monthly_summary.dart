import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:zenith/datetime/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now().add(Duration(days: 0)),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Color.fromARGB(255, 254, 254, 254),
        textColor: Color.fromARGB(255, 84, 81, 81),
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: const {
          1: Color.fromARGB(255, 255, 255, 255), // White
          2: Color.fromARGB(240, 255, 216, 0), // Lightest orange
          3: Color.fromARGB(220, 255, 165, 0), // Light orange
          4: Color.fromARGB(200, 255, 140, 0),
          5: Color.fromARGB(180, 255, 127, 0),
          6: Color.fromARGB(160, 255, 102, 0), // Medium orange
          7: Color.fromARGB(140, 255, 97, 0),
          8: Color.fromARGB(120, 255, 85, 0),
          9: Color.fromARGB(100, 255, 69, 0), // Dark orange
          10: Color.fromARGB(80, 255, 50, 0), // Darkest orange
        },
        onClick: (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
