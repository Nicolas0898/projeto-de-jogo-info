extends Control
class_name Confirm

var called_by : Node
@onready var question: Label = $Panel/VBoxContainer/VBoxContainer/question
@onready var yes: Button = $Panel/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $Panel/VBoxContainer/HBoxContainer/no


#AO USAR CONFIRMAÇÃO: Deve ter uma função no código original para a "answer()"
# 0 = Recusou
# 1 = Aceitou

func called(q : String, node : Node):
	InteractionSystem.action = self
	called_by = node
	
	no.grab_focus()
	question.text = q
	
	Ui.fade_in(self)

func input(): #Quando ele escolhe
	get_viewport().gui_get_focus_owner().button_down.emit()

func _on_yes_button_down() -> void: #Confirmado
	get_viewport().gui_release_focus()
	Ui.fade_out(self)
	called_by.call_deferred("answer" ,true)

func _on_no_button_down() -> void: #Recusado
	get_viewport().gui_release_focus()
	called_by.call_deferred("answer" ,false)
	Ui.fade_out(self)
