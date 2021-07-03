import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PlannedPizza.dart';
import 'package:pizzaplanner/widgets/PlannedPizzaWidget.dart';

class PlannedPizzasPage extends StatefulWidget {
  @override
  PlannedPizzasState createState() => PlannedPizzasState();
}

class PlannedPizzasState extends State<PlannedPizzasPage> {
  List<PlannedPizza> plannedPizzas = <PlannedPizza>[
    PlannedPizza("Movie Night", DateTime(2021, 6, 30, 12, 8)),
    PlannedPizza("Birthday Pizza", DateTime(2021, 7, 14, 18, 30)),
    PlannedPizza("Something else", DateTime(2021, 9, 3, 15, 3)),
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
          itemBuilder: (BuildContext context, int i) => PlannedPizzaWidget(plannedPizzas[i]),
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

  void addPlannedPizza(){
    this.setState(() {
      plannedPizzas.add(
          PlannedPizza("Added Pizza Party", DateTime(2022, 3, 23, 17, 45))
      );
    });
  }
}