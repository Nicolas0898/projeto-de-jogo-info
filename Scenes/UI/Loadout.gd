extends Control
# Scenes
const BUTTON = preload("uid://cc7ey273nnqe7")

# Variables
var hability_input = ["magic1","magic2","magic3"]
var weapon_input = ["use_weapon"]
var scroll_size
var nodes = []
var active = null
var tween_time = 0.1
var loaded = {}

var weapons:Array[LoadoutItem] = [preload("uid://k36ginnnsxes"),preload("uid://bm57sdw1t1isi")]
var habilities:Array[LoadoutItem] = [preload("uid://k36ginnnsxes"),preload("uid://br5tlf52ooctl")]

# Nodes
@onready var hability_node: VBoxContainer = $hability
@onready var weapon_node: VBoxContainer = $weapon
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var list: VBoxContainer = $ScrollContainer/VBoxContainer


func create_button(parent,input):
	var button:Button = BUTTON.instantiate()
	parent.add_child(button)
	button.set_meta("input",input)
	nodes.push_back(button)
	
	button.pressed.connect(func():
		if active:
			await hide_scroll(active==button)
		
		if active!=button:
			
			show_scroll(button)
			active = button
		else:
			active = null
		)



func hide_scroll(show_nodes):
	var tween = create_tween()
	
	if show_nodes:
		for i in nodes:
			tween.parallel().tween_property(i,"modulate",Color(1,1,1,1),tween_time)
	
	tween.parallel().tween_property(scroll_container,"modulate",Color(1,1,1,0),tween_time) 
	await tween.finished

func load_item(item:LoadoutItem,node:Button):
	if loaded.has(node):
		loaded[node].unequip()
	
	node.update(item)
	
	loaded[node] = item
	item.equip(node.get_meta("input"))

func show_scroll(node:Button):
	scroll_container.position = node.global_position - Vector2(scroll_container.size.x/2 - node.size.x/2,scroll_container.size.y/2 - node.size.y/2)
	
	for i in list.get_children():
			i.queue_free()
	
	var load_from = null
	
	if node.get_parent() == hability_node:
		scroll_container.position.x+=50
		load_from = habilities
	else:
		scroll_container.position.x -= 50
		load_from = weapons
	
	for item:LoadoutItem in load_from:
		var itemframe:Button = BUTTON.instantiate()
		itemframe.update(item)
		itemframe.pressed.connect(func():
			load_item(item,node)
			hide_scroll(true)
			active = null
			)
		
		list.add_child(itemframe)
	
	var tween = create_tween()
	
	for i in nodes:
		if i==node:continue
		tween.parallel().tween_property(i,"modulate",Color(1,1,1,0.1),tween_time)
	tween.parallel().tween_property(node,"modulate",Color(1,1,1,1),tween_time)
	tween.parallel().tween_property(scroll_container,"modulate",Color(1,1,1,1),tween_time) 

func _ready() -> void:
	scroll_size = scroll_container.size
	for i in hability_input:
		create_button(hability_node,i)

	for i in weapon_input:
		create_button(weapon_node,i)
		
	nodes.push_back($hability/Label2)
	nodes.push_back($weapon/Label)
	
	load_item(weapons[1],nodes[3])
	
