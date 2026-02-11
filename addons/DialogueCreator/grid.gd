@tool
extends Control
@onready var load_from_selection: Button = $HFlowContainer/FoldableContainer/VBoxContainer/load_from_selection
@onready var load_from_file: Button = $HFlowContainer/FoldableContainer/VBoxContainer/HBoxContainer/load_from_file
@onready var debug: Label = $debug

@onready var graph_edit: GraphEdit = $GraphEdit
enum Type {Message,Dialogue}
@onready var addon_resource_picker: AddonResourcePicker = $HFlowContainer/FoldableContainer/VBoxContainer/HBoxContainer/AddonResourcePicker
@onready var foldable_container: FoldableContainer = $HFlowContainer/FoldableContainer
@onready var menu_button: MenuButton = $HFlowContainer/MenuButton


var history : EditorUndoRedoManager
var RootResource:Dialogue
var Selection
var ActivePath
var RootNode:DialogueNode
var plugin:EditorPlugin

const vertical_spacing = 750

func loadFromResource(dialogue:Dialogue):
	DialogueNode.nodes.clear()
	print(dialogue)
	for i in graph_edit.get_children(false):
		if i is GraphNode:
			i.queue_free()
	
	RootResource = dialogue.duplicate(true)
	RootNode = DialogueNode.new(graph_edit,history)
	RootNode.currentResource = RootResource
	
	iterateMessages(RootNode.node.name,0,RootResource.messages)

func iterateMessages(last_node,connect_from,Messages:Array[Message]):
	for message in Messages:
		var lastnode = graph_edit.get_node(NodePath(last_node))
		var msgn = MessageNode.new(graph_edit,history,lastnode.position_offset + Vector2(lastnode.size.x,0) + Vector2(120,0) )
		msgn.CurrentResource = message
		
		msgn.Text.text = message.text
		msgn.Name.text = message.name
		msgn.Border.edited_resource = message.border
		msgn.Action.edited_resource = message.action
		msgn.Sprite.edited_resource = message.sprite
		lastnode.get_meta("Class").Next = msgn
		msgn.Last = lastnode.get_meta("Class")
		
		graph_edit.connect_node(last_node,connect_from,msgn.node.name,0)
		last_node = msgn.node.name
		connect_from = 0
		
		if message is Question:
			msgn.QuestionCheck.button_pressed = true
			msgn.LockCheck.button_pressed = true
			msgn.CurrentResource.lock_dialogue = message.lock_dialogue
			msgn.toggleOption(true)
			for quest:Choice in message.questions:
				var opt = msgn.addOption()
				opt.res = quest
				if quest!=null: 
					opt.response.text = quest.question
				if quest.response:
					var dial_node = DialogueNode.new(graph_edit,history,msgn.node.position_offset + Vector2(520,vertical_spacing*connect_from))
					dial_node.currentResource = quest.response
					graph_edit.connect_node(last_node,connect_from,dial_node.node.name,0)
					dial_node.fromOption = connect_from
					dial_node.Last = msgn
					iterateMessages(dial_node.node.name,0,quest.response.messages)
				
				connect_from += 1
			msgn.compileOptions()
		

class DialogueNode:
	static var nodes:Array[DialogueNode] = []
	var node = GraphNode.new()
	var Next:MessageNode
	var Last:MessageNode
	var currentResource = Dialogue.new()
	var fromOption:int
	
	func _init(graph_edit:GraphEdit,history:EditorUndoRedoManager,pos:Vector2=Vector2.ZERO):
		nodes.push_back(self)
		node.title = "Dialogue"
		node.position_offset = pos
		
		var nextmessage = Label.new()
		nextmessage.text = "Next message"
		node.set_slot(0,false,Type.Message,Color.WHITE,true,0,Color.WHITE)
		
		var nextDialogue = Label.new()
		nextDialogue.text = "Next Dialogue"
		node.set_slot(1,false,0,Color.WHITE,true,Type.Dialogue,Color.PURPLE)
		
		var oneshot = CheckBox.new()
		oneshot.text = "Oneshot"
		
		var LastMessage = Label.new()
		LastMessage.text = "Last Dialogue"
		node.set_slot(3,true,Type.Dialogue,Color.PURPLE,false,Type.Dialogue,Color.PURPLE)
		
		node.add_child(nextmessage)
		node.add_child(nextDialogue)
		node.add_child(oneshot)
		node.add_child(LastMessage)
		node.set_meta("Class",self)

		
		history.create_action("Created Node")
		history.add_do_method(graph_edit,"add_child",node)
		history.add_do_reference(node)
		
		history.add_undo_method(graph_edit,"remove_child",node)
		history.commit_action()
	
	func compileOrder(current_array:Array[Message]=[],node:MessageNode=Next) -> Array[Message]:
		if node!= null:
			current_array.push_back(node.CurrentResource)
		else:
			return current_array
		#print("→ "+str("questions" in node.CurrentResource))
		
		
		if node.Next == null:
			return current_array
		
		return compileOrder(current_array,node.Next)
	
	func compile():
		pass
	
class MessageNode:
	var node = GraphNode.new()
	var questions = []
	var question_nodes = []
	
	var nextpos:int
	var lastmessage:Label
	var nextmessage:Label
	var Text:TextEdit
	var Name:LineEdit
	var QuestionCheck:CheckBox
	var LockCheck:CheckBox
	var AddBtn:Button
	var Sprite:AddonResourcePicker
	var Border:AddonResourcePicker
	var Action:AddonResourcePicker
	
	class Option:
		var QuestionName:Label
		var response:LineEdit
		var cnext:Label
		var res:Choice
		var index:int
	
	var CurrentResource
	var lastIndex = 0
	var Next:MessageNode
	var Last
	var options = []
	var history:EditorUndoRedoManager
		
	func _init(graph_edit:GraphEdit,history:EditorUndoRedoManager,pos:Vector2=Vector2.ZERO):
		self.history = history
		CurrentResource = Message.new()
		node.title = "Message"
		node.resizable = true
		node.size.x = 300
		
		node.position_offset = pos
		
		lastmessage = Label.new()
		lastmessage.text = "Last message"
		node.set_slot(0,true,Type.Message,Color.WHITE,false,0,Color.WHITE)
		
		nextmessage = Label.new()
		nextmessage.text = "Next message"
		nextmessage.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		
		Text = TextEdit.new()
		Text.placeholder_text = "Message Text"
		Text.custom_minimum_size = Vector2(0,200)
		addTextEdit(Text,"text")
		
		Name = LineEdit.new()
		Name.placeholder_text = "Name"
		Name.text_changed.connect(func(): CurrentResource.name = Name.text )
		addTextEdit(Name,"name")
		
		QuestionCheck = CheckBox.new()
		QuestionCheck.text = "Set as Question"
		
		LockCheck = CheckBox.new()
		LockCheck.text = "Lock Dialogue"
		LockCheck.visible = false
		
		LockCheck.toggled.connect(func(v): CurrentResource.lock_dialogue = v )
		
		AddBtn = Button.new()
		AddBtn.text = "Add option"
		AddBtn.visible = false
		
		AddBtn.pressed.connect(func():addOption())
		QuestionCheck.toggled.connect(func(v):
			toggleOption(v)
			if not v: lastIndex = 0
		)
		
		var SpriteLabel = Label.new()
		SpriteLabel.text = "Sprite:"
		Sprite = AddonResourcePicker.new()
		Sprite.base_type = "Texture2D"
		addSelectorEdit(Sprite,"sprite")
		
		var BorderLabel = Label.new()
		BorderLabel.text = "Border:"
		Border = AddonResourcePicker.new()
		Border.base_type = "Texture2D"
		addSelectorEdit(Border,"border")
		
		var ActionLabel = Label.new()
		ActionLabel.text = "Action:"
		Action = AddonResourcePicker.new()
		Action.base_type = "Script"
		addSelectorEdit(Action,"action")
		
		
		node.add_child(lastmessage)
		node.add_child(Text)
		node.add_child(Name)
		node.add_child(SpriteLabel)
		node.add_child(Sprite)
		node.add_child(BorderLabel)
		node.add_child(Border)
		node.add_child(ActionLabel)
		node.add_child(Action)
		node.add_child(nextmessage)

		
		nextpos = node.get_children().size()-1
		node.set_slot(nextpos,false,Type.Message,Color.WHITE,true,Type.Message,Color.WHITE)
		
		
		node.add_child(QuestionCheck)
		node.add_child(LockCheck)
		node.add_child(AddBtn)
		node.set_meta("Class",self)
		
		history.create_action("Created Node")
		history.add_do_method(graph_edit,"add_child",node)
		history.add_do_reference(node)
		
		history.add_undo_method(graph_edit,"remove_child",node)
		history.commit_action()

	
	func toggleOption(value):
		AddBtn.visible = value
		nextmessage.visible = not value
		node.set_slot(nextpos,false,Type.Message,Color.WHITE,not value,Type.Message,Color.WHITE)
		for i in question_nodes:
			i.queue_free()
		question_nodes.clear()
		
		LockCheck.visible = value
		if value:
			var question = Question.new()
			for property in CurrentResource.get_property_list():
				if property.name == "script" : continue
				question.set(property.name,CurrentResource.get(property.name))

			CurrentResource = null
			CurrentResource = question
		else:
			options.clear()
			var message = Message.new()
			for property in CurrentResource.get_property_list():
				if property.name == "script" : continue
				if property.name in message:
					message.set(property.name,CurrentResource.get(property.name))
			CurrentResource = message
	
	func addOption():
		var option = Option.new()
		option.index = lastIndex
		lastIndex+=1
		var QuestionName = Label.new()
		QuestionName.text = "→ Option"
		var response = LineEdit.new()
		response.placeholder_text = "Response"
		response.text_changed.connect(func(text): 
			option.res.question = text
			compileOptions()
			)
		
		var cnext = Label.new()
		cnext.text = "Next Dialogue"
		cnext.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		node.add_child(QuestionName)
		node.add_child(response)
		node.add_child(cnext)
		
		question_nodes.push_back(QuestionName)
		question_nodes.push_back(response)
		question_nodes.push_back(cnext)
		
		option.QuestionName = QuestionName
		option.response = response
		option.cnext = cnext
		
		node.set_slot.call_deferred((node.get_children().size())-2,false,Type.Message,Color.WHITE,true,Type.Dialogue,Color.PURPLE)
		option.res = Choice.new()
		option.res.question = ""
		
		options.push_back(option)
		compileOptions()
		return option
	
	func compileOptions():
		var final:Array[Choice] = []
		for i in options:
			final.push_back(i.res)
		CurrentResource.questions = final
		print(final)
	
	func addTextEdit(node:Control,property):
		node.focus_entered.connect(func():
			node.set_meta("ogtext",node.text)
			)

		node.focus_exited.connect(func():
			history.create_action("Text edited "+node.name,UndoRedo.MERGE_ALL)
			var ogtext = node.get_meta("ogtext")
			history.add_undo_property(node,"text",ogtext)
			history.add_undo_property(CurrentResource,property,ogtext)
			history.add_do_property(CurrentResource,property,node.text)
			history.add_do_property(node,"text",node.text)
			#CurrentResource.set(property,node.text)
			history.commit_action() 
			)
	
	func addSelectorEdit(node:AddonResourcePicker,property):
		node.resource_changed.connect(func(new): CurrentResource.set(property,new))
		pass

# GRAPH CONTROL
func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	debug.text = str(from_node) + " "+ str(from_port) + " " + str(to_node) + " " + str(to_port)
	#graph_edit.connect_node(from_node,from_port,to_node,to_port)
	history.create_action("Connected Node",UndoRedo.MERGE_ALL)
	history.add_do_method(graph_edit,"connect_node",from_node,from_port,to_node,to_port)
	history.add_undo_method(graph_edit,"disconnect_node",from_node,from_port,to_node,to_port)
	history.commit_action()
	var originNode = graph_edit.get_node(NodePath(from_node))
	var nextNode = graph_edit.get_node(NodePath(to_node))
	if originNode.has_meta("Class"):
		originNode.get_meta("Class").Next = nextNode.get_meta("Class")


func _on_graph_edit_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	#FAZER VERIFICAÇÂO DO TIPO!
	var origin_node:GraphNode = graph_edit.get_node(NodePath(from_node)) 
	
	if origin_node.get_output_port_type(from_port) == Type.Message:
		var node = MessageNode.new(graph_edit,history,graph_edit.scroll_offset+release_position)
		#graph_edit.connect_node(from_node,from_port,node.node.name,0)
		
		history.create_action("Created Node",UndoRedo.MERGE_ALL)
		history.add_do_method(graph_edit,"connect_node",from_node,from_port,node.node.name,0)
		history.add_undo_method(graph_edit,"disconnect_node",from_node,from_port,node.node.name,0)
		history.commit_action()
		
		origin_node.get_meta("Class").Next = node
		
		node.Last = origin_node.get_meta("Class")

	else: # QUANDO TYPE = DIALOGUE
		var node = DialogueNode.new(graph_edit,history,graph_edit.scroll_offset+release_position)
		#graph_edit.connect_node(from_node,from_port,node.node.name,0)
		
		history.create_action("Created Node",UndoRedo.MERGE_ALL)
		history.add_do_method(graph_edit,"connect_node",from_node,from_port,node.node.name,0)
		history.add_undo_method(graph_edit,"disconnect_node",from_node,from_port,node.node.name,0)
		history.commit_action()
		
		debug.text = "Type : Dialogue, Port : "+str(from_port)
		var origin_class = origin_node.get_meta("Class")
		if origin_class is MessageNode:
			origin_class.options[from_port].res.response = node.currentResource
			node.fromOption = from_port
			node.Last = origin_class
		print(origin_class.options[from_port].res.response)

func _on_graph_edit_delete_nodes_request(nodes: Array[StringName]) -> void:
	history.create_action("Deleted node(s)")
	
	for i in nodes:
		var node:GraphNode = graph_edit.get_node(NodePath(i))
		var nodeclass = node.get_meta("Class")
		history.add_do_method(graph_edit,"remove_child",node)
		history.add_undo_reference(node)
		print(nodeclass.get_property_list())
		if "fromOption" in nodeclass:
			print("I SHOULD BE DELETING A DIALOG HERE!!! 1.0 ",nodeclass.Last)
			if nodeclass.Last != null:
				history.add_undo_property(nodeclass.Last,"options",nodeclass.Last.options.duplicate())
				nodeclass.Last.options[nodeclass.fromOption].res = null
				nodeclass.Last.compileOptions()
				print("I SHOULD BE DELETING A DIALOG HERE!!!")
				history.add_do_property(nodeclass.Last,"options",nodeclass.Last.options.duplicate())
		if nodeclass.get("Last"):
			history.add_do_property(nodeclass.Last,"Next",null)
			history.add_undo_property(nodeclass.Last,"Next",nodeclass.Last)
			#nodeclass.Last.Next = null
		history.add_undo_method(graph_edit,"add_child",node)
	
	history.commit_action()

func saveDialogue() -> void:
	print("SAVING!!!!")
	foldable_container.folded = true
	
	for i in DialogueNode.nodes:
		var order = i.compileOrder()
		print("ORDERRR → ",order)
		i.currentResource.messages = order
		print(i.currentResource.messages) 
		
	if Selection:
		Selection.action = RootResource
		loadFromSelection()
	if ActivePath:
		var error = ResourceSaver.save(RootResource,ActivePath,ResourceSaver.FLAG_BUNDLE_RESOURCES)
		print(error)
		loadFromFile(ActivePath)
		

func _ready() -> void:
	menu_button.get_popup().id_pressed.connect(onPress)
	var saveshortcut = Shortcut.new()
	var event = InputEventKey.new()
	event.keycode = KEY_S
	event.ctrl_pressed = true
	event.alt_pressed = true
	
	saveshortcut.events = [event]
	
	menu_button.get_popup().set_item_shortcut(2,saveshortcut,false)

func loadFromSelection() -> void:
	foldable_container.folded = true
	ActivePath = null
	var selection = EditorInterface.get_selection().get_selected_nodes()
	if selection.size() <= 0: return
	var selected = selection[0]
	if not (selected is InteractionArea) : return
	selected = selected as InteractionArea
	Selection = selected
	debug.text = selected.name + " Dialogue"
	loadFromResource(selected.action)

func newDialogue():
	Selection = null
	loadFromResource(Dialogue.new())

func loadFromFile(file=null) -> void:
	Selection = null
	var path = file
	
	if not file:
		var dial = EditorFileDialog.new()
		dial.access = EditorFileDialog.ACCESS_RESOURCES
		dial.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
		dial.display_mode = EditorFileDialog.DISPLAY_LIST
		plugin.add_child(dial)
		dial.popup_centered(Vector2i(1000,600))
		path = await dial.file_selected
	
	if path:
		debug.text = path
		#foldable_container.folded = true
		ActivePath = path
		loadFromResource(load(path))

func onPress(id:int):
	match(id):
		0: newDialogue()
		1: saveDialogue()
		2: pass
		3: loadFromSelection()
		4: loadFromFile()
