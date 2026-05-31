class_name LevelSaveData
extends Resource

## level_scores maps level_name -> Array of score dictionaries.
## Each dictionary contains:
##   score: int
##   fury: int
##   poise: int
##   flow: int
##   date_acquired: int  (unix timestamp)

@export var level_scores: Dictionary = {}
