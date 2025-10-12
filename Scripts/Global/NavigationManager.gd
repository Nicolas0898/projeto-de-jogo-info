extends Node

const room_1 = preload("res://Scenes/Map/SR1.tscn")
const boss_room = preload("res://Scenes/Map/SBR.tscn")


var spawn_room

func go_to_level(actual_level,destination):
	var level_to_be_changed
	
	match destination:
		"room_1":
			level_to_be_changed = room_1
		"boss_room":
			level_to_be_changed = boss_room
	
	if level_to_be_changed != null:
		spawn_room = destination
		get_tree().change_scene_to_packed(level_to_be_changed)
