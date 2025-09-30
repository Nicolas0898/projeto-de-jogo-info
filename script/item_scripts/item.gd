extends Resource
class_name Item

enum types{
	utilitario,
	descritivo,
}

@export var name : String
@export var desc : String
@export var amount : int = 1
@export var type : types
@export var sprite : Texture
@export var confirm : bool
