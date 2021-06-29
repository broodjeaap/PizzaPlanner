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
              height: 100,
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
      child: Column(
        children: <Widget>[
          Text(plannedPizza.name),
          Text(dateFormatter.format(plannedPizza.dateTime)),
          Text(this.getTimeRemainingString())
        ]
      )
    );
  }

  String getTimeRemainingString(){
    DateTime now = DateTime.now();
    Duration duration = plannedPizza.dateTime.difference(now);
    if (duration.inHours <= 0) {
      return "In ${duration.inMinutes} minutes!";
    }
    if (duration.inDays <= 0) {
      return "In ${duration.inHours} hours";
    }
    if (duration.inDays <= 31) {
      return "In ${duration.inDays} days";
    }
    return "In ${(duration.inDays / 7).floor()} weeks";
  }
}