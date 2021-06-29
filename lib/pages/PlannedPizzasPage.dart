import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlannedPizzasPage extends StatefulWidget {
  @override
  PlannedPizzasState createState() => PlannedPizzasState();
}

class PlannedPizzasState extends State<PlannedPizzasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planned Pizzas"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.blueAccent,
            child: const Center(child: Text("Pizza!"))
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: "Add Pizza",
        child: Icon(Icons.add)
      ),
    );
  }
}