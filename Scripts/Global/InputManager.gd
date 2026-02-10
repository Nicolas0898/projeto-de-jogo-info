extends Node

class InputGroup:
	static var Groups:Dictionary[String,InputGroup] = {}
	
	var name
	var nodes:Array[Node]
	var active = false
	
	func _init(_name) -> void:
		self.name = _name
	
	func makeGroupActive():
		for i in Groups:
			var group = Groups[i]
			group.deactivateGroup()
		
		active = true
		for node in nodes:
			node.set_process_input(true)
		print_rich("[color=#aaffaa]→ InputGroup "+name+" ("+str(nodes.size())+" nodes) SENDO ATIVADO[/color]")

	func deactivateGroup():
		print_rich("[color=#ffaaaa]← GRUPO "+name+" SENDO DESATIVADO[/color]")
		active = false
		for node in nodes:
			node.set_process_input(false)
	
	func addNode(node:Node):
		print_rich("[color=#aaffff]Adding node "+str(node)+" To group "+name+ " Active : "+ str(active)+"[/color]")
		nodes.push_back(node)
		if not active:
			node.set_process_input(false)
	
	static func getGroup(group_name) -> InputGroup:
		if not Groups.has(group_name):
			Groups[group_name] = InputGroup.new(group_name)
			return Groups[group_name]
		else:
			return Groups.get(group_name)

var currentActiveGroup:InputGroup

func setActiveGroup(group_name):
	currentActiveGroup = InputGroup.getGroup(group_name)
	currentActiveGroup.makeGroupActive()

func addNodeToGroup(node,group):
	InputGroup.getGroup(group).addNode(node)
