extends Control
class_name Inventory

var open : bool = false
var selected : Button = null #Botão selecionado
var displaying : Array #Itens que estão dentro dos botões
var buttons : Array #Botões que estão sendo mostrados
var c : Array #Itens em cooldown
@export var inventario : Array[Item] #Itens no inventário

@onready var item_display = preload("res://scenes/item_display.tscn")
@onready var desc: GridContainer = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Panel2/desc
@onready var util: GridContainer = $Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/util

@onready var desc_tittle: Label = $Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/desc_tittle
@onready var desc_text: Label = $Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/desc_text
@onready var status_label: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/status_label

func refreshing():
	if not GameHandler.Player: return
	status_label.text = 'Vida: ' + str(GameHandler.Player.health_component.health)\
	+ '\nDinheiro: '+ str(GameHandler.total_coins)
	
	for i in range(len(inventario)):
		if inventario[i].amount <= 0: #Caso seja removido do inventário
			if inventario[i] == selected.i: selected = buttons[i - 1] if i - 1 >= 0 else null
			
			if inventario[i].display == 0: util.get_node(inventario[i].name).queue_free()
			if inventario[i].display == 1: desc.get_node(inventario[i].name).queue_free()
			displaying[i] = null
			inventario[i] = null
			buttons[i] = null
		else:
			if inventario[i] in displaying:
				if inventario[i].display == 0: util.get_node(inventario[i].name).amount.text = str(inventario[i].amount) #util
				if inventario[i].display == 1: desc.get_node(inventario[i].name).amount.text = str(inventario[i].amount) #desc
				if inventario[i] in c: Ui.cooldown(c[c.find(inventario[i])].t, buttons[i].progress_bar)
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
				
				if inventario[i] in c: Ui.cooldown(c[c.find(inventario[i])].t, buttons[i].progress_bar)
	
	
	if selected == null and len(buttons) > 0: selected = buttons[0]
	while inventario.has(null): inventario.erase(null)
	while displaying.has(null): displaying.erase(null)
	while buttons.has(null): buttons.erase(null)

func refresh_desc(i : Item):
	desc_tittle.text = i.name
	desc_text.text = i.desc

func interact():
	if selected.i.display == 1: return #Se for apenas um display
	if selected.i in c: return #Se estiver no cooldown
	
	selected.i.use(GameHandler.Player, self)

func change_amount(i : Item, amount : int):
	if not i in Ui.inventory.inventario and amount > 0: Ui.inventory.inventario.append(i)
	
	i.amount+=amount
	if i.amount < 0: i.amount = 0
	
	refreshing()


func find_item(item_name : String): #Retorna o índice do item no inventário
	for i in range(len(inventario)): if inventario[i].name == item_name: return i


func input():
	if InteractionSystem.action != null and not InteractionSystem.action is Inventory: return
	
	open = not open
	InteractionSystem.action = self if InteractionSystem.action == null else null
	
	refreshing()
	
	if open:
		selected.grab_focus()
	else:
		get_viewport().gui_release_focus()
	
	await Ui.fade_in(self) if open else await Ui.fade_out(self)

func _ready():
	refreshing()

func _physics_process(_delta: float) -> void:
	pass
