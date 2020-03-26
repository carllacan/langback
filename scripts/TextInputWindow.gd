extends VBoxContainer



func _on_ResetButton_pressed():
	find_node("TitleEdit").text = ""
	find_node("TextEdit").text = ""
