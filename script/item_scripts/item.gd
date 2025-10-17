extends Resource
class_name Item

enum types{
	utilitario,
	descritivo,
}

@export var name : String
@export var desc : String
@export var amount : int = 1
@export var cooldown : float = 0
@export var display : types
@export var sprite : Texture
@export var confirm : bool
@export var hability_path:String
var node_used : Node #Quem usa o item
var t : float: 
	set(new_value):
		if new_value == 0:  Ui.inventory.c.erase(self)
		t = new_value

#USE => Ativa o item (confirmação e cooldown), é o que executa antes do UTILIZE
#UTILIZE => O que o item faz

func use(who_used : Node, next_interface):
	node_used = who_used
	if self in Ui.inventory.c: return #Está em cooldown
	
	if confirm and InteractionSystem.action != null: #Se pedir confirmação
		Ui.inventory.input()
		Ui.confirm.called("Você deseja usar " + name, self, next_interface)
	else:
		utilize() 
		cooldown_handler()

func cooldown_handler():
	if cooldown > 0: #Se tiver cooldown
		t = cooldown
		 
		Ui.inventory.c.append(self) #Comunica o inventário
		Ui.new_tween(self, "t", 0, cooldown)

func answer(ans : int):
	if ans: #Só continua o código normalmente
		utilize()
		cooldown_handler()
	else: return #Não executa o resto

func utilize():pass
