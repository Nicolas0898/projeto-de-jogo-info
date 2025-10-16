extends Control
@onready var health_bar: ProgressBar = $Panel/HealthBar
@onready var label: Label = $Panel/Label


func update_health(newval):
	health_bar.value = newval
	label.text = str(newval)+"/100"
