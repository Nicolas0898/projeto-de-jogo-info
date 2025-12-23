extends Control
class_name Confirm

var called_by #called_by (identifica quem chamou)
var next_interface #next_interface (identifica a próxima tela após essa)
@onready var question: Label = $Panel/VBoxContainer/VBoxContainer/question
@onready var yes: Button = $Panel/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $Panel/VBoxContainer/HBoxContainer/no
var can_accept = false

#AO USAR CONFIRMAÇÃO: Deve ter uma função no código original para a "answer()"
# 0 = Recusou
# 1 = Aceitou
# ai calma miguel pires, chanceler das auras, era só falar q false recusava
# e true aceitava

@warning_ignore("shadowed_variable")
func called(q : String, called_by, next_interface): #"r" = return_to
	Ui.set_current_active("Confirm")
	
	self.called_by = called_by
	self.next_interface = next_interface.name
	
	question.text = q

func on_active():
	no.grab_focus()

func close_menu():
	Ui.set_current_active(next_interface)

func _on_yes_button_down() -> void: #Confirmado
	if called_by!= null:
		called_by.call_deferred("answer" ,true)
		close_menu()

func _on_no_button_down() -> void: #Recusado
	if called_by!= null:
		called_by.call_deferred("answer" ,false)
		close_menu()
