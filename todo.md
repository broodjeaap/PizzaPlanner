# TODO

## Feature
- add 'capturing' sharing intent
- maybe allow a 'dir' yaml when importing from url, that just points to other raw pizza yaml urls
- add settings page
    - option for type of notification, full screen or just in the appbar
    - pick alarm sound
- foto mode for pizza event
    - push to instagram ?
    
## Refactor
- RecipeStep.waitUnit should probably be an enum?
- refactor to const page names instead of loose strings everywhere ('/path/page')
    - also do this with hive box names
- make the url fetching less shit
    - probably use a stream for adding to the listview ?
    
## Bug
- add option to start recipe step instruction after step datetime and not completed
- recalculate ingredient ratios to total=1 before saving when creating/editing recipes
- when deleting recipes, it deletes 2, but not when deleting the last one
- user should only be able to archive a pizza event that has taken place (dateTime>now)