extends Control
@onready var grid_container: GridContainer = $Panel/VBoxContainer/GridContainer

var a = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("admin") and not a:
		#a = true
		Ui.get_node("RadialMenu").add_option("Admin","Admin","res://Images/assets/terminal.png"	)

func _ready() -> void:
	for button:Button in grid_container.get_children():
		button.pressed.connect(func():
			NavigationManager.go_to_level("",button.text)
			)


func _on_button_pressed() -> void:
	GameHandler.Player.add_hability("res://Scenes/Player/InstanciableHabilities/leaf_cage.tscn")

func _on_button_2_pressed() -> void:
	GameHandler.Player.add_hability("res://Scenes/Player/InstanciableHabilities/grappling_hook.tscn")

func _on_button_3_pressed() -> void:
	GameHandler.player_habilities.clear()
	get_tree().reload_current_scene()


func _resetgolem() -> void:
	GameHandler.golem_dead = false

func resetcoins() -> void:
	GameHandler.total_coins = 0
	GameHandler.roomswocoins.clear()


func scenereset() -> void:
	get_tree().reload_current_scene()
