extends Control
class_name Confirm

var cb #called_by (identifica quem chamou)
var ni #next_interface (identifica a próxima tela após essa)
@onready var question: Label = $Panel/VBoxContainer/VBoxContainer/question
@onready var yes: Button = $Panel/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $Panel/VBoxContainer/HBoxContainer/no


#AO USAR CONFIRMAÇÃO: Deve ter uma função no código original para a "answer()"
# 0 = Recusou
# 1 = Aceitou

func called(q : String, called_by, next_interface): #"r" = return_to
	InteractionSystem.action = self
	ni = next_interface
	cb = called_by
	
	no.grab_focus()
	question.text = q
	
	Ui.fade_in(self)

func input(): #Quando ele escolhe
	InteractionSystem.action = null
	get_viewport().gui_get_focus_owner().button_down.emit()
	get_viewport().gui_release_focus()
	Ui.fade_out(self)
	
	if ni is Inventory: Ui.inventory.call_deferred("input")


func _on_yes_button_down() -> void: #Confirmado
	cb.call_deferred("answer" ,true)

func _on_no_button_down() -> void: #Recusado
	
	cb.call_deferred("answer" ,false)
