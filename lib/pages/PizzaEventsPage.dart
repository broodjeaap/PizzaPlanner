import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/widgets/PizzaEventWidget.dart';

class PizzaEventsPage extends StatefulWidget {
  @override
  PizzaEventsState createState() => PizzaEventsState();
}

class PizzaEventsState extends State<PizzaEventsPage> {
  List<PizzaEvent> pizzaEvents = <PizzaEvent>[
    PizzaEvent("Movie Night", DateTime(2021, 6, 30, 12, 8)),
    PizzaEvent("Birthday Pizza", DateTime(2021, 7, 14, 18, 30)),
    PizzaEvent("Something else", DateTime(2021, 9, 3, 15, 3)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pizza Events"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
          itemCount: pizzaEvents.length,
          itemBuilder: (BuildContext context, int i) => PizzaEventWidget(pizzaEvents[i]),
          separatorBuilder: (BuildContext context, int i) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "/add",
          );
        },
        tooltip: "Add Pizza Plans",
        child: Center(
          child: Row(
            children: <Widget>[
              Icon(Icons.add),
              Icon(Icons.local_pizza_rounded),
            ]
          )
        )
      ),
    );
  }

  void addPizzaEvent(){
    this.setState(() {
      pizzaEvents.add(
          PizzaEvent("Added Pizza Party", DateTime(2022, 3, 23, 17, 45))
      );
    });
  }
}