extends Control
class_name Inventory

var open : bool = false
var selected : Button = null
var displaying : Array
var buttons : Array
@export var inventario : Array[Item]

@onready var item_display = preload("res://scenes/item_display.tscn")
@onready var desc: GridContainer = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Panel2/desc
@onready var util: GridContainer = $Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/util

@onready var desc_tittle: Label = $Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/desc_tittle
@onready var desc_text: Label = $Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/desc_text
@onready var status_label: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/status_label

func refreshing():
	status_label.text = 'Vida: ' + str(CharacterBody2d.hp) + '\nDinheiro: \nEtc... (adicionar depois)'
	
	for i in range(len(inventario)):
		if inventario[i].amount <= 0: #Caso seja removido do inventário
			if inventario[i].display == 0: util.get_node(inventario[i].name).queue_free()
			if inventario[i].display == 1: desc.get_node(inventario[i].name).queue_free()
			displaying[i] = null
			inventario[i] = null
			buttons[i] = null
		else:
			if inventario[i] in displaying:
				if inventario[i].display == 0: util.get_node(inventario[i].name).amount.text = str(inventario[i].amount) #util
				if inventario[i].display == 1: desc.get_node(inventario[i].name).amount.text = str(inventario[i].amount) #desc
			else:
				var display = item_display.instantiate()
				display.i = inventario[i]
				display.name = inventario[i].name
				if inventario[i].display == 0: util.add_child(display) #util
				if inventario[i].display == 1: desc.add_child(display) #desc
				
				display.sprite.texture = inventario[i].sprite
				display.amount.text = str(inventario[i].amount)
				displaying.append(inventario[i])
				buttons.append(display)
	
	if selected == null and len(buttons) > 0: selected = buttons[0]
	while inventario.has(null): inventario.erase(null)
	while displaying.has(null): displaying.erase(null)
	while buttons.has(null): buttons.erase(null)

func refresh_desc(i : Item):
	desc_tittle.text = i.name
	desc_text.text = i.desc

func interact():
	if selected.i.display == 1: return
	
	if selected.i.confirm:
		input()
		Ui.confirm.called("Você deseja usar " + str(selected.i.name), self)
	else:
		use()


#func find_button(item : Item):
#	for i in range(len(displaying)):
#		if displaying[i].i == item: return displaying[i]


func use():
	inventario[inventario.find(selected.i)].use()
	if inventario[inventario.find(selected.i)].cooldown > 0:
		Ui.cooldown(inventario[inventario.find(selected.i)].cooldown, selected.progress_bar)
		
		#Ui.cooldown(inventario[inventario.find(selected.i)].cooldown, )
	
	refreshing()
	if len(buttons) > 0: selected = buttons[0]
	selected.grab_focus()

func answer(a : bool): #0 = false, 1 = true
	InteractionSystem.action = null
	if(a == true): use()
	input()



func _ready():
	refreshing()

func input():
	if InteractionSystem.action != null and not InteractionSystem.action is Inventory: return
	
	open = not open
	InteractionSystem.action = self if InteractionSystem.action == null else null
	
	if open:
		selected.grab_focus()
	else:
		get_viewport().gui_release_focus()
	
	await Ui.fade_in(self) if open else await Ui.fade_out(self)
