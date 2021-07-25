import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/dao/AppDao.dart';
import 'package:pizzaplanner/widgets/PizzaRecipeWidget.dart';

class PickPizzaRecipePage extends StatefulWidget {
  @override
  PickPizzaRecipePageState createState() => PickPizzaRecipePageState();
}

class PickPizzaRecipePageState extends State<PickPizzaRecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Pizza2 Event"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 80,
                  child: FutureBuilder(
                      future: AppDao.getPizzaRecipes(),
                      builder: (BuildContext context, AsyncSnapshot<List<PizzaRecipe>> snapshot) {
                        if (snapshot.hasData && !snapshot.hasError){
                          return ListView(
                            children: snapshot.data!.map((pizzaRecipe) {
                              return PizzaRecipeWidget(pizzaRecipe);
                            }).toList(),
                          );
                        } else if (snapshot.hasError){
                          print(snapshot.error);
                          return Text("Something went wrong");
                        } else {
                          return Text("Loading Pizza Recipes");
                        }
                      }
                  )
                ),
                Divider(),
                SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Container(
                        color: Colors.blue,
                        child: TextButton(
                          child: Text("Review", style: TextStyle(color: Colors.white)),
                          onPressed: () {
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
