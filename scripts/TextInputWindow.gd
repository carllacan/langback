extends VBoxContainer

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	
func _on_visibility_change():
	if not visible:
		return
	reset()
	
func reset():
	find_node("TitleEdit").text = ""
	find_node("TextEdit").text = ""
