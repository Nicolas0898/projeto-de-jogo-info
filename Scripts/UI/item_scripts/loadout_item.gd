extends AbstractItem
class_name LoadoutItem

@export var instance:Script
@export var damage:float
@export var cooldown:float

var _node 

func equip(input="use_weapon"):
	if not instance: return
	_node = Node2D.new()
	_node.set_script(instance)
	_node.read_from = input
	_node.damage = damage
	_node.cooldown = cooldown
	
	print("CD:",cooldown," Damage:",damage)

	if not GameHandler.Player:
		await GameHandler.PlayerSpawned
	GameHandler.Player.add_child(_node)

func unequip():
	if _node:
		_node.queue_free()
		_node = null
