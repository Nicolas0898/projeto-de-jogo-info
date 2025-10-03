extends Item
class_name hp_potion

@export var hp : float

func use():
	CharacterBody2d.hp+=hp
	amount-=1
