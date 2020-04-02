extends CanvasLayer

onready var background = find_node("PopupsBG")

func _ready():
	for child in get_children():
		child.connect("visibility_changed", self, "_on_visiblity_change")
		
func _on_visiblity_change():
	var popups_visible = false
	for child in get_children():
		if child == background:
			continue
		if child.visible:
			popups_visible = true
	background.visible = popups_visible
