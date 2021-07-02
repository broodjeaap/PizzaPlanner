import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizzaplanner/entities/PlannedPizza.dart';

class PlannedPizzasPage extends StatefulWidget {
  @override
  PlannedPizzasState createState() => PlannedPizzasState();
}

class PlannedPizzasState extends State<PlannedPizzasPage> {
  final List<PlannedPizza> plannedPizzas = <PlannedPizza>[
    PlannedPizza("Movie Night", DateTime(2021, 6, 30)),
    PlannedPizza("Birthday Pizza", DateTime(2021, 7, 14)),
    PlannedPizza("Something else", DateTime(2021, 9, 3)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planned Pizzas"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
          itemCount: plannedPizzas.length,
          itemBuilder: (BuildContext context, int i) {
            return Container(
              height: 150,
              color: Colors.blueAccent,
              child: PlannedPizzaWidget(plannedPizzas[i])
            );
          },
          separatorBuilder: (BuildContext context, int i) => const Divider(),
      ),
    );
  }
}

class PlannedPizzaWidget extends StatelessWidget {
  final DateFormat dateFormatter = DateFormat("yyyy-MM-dd");
  final PlannedPizza plannedPizza;

  PlannedPizzaWidget(this.plannedPizza);

  @override
  Widget build(BuildContext context){
    return Container(
      height: 100,
      color: Colors.blueAccent,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(plannedPizza.name),
                Text(this.getTimeRemainingString())
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    height: 50,
                    color: Colors.green,
                    child: Text("TEST")
                  );
                },
                separatorBuilder: (BuildContext context, int i) => const Divider(),
              ),
            ),
            Text(dateFormatter.format(plannedPizza.dateTime)),
          ]
        )
      )
    );
  }

  String getTimeRemainingString(){
    DateTime now = DateTime.now();
    Duration duration = plannedPizza.dateTime.difference(now);
    Duration absDuration = duration.abs();
    String durationString = "";
    if (absDuration.inHours <= 0 && absDuration.inMinutes > 0) {
      durationString = "${absDuration.inMinutes} minute" + (absDuration.inMinutes > 1 ? "s" : "");
    }
    else if (absDuration.inDays <= 0 && absDuration.inHours > 0) {
      durationString = "${absDuration.inHours} hours";
    }
    else if (absDuration.inDays <= 31) {
      durationString = "${absDuration.inDays} day" + (absDuration.inDays > 1 ? "s" : "");
    }
    else {
      durationString = "${(absDuration.inDays / 7).floor()} week" + (absDuration.inDays >= 14 ? "s" : "");
    }
    return duration.isNegative ? "$durationString ago" : "In $durationString";
  }
}