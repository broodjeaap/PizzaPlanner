import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatefulWidget {
  static const String route = "/recipe/view";
  
  final PizzaRecipe pizzaRecipe;
  const RecipePage(this.pizzaRecipe);
  
  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  final PageController controller = PageController();
  int page = 0;
  
  RecipePageState(){
    page = controller.initialPage;
  }
  
  @override
  Widget build(BuildContext context){
    var recipeStepCount = widget.pizzaRecipe.recipeSteps.length;
    recipeStepCount += 1; // because of first description page
    final List<Text> pageIndex = [];
    for (var i = 0;i < recipeStepCount;i++){
      pageIndex.add(
        Text(
          "${i+1}",
          style: TextStyle(
              color: i == page ? Colors.blue : Colors.grey
          )
        )
      );
      if (i != recipeStepCount-1) {
        pageIndex.add(
            const Text(" - ", style: TextStyle(color: Colors.grey))
        );
      }
    }

    return PizzaPlannerScaffold(
        title: Text(widget.pizzaRecipe.name),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 95,
                child: PageView(
                    onPageChanged: (newPage) => setState(() {page = newPage;}),
                    controller: controller,
                    children: <Widget>[
                      Markdown(
                        data: widget.pizzaRecipe.description,
                        onTapLink: (text, url, title) {
                          launch(url!);
                        },
                      ),
                    ] + widget.pizzaRecipe.recipeSteps.map((recipeStep) => buildRecipeStep(recipeStep)).toList()
                )
            ),
            Expanded(
                flex: 5,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pageIndex
                )
            )
          ],
        ),
    );
  }

  Widget buildRecipeStep(RecipeStep recipeStep) {
    return ListView(
      children: <Widget>[
        Center(
          child: Text(recipeStep.name)
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: recipeStep.description,
            onTapLink: (text, url, title) {
              launch(url!);
            },
          )
        )
      ],
    );
  }
}