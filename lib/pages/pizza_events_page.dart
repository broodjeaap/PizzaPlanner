import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/widgets/pizza_event_widget.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      body: Container(
        padding: EdgeInsets.all(10),
        child: ValueListenableBuilder(
            valueListenable: Hive.box<PizzaEvent>("PizzaEvents").listenable(),
            builder: (context, Box<PizzaEvent> box, widget) {
              if (box.isEmpty){
                return Container();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: box.length,
                itemBuilder: (BuildContext context, int i) => PizzaEventWidget(box.getAt(i)!),
                separatorBuilder: (BuildContext context, int i) => const Divider(),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final dynamic newPizzaEvent = await Navigator.pushNamed(
            context,
            "/event/pick_recipe",
          );

          if (newPizzaEvent != null){
            this.addPizzaEvent(newPizzaEvent as PizzaEvent);
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