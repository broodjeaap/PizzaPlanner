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
          child: ListView(
            children: this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) {
              int recipeSubStepsCompleted = recipeStep.subSteps.where((subStep) => subStep.completed).length;
              int recipeSubSteps = recipeStep.subSteps.length != 0 ? recipeStep.subSteps.length : 1;
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(FontAwesome5.sitemap),
                    Text(recipeStep.name),
                    Text("$recipeSubStepsCompleted/$recipeSubSteps")
                  ],
                ),
                children: <Widget>[
                  Text(recipeStep.description),

                  ] + recipeStep.subSteps.map((subStep) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subStep.name),
                      Checkbox(
                        value: subStep.completed,
                        onChanged: (bool? newValue) async {
                          if (newValue == null){
                            return;
                          }
                          if (newValue){
                            subStep.completedOn = DateTime.now();
                          } else {
                            subStep.completedOn = null;
                          }
                          await this.widget.pizzaEvent.save();
                          setState(() {});
                        },
                      )
                    ],
                  );
                }).toList(),
              );
            }).toList(),
          )
        )
    );
  }
}