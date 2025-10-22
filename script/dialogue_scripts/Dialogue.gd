extends Interactable
class_name Dialogue

@export var messages : Array[Message]
@export var next_dialogue : Dialogue
@export var oneshot : bool
var dialogue_just_ended = false


func activate():
	Ui.dialogue.start(self)

func onDialogueEnd():
	if next_dialogue == null: return
	messages = next_dialogue.messages
	oneshot = next_dialogue.oneshot
	next_dialogue = next_dialogue.next_dialogue

func response(m, o, n): #Atualiza depois da questão ser respondida
	messages = m
	oneshot = o
	next_dialogue = n

func question(q):
	messages = q.response.messages
	next_dialogue = q.response.next_dialogue
