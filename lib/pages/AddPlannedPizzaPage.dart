import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class AddPlannedPizzaPage extends StatefulWidget {
  @override
  AddPlannedPizzaPageState createState() => AddPlannedPizzaPageState();
}

class AddPlannedPizzaPageState extends State<AddPlannedPizzaPage> {
  String name = "";
  String pizzaType = "Neapolitan";
  int pizzaCount = 1;
  int doughBallSize = 250;
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
            Row(
              children: <Widget>[
                Icon(Icons.title),
                Container(width: 25),
                Expanded(
                    child: TextField(
                    decoration: InputDecoration(
                        hintText: "Event Name"
                    ),
                    onChanged: (String newName) {
                      setState(() {
                        name = newName;
                      });
                    },
                  ),
                )
              ]
            ),
            Row(
              children: <Widget>[
                Icon(FontAwesome5.pizza_slice),
                Container(width: 25),
                Expanded(
                    child: DropdownButton<String>(
                      value: pizzaType,
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
                )
              ]
            ),
            Row(
              children: <Widget>[
                Icon(FontAwesome5.hashtag),
                Expanded(
                  child: Slider(
                    value: pizzaCount.toDouble(),
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: this.pizzaCount.toString(),
                    onChanged: (double newPizzaCount) {
                      setState(() {this.pizzaCount = newPizzaCount.round();});
                    },
                  )
                ),
                Container(
                  width: 25,
                  child: Text(this.pizzaCount.toString())
                )
              ]
            ),

            Row(
              children: <Widget>[
                Icon(FontAwesome5.weight_hanging),
                Expanded(
                  child: Slider(
                    value: doughBallSize.toDouble(),
                    min: 100,
                    max: 400,
                    divisions: 30,
                    label: this.doughBallSize.toString(),
                    onChanged: (double newDoughBallSize) {
                      setState(() {this.doughBallSize = newDoughBallSize.round();});
                    },
                  )
                ),
                Container(
                  width: 25,
                  child: Text(this.doughBallSize.toString())
                )
              ]
            ),

          ]
        )
      )
    );
  }
}