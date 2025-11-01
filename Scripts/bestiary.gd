extends Control
class_name Bestiary

@onready var container: HBoxContainer = $Panel/book/Control/HBoxContainer
@onready var page_sprite: AnimatedSprite2D = $Panel/book/page

@export var pages : Array[double_page]
var is_open : bool = false
var pos = 0

func load_pages():
	await Ui.opacity(container, 0, 0.1)
	for child in container.get_children():
		child.queue_free()
	
	for i in range(len(pages[pos].entries)):
		var e = pages[pos].entries[i]
		var scene = e.scene.instantiate()
		
		#Essa parte daria pra fazer um script separado cada, mas vou evitar pra não ter muitos arquivos
		if scene.name == "bestiary_entry":
			scene.get_node("sprite").texture = e.image
			scene.get_node("sprite").get_node("border").texture = e.border
			scene.get_node("name").text = e.nome
			scene.get_node("subtitle_node").get_node("subtitle").text = "Derrotado " + str(e.times_eliminated) + " vez(es)"
			scene.get_node("desc_node").get_node("desc").text = e.desc
			#scene.get_node("indicator")
		
		if scene.name == "bestiary_label":
			scene.get_node("desc").text = e.text
		
		container.add_child(scene)
	await Ui.opacity(container, 1, 0.3)


func pass_page(direction : String):
	# "right" / "left"
	
	if direction == "right":
		if pos < len(pages) - 1:
			pos = pos + 1
			page_sprite.play("page_right")
	if direction == "left":
		if pos > 0:
			pos = pos - 1 
			page_sprite.play("page_left")
	
	print(pos)
	load_pages()

func open():
	if InteractionSystem.action != null and not InteractionSystem.action is Bestiary: return
	
	if GameHandler.Player.state_machine.currentState.name != "Core":
		GameHandler.Player.set_core(1)
	else:
		GameHandler.Player.remove_core(1)
	
	is_open = not is_open
	InteractionSystem.action = self if InteractionSystem.action == null else null
	
	if is_open:
		load_pages()
	else:
		pass
	
	await Ui.fade_in(self) if open else await Ui.fade_out(self)
