extends Control
class_name Bestiary

@onready var container: HBoxContainer = $Panel/book/Control/HBoxContainer
@onready var page_sprite: AnimatedSprite2D = $Panel/book/page

@export var pages : Array[double_page] #TODAS as páginas (até as não encontradas)
var visible_pages : Array[double_page] #Apenas as páginas encontradas
var none = load("res://Images/entities/resource/bestiario/Não encontrado.tres")

var is_open : bool = false
var pos = 0

func load_pages():
	for child in container.get_children():
		child.queue_free()
	
	for i in range(len(visible_pages[pos].entries)):
		var e = visible_pages[pos].entries[i]
		var scene = e.scene.instantiate()
		
		#Essa parte daria pra fazer um script separado cada, mas vou evitar pra não ter muitos arquivos
		if scene.name == "bestiary_entry":
			scene.get_node("sprite").texture = e.image
			scene.get_node("sprite").get_node("border").texture = e.border
			scene.get_node("name").text = e.nome
			if e.subtitle == "c": #Se for C então contar kills
				scene.get_node("subtitle_node").get_node("subtitle").text = "Derrotado " + str(e.times_eliminated) + " vez(es)"
			else:
				scene.get_node("subtitle_node").get_node("subtitle").text = e.subtitle
			scene.get_node("desc_node").get_node("desc").text = e.desc
			var texture = null
			if e.indicator == 0: scene.get_node("HBoxContainer").get_node("icon_node").queue_free()
			else:
				if e.indicator == 1: texture = load("res://Images/UI/skull_01.png")
				if e.indicator == 2: texture = load("res://Images/UI/skull_02.png")
				scene.get_node("HBoxContainer").get_node("icon_node").get_node("icon").texture = texture
		
		if scene.name == "bestiary_label":
			scene.get_node("desc").text = e.text
		
		container.add_child(scene)

func pass_page(direction : String):
	# "right" / "left"
	
	var arm = pos
	
	if direction == "right":
		if pos < len(visible_pages) - 1:
			pos = pos + 1
			page_sprite.play("page_right")
	if direction == "left":
		if pos > 0:
			pos = pos - 1 
			page_sprite.play("page_left")
	
	#print(pos)
	if pos != arm:
		load_pages()

func _ready() -> void:
	refresh()
	#print(visible_pages)

func refresh(): #Toda a parte lógica da organização
	visible_pages = []
	print("-----------------------")
	
	#print(pages[0])
	
	for i in range(len(pages)):
		var showing = double_page.new()
		var unique_pages = 0 #Pra verificar se deve ou não dar append
		for entry in pages[i].entries:
			if entry != null and entry.is_visible:
				unique_pages+= 1
				showing.entries.append(entry)
			else:
				showing.entries.append(none)
		
		if unique_pages > 0:
			visible_pages.append(showing)
	
	if visible_pages == []: #Se ele achou nada até agora (não sei como)
		var nenhum = load("res://Images/entities/resource/bestiario/Nenhum.tres")
		visible_pages.append(nenhum)
	
	
	#for dp in range(len(visible_pages)):
		#for p in range(len(visible_pages[dp].entries)):
			#if visible_pages[dp].entries[p] is bestiary_entry:
				#print(visible_pages[dp].entries[p].nome)
	#print(visible_pages[0].entries[1].nome)
	
	
	
	print("-----------------------")
	pass


func on_active():
	load_pages()
