import 'package:pizzaplanner/entities/PizzaRecipe/Ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeSubStep.dart';

PizzaRecipe getNeapolitanCold() {
  return PizzaRecipe(
      "Neapolitan Cold Rise",
      "A Neapolitan Style pizza with a multi day cold rise",
      <Ingredient>[
        Ingredient("flour", "g", 0.595),
        Ingredient("water", "ml", 0.386),
        Ingredient("salt", "g", 0.0178),
        Ingredient("yeast", "g", 0.0012),
      ],
      <RecipeStep>[
        RecipeStep(
            "Make the dough",
            "Combine all the ingredients to make the dough, we start with just the water and salt and add the yeast after adding some of the flour to not kill the yeast.",
            "How many days cold rise?",
            "days",
            1,
            5,
            <RecipeSubStep>[
              RecipeSubStep(
                  "Salt+Water",
                  "Combine the salt and the water in a bowl, stir until the salt dissolves."
              ),
              RecipeSubStep(
                  "+20% flour",
                  "Add ~20% of the flour to the water/salt mixture and mix everything together."
              ),
              RecipeSubStep(
                  "Yeast",
                  "Add the yeast to the mixture."
              ),
              RecipeSubStep(
                  "Flour",
                  "Add the rest of the flour to the mixture, knead the dough for 15-20 minutes."
              ),
              RecipeSubStep(
                  "Fridge",
                  "Place the dough in a sealed/covered container in the fridge."
              ),
            ]
        ),
        RecipeStep(
            "Warm rise",
            "Take the dough out of the fridge and let it come to room temperature for a final rise before baking",
            "How many hours of room temperature rise?",
            "hours",
            3,
            6,
            <RecipeSubStep>[
              RecipeSubStep(
                  "Split",
                  "Split the dough into smaller balls and place them into a covered/sealed container(s)"
              ),
            ]
        ),
        RecipeStep(
            "Preheat Oven",
            """Preheat the oven in advance to ensure it's as hot as it can be.  
        A high temperature (250 to 300 degrees celsius) is recommended.""",
            "How long does your oven take to preheat?",
            "minutes",
            30,
            120,
            <RecipeSubStep>[]
        ),
        RecipeStep(
            "Pizza Time!",
            """Time to make pizza!""",
            "",
            "",
            0,
            0,
            <RecipeSubStep>[]
        ),
      ]
  );
}