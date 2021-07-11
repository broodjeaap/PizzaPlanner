import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';

class Ingredients {
  final Map<String, Ingredient> ingredients;
  final String method;

  Ingredients(this.ingredients, this.method);

  Table getIngredientsTable(int pizzaCount, int doughBallSize) {
    return Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children:
        <TableRow>[
          TableRow(
              children: <TableCell>[
                TableCell(child: Center(child: Text("Ingredient"))),
                TableCell(child: Center(child: Text("Single Ball"))),
                TableCell(child: Center(child: Text("Total"))),
              ]
          )

        ] +
            ingredients.values.map((ingredient) =>
                ingredient.getIngredientTableRow(pizzaCount, doughBallSize))
                .toList()
    );
  }
}