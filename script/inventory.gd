extends Control
class_name inventory

var open : bool = false

func input():
	open = true if open == false else false
	await Ui.fade_in(self) if open else await Ui.fade_out(self)
