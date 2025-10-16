extends Node
class_name SpawnLocation
@export var spawn:Dictionary[String,Node2D]

func _ready() -> void:
	for index in spawn:
		spawn[index.to_lower()] = spawn[index]
