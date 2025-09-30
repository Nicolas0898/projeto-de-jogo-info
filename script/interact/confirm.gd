extends Control
class_name Confirm

var called_by : Node
@onready var question: Label = $Panel/VBoxContainer/VBoxContainer/question
@onready var yes: Button = $Panel/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $Panel/VBoxContainer/HBoxContainer/no

func called(q : String, node : Node):
	InteractionSystem.action = self
	called_by = node
	
	no.grab_focus()
	question.text = q
	
	Ui.fade_in(self)

func input(): #Quando ele escolhe
	get_viewport().gui_get_focus_owner().button_down.emit()


func _on_yes_button_down() -> void: #Confirmado
	called_by.answer(1)
	pass # Replace with function body.

func _on_no_button_down() -> void: #Recusado
	called_by.answer(0)
	pass # Replace with function body.
