extends Node2D
class_name GrappleNode

enum {SWING,PULL}

@export var range := 300.0
@export_enum("Swing","Pull") var type = 0
@export var enabled := true
