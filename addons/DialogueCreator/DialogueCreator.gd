@tool
extends EditorPlugin

var grid:Control

func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass

func _get_plugin_name() -> String:
	return "Dialogue Editor"

func _enter_tree() -> void:
	grid = load("res://addons/DialogueCreator/Grid.tscn").instantiate()
	grid.history = get_undo_redo()
	add_control_to_bottom_panel(grid,"Dialogue Editor")


func _exit_tree() -> void:
	remove_control_from_bottom_panel(grid)
	if grid:
		grid.queue_free()
