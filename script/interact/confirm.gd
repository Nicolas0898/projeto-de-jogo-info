extends Control
class_name Confirm

var cb #called_by (identifica quem chamou)
var ni #next_interface (identifica a próxima tela após essa)
@onready var question: Label = $Panel/VBoxContainer/VBoxContainer/question
@onready var yes: Button = $Panel/VBoxContainer/HBoxContainer/yes
@onready var no: Button = $Panel/VBoxContainer/HBoxContainer/no
var can_accept = false

#AO USAR CONFIRMAÇÃO: Deve ter uma função no código original para a "answer()"
# 0 = Recusou
# 1 = Aceitou

func called(q : String, called_by, next_interface): #"r" = return_to
	can_accept = false
	GameHandler.Player.set_core(1)
	InteractionSystem.action = self
	ni = next_interface
	cb = called_by
	
	no.grab_focus()
	question.text = q
	
	Ui.fade_in(self)
	await get_tree().create_timer(0.1).timeout
	can_accept = true

func input(): #Quando ele escolhe <- pires eu juro q eu vo te matar por tu ter deixado a logica de fechar
	# o inventario aq dentro
	# (ele buga com o controle)
	pass

func close_menu():
	InteractionSystem.action = null
	#get_viewport().gui_get_focus_owner().button_down.emit()
	get_viewport().gui_release_focus()
	Ui.fade_out(self)
	print("Ended")
	
	if ni is Inventory: Ui.inventory.call_deferred("input")

func _on_yes_button_down() -> void: #Confirmado
	if not can_accept:return
	if cb!= null:
		print("A")
		cb.call_deferred("answer" ,true)
		GameHandler.Player.remove_core(1)
		close_menu()

func _on_no_button_down() -> void: #Recusado
	if not can_accept:return
	if cb!= null:
		cb.call_deferred("answer" ,false)
		GameHandler.Player.remove_core(1)
		close_menu()
