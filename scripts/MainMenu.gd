extends MarginContainer

signal done(next_window, output)

func enter():
	show()
	
func exit():
	hide()

func _on_LoadButton_pressed():
	emit_signal("done", "TextLoadWindow", null)

func _on_CreateTextButton_pressed():
	var new_text = Text.new()
	emit_signal("done", "LanguageSelectionWindow", new_text)

func _on_CreateTableButton_pressed():
	var new_table = Table.new()
	emit_signal("done", "LanguageSelectionWindow", new_table)
