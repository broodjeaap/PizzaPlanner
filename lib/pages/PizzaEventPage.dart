import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';

class PizzaEventPage extends StatefulWidget {
  PizzaEvent pizzaEvent;

  PizzaEventPage(this.pizzaEvent);

  @override
  PizzaEventPageState createState() => PizzaEventPageState();
}

class PizzaEventPageState extends State<PizzaEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.pizzaEvent.name),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(10),
          child: this.widget.pizzaEvent.recipe.getPizzaEventRecipeWidget(this)
        )
    );
  }

  triggerSetState() => setState(() {});
}