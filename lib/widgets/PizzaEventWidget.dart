import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/util.dart';

class PizzaEventWidget extends StatelessWidget {
  final PizzaEvent pizzaEvent;

  PizzaEventWidget(this.pizzaEvent);

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
                      Text(this.getTimeRemainingString())
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 72,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                  color: Colors.green,
                                  child: Container()
                              )
                          ),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                  color: Colors.green,
                                  child: Container()
                              )
                          ),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                  color: Colors.green,
                                  child: Container()
                              )
                          ),
                          SizedBox(
                              width: 50,
                              height: 50,
                              child: Container(
                                  color: Colors.green,
                                  child: Container()
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

  String getTimeRemainingString(){
    DateTime now = DateTime.now();
    Duration duration = pizzaEvent.dateTime.difference(now);
    Duration absDuration = duration.abs();
    String durationString = "";
    if (absDuration.inHours <= 0 && absDuration.inMinutes > 0) {
      durationString = "${absDuration.inMinutes} minute" + (absDuration.inMinutes > 1 ? "s" : "");
    }
    else if (absDuration.inDays <= 0 && absDuration.inHours > 0) {
      durationString = "${absDuration.inHours} hours";
    }
    else if (absDuration.inDays <= 31) {
      durationString = "${absDuration.inDays} day" + (absDuration.inDays > 1 ? "s" : "");
    }
    else {
      durationString = "${(absDuration.inDays / 7).floor()} week" + (absDuration.inDays >= 14 ? "s" : "");
    }
    return duration.isNegative ? "$durationString ago" : "In $durationString";
  }
}