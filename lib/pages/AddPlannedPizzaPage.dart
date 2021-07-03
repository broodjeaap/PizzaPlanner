import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPlannedPizzaPage extends StatefulWidget {
  @override
  AddPlannedPizzaPageState createState() => AddPlannedPizzaPageState();
}

class AddPlannedPizzaPageState extends State<AddPlannedPizzaPage> {
  String name = "";
  String pizzaType = "Neapolitan";
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
                setState(() {
                  pizzaType = newType!;
                });
              },
              items: <String>["Neapolitan", "New York", "Chicago"]
                .map<DropdownMenuItem<String>>((String v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text(v)
                );
              }).toList()
            ),

          ]
        )
      )
    );
  }
}