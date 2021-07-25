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
          itemBuilder: (BuildContext context, int i) => const Divider(),// PizzaEventWidget(pizzaEvents[i]),
          separatorBuilder: (BuildContext context, int i) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dynamic newPizzaEvent = await Navigator.pushNamed(
            context,
            "/pickRecipe",
          );

          if (newPizzaEvent != null){
            this.addPizzaEvent(newPizzaEvent);
          }
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

  void addPizzaEvent(PizzaEvent pizzaEvent){
    this.setState(() {
      pizzaEvents.add(
          pizzaEvent
      );
    });
  }
}