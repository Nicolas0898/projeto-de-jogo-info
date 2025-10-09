extends Interactable
class_name Dialogue

@export var messages : Array[Message]
@export var next_dialogue : Dialogue
var dialogue_just_ended = false


func activate():
	Ui.dialogue.start(self)

func onDialogueEnd():
	if next_dialogue == null: return
	messages = next_dialogue.messages
	oneshot = next_dialogue.oneshot
	next_dialogue = next_dialogue.next_dialogue

func question(q : Resource):
	messages = q.messages
	next_dialogue = q.next_dialogue
