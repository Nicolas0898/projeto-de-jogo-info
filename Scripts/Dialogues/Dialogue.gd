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

func response(m, o, n):
	messages = m
	oneshot = o
	next_dialogue = n

func question(q):
	#print(q.response)
	#print(q.response.messages[0].text)
	#if q.response == null and q.action == null: Ui.dialogue.dialogueEnd()
	#elif q.response == null: Ui.dialogue.dialogueEnd()
	#if q.action != null: q.action.act()
	#if q.response != null:
	messages = q.response.messages
	next_dialogue = q.response.next_dialogue
