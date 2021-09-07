import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/util.dart';

class PizzaEventWidget extends StatelessWidget {
  final PizzaEvent pizzaEvent;

  const PizzaEventWidget(this.pizzaEvent);

  @override
  Widget build(BuildContext context){
    return Container(
        height: 120,
        color: Colors.blueAccent,
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(pizzaEvent.name),
                      Text(getTimeRemainingString(pizzaEvent.dateTime))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 72,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: IgnorePointer(
                                  child: Slider(
                                    max: pizzaEvent.recipe.recipeSteps.length.toDouble(),
                                    divisions: pizzaEvent.recipe.recipeSteps.length,
                                    value: pizzaEvent.recipe.getStepsCompleted().toDouble(),
                                    onChanged: (d) {},
                                    activeColor: Colors.green,
                                    inactiveColor: Colors.white,
                                  )
                              )
                          ),
                        ]
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(getDateFormat().format(pizzaEvent.dateTime)),
                      Text(pizzaEvent.recipe.name)
                    ],
                  ),

                ]
            )
        )
    );
  }
}