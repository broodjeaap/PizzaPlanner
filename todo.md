# TODO

## Feature
- add search to recipes page
- add directory structure to recipes?
- share to/export of yaml of recipes
- add an import of recipes from raw url
    - maybe allow a 'dir' yaml, that just points to other raw pizza yaml urls
- add settings page
    - option for type of notification, full screen or just in the appbar
    - pick alarm sound
- deleting scheduled pizza events
- archiving past pizza events
- foto mode for pizza event
    - push to instagram ?
    
## Refactor
- RecipeStep.waitUnit should probably be an enum?
- refactor to const page names instead of loose strings everywhere ('/path/page')
    - also do this with hive box names
    
## Bug
- add option to start recipe step instruction after step datetime and not completed
- recalculate ingredient ratios to total=1 before saving when creating/editing recipes
- when deleting recipes, it deletes 2, but not when deleting the last one