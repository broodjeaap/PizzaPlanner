import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AddPlannedPizzaPage extends StatefulWidget {
  @override
  AddPlannedPizzaPageState createState() => AddPlannedPizzaPageState();
}

class AddPlannedPizzaPageState extends State<AddPlannedPizzaPage> {
  String name = "";
  String pizzaType = "Neapolitan";
  int pizzaCount = 1;
  int doughballSize = 200;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Planned Pizza"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: "Event Name"
              ),
              onChanged: (String newName) {
                setState(() {
                  name = newName;
                });
              },
            ),
            DropdownButton<String>(
              icon: const Icon(Icons.arrow_downward),
              value: pizzaType,
              isExpanded: true,
              onChanged: (String? newType) {
                setState(() => pizzaType = newType!);
              },
              items: <String>["Neapolitan", "New York", "Chicago"]
                .map<DropdownMenuItem<String>>((String v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text(v)
                );
              }).toList()
            ),
            Column(
              children: <Widget>[
                Text("# Of Pizzas: "),
                NumberPicker(
                  value: pizzaCount,
                  minValue: 1,
                  maxValue: 1000,
                  itemHeight: 30,
                  axis: Axis.horizontal,
                  onChanged: (newPizzaCount) => setState(() => this.pizzaCount = newPizzaCount),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                )
              ]
            ),
            Column(
                children: <Widget>[
                  Text("Doughball Size: "),
                  NumberPicker(
                    value: doughballSize,
                    minValue: 100,
                    maxValue: 10000,
                    step: 10,
                    itemHeight: 30,
                    axis: Axis.horizontal,
                    onChanged: (newDoughballSize) => setState(() => this.doughballSize = newDoughballSize),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  )
                ]
            ),
          ]
        )
      )
    );
  }
}