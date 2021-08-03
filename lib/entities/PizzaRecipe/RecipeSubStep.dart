
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/pages/PizzaEventPage.dart';

part 'RecipeSubStep.g.dart';

@HiveType(typeId: 3)
class RecipeSubStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? completedOn;

  bool get completed => completedOn != null;

  RecipeSubStep(this.name, this.description);

  Widget buildPizzaEventSubStepWidget(BuildContext context, PizzaEventPageState pizzaEventPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(this.name),
        Checkbox(
          value: this.completed,
          onChanged: (bool? newValue) async {
            if (newValue == null){
              return;
            }
            if (newValue){
              this.completedOn = DateTime.now();
            } else {
              this.completedOn = null;
            }
            await pizzaEventPage.widget.pizzaEvent.save();
            pizzaEventPage.triggerSetState();
          },
        )
      ],
    );
  }

  Widget buildTest(BuildContext context, PizzaEventPageState pizzaEventPage){
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return getDialog(context);
          }
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(this.name),
          Checkbox(
            value: this.completed,
            onChanged: (b) {},
          )
        ],
      ),
    );
  }

  Widget getDialog(BuildContext context){
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Text(this.name),
            Text(this.description),
            Expanded(
              child: Container()
            ),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: Container(
                color: this.completed ? Colors.green : Colors.redAccent,
                child: TextButton(
                  child: Text(this.completed ? "Complete" : "Todo", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    this.completedOn = this.completed ? null : DateTime.now();
                  },
                )
              )
            )
          ]
        )
      )
    );
  }
}