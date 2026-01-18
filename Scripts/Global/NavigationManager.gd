extends Node

var spawn_room

func go_to_level(actual_level:String,destination:String):
	GameHandler.roomswocoins.push_back(actual_level)
	GameHandler.spawnpoint = actual_level.to_lower()
	var level_to_be_changed = load("res://Scenes/Map/"+destination+".tscn")
	
	if level_to_be_changed != null:
		spawn_room = destination
		get_tree().change_scene_to_packed(level_to_be_changed)
