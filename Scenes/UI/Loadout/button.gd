extends Button
@onready var label_right: Label = $LabelRight
@onready var label_left: Label = $LabelLeft

func update(item:LoadoutItem):
	var texture_rect: TextureRect = $TextureRect
	if item and item.name == "REMOVEIMAGE": item = null
	if item:
		texture_rect.texture = item.sprite
	else:
		texture_rect.texture = null
