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

func question(q):
	if q.response == null and q.action == null: Ui.dialogue.dialogueEnd()
	elif q.action != null: q.action.act()
	else:
		q.response.messages = q.messages
		q.reponse.next_dialogue = q.next_dialogue
