import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:url_launcher/url_launcher.dart';

class PizzaEventRecipePage extends StatefulWidget {
  final PizzaEvent pizzaEvent;
  PizzaEventRecipePage(this.pizzaEvent);
  
  @override
  PizzaEventRecipePageState createState() => PizzaEventRecipePageState();
}

class PizzaEventRecipePageState extends State<PizzaEventRecipePage> {
  final PageController controller = PageController();
  int page = 0;
  
  PizzaEventRecipePageState(){
    this.page = controller.initialPage;
  }
  
  @override
  Widget build(BuildContext context){
    var recipeStepCount = this.widget.pizzaEvent.recipe.recipeSteps.length;
    List<Text> pageIndex = [];
    for (var i = 0;i < recipeStepCount;i++){
      pageIndex.add(
        Text(
          "${i+1}",
          style: TextStyle(
              color: i == this.page ? Colors.blue : Colors.grey
          )
        )
      );
      if (i != recipeStepCount-1) {
        pageIndex.add(
            Text(" - ", style: TextStyle(color: Colors.grey))
        );
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.pizzaEvent.recipe.name),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 95,
              child: PageView(
                onPageChanged: (newPage) => setState(() {this.page = newPage;}),
                  controller: controller,
                  children: <Widget>[
                    Markdown(
                      data: this.widget.pizzaEvent.recipe.description,
                      onTapLink: (text, url, title) {
                        launch(url!);
                      },
                    ),
                  ] + this.widget.pizzaEvent.recipe.recipeSteps.map((recipeStep) => buildRecipeStep(recipeStep)).toList()
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
      )
    );
  }

  Widget buildRecipeStep(RecipeStep recipeStep) {
    return ListView(
      children: <Widget>[
        Center(
          child: Text(recipeStep.name)
        ),
        Container(
          padding: EdgeInsets.all(16),
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