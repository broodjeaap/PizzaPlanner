import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:url_launcher/url_launcher.dart';

class AddRecipePage extends StatefulWidget {
  final PizzaRecipe? pizzaRecipe;
  
  const AddRecipePage({this.pizzaRecipe});
  
  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage> {
  late PizzaRecipe pizzaRecipe;
  
  AddRecipePageState(){
    if (widget.pizzaRecipe == null){
      pizzaRecipe = PizzaRecipe(
        "",
        "",
        <Ingredient>[],
        <RecipeStep>[],
      );
    } else {
      pizzaRecipe = widget.pizzaRecipe!;
    }
  }

  bool nameValidation = false;
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Pizza Recipe"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    hintText: "Recipe Name",
                    errorText: nameValidation ? """Name can't be empty""" : null
                ),
                onChanged: (String newName) {
                  setState(() {
                    pizzaRecipe.name = newName;
                  });
                },
              ),
              const Divider(),
              TextField(
                decoration: InputDecoration(
                    hintText: "Recipe Description",
                    errorText: nameValidation ? """Description can't be empty""" : null
                ),
                maxLines: 8,
                onChanged: (String newDescription) {
                  setState(() {
                    pizzaRecipe.description = newDescription;
                  });
                },
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                          color: Colors.blue,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PreviewMarkdownDescription(pizzaRecipe.description);
                                  }
                              );
                            },
                            child: const Text("Preview", style: TextStyle(color: Colors.white)),
                          )
                      )
                  ),
                  const Expanded(
                    child: SizedBox()
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          color: Colors.blue,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              launch("https://guides.github.com/features/mastering-markdown/");
                            },
                            child: const Text("Markdown?", style: TextStyle(color: Colors.white)),
                          )
                      )
                  )
                ],
              ),
              const Divider(),
              const Center(
                child: Text("Ingredients")
                    
              ),
              const Divider(),
              Container(
                  color: Colors.blue,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        pizzaRecipe.ingredients.add(
                            Ingredient(
                                "",
                                "",
                                0.0
                            )
                        );
                      });
                    },
                    child: const Text("Add Ingredient", style: TextStyle(color: Colors.white)),
                  )
              ),
              const Divider(),
            ] + pizzaRecipe.ingredients.map((ingredient) => buildIngredientRow(ingredient)).toList() + [
              
            ],
          )
        )
    );
  }
  
  Widget buildIngredientRow(Ingredient ingredient){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: TextField(
            decoration: const InputDecoration(
              hintText: "Name",
            ),
            controller: TextEditingController(text: ingredient.name),
            onChanged: (String newName) {
              setState(() {
                ingredient.name = newName;
              });
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: const InputDecoration(
                hintText: "Value",
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: ingredient.value.toString()),
            onChanged: (String newValue) {
              setState(() {
                final newDouble = double.tryParse(newValue);
                if (newDouble == null){
                  return;
                }
                ingredient.value = newDouble;
              });
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: const InputDecoration(
                hintText: "Unit",
            ),
            controller: TextEditingController(text: ingredient.unit),
            onChanged: (String newUnit) {
              setState(() {
                ingredient.unit = newUnit;
              });
            },
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              setState(() {
                pizzaRecipe.ingredients.remove(ingredient);
              });
            },
            child: const Text("X", style: TextStyle(color: Colors.red)),
          )
        )
      ]
    );
  }
}

class PreviewMarkdownDescription extends StatelessWidget {
  final String description;
  
  const PreviewMarkdownDescription(this.description);
  
  @override
  Widget build(BuildContext context){
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Markdown(
          data: description,
          onTapLink: (text, url, title) {
            launch(url!);
          }
        )
      )
    );
  }
}