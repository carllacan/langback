extends CenterContainer

onready var translation_language_selector = find_node("LineEdit")
onready var full_screen_toggle = find_node("CheckButton")

func _on_visiblity_change():
	if visible: # if show
		update_settings()
		
func update_settings():
	# Update the state of the widgets to accord with the loaded settings
	translation_language_selector.text = Settings.translation_language
	full_screen_toggle.pressed = Settings.fullscreen
	
	
func _on_CloseButton_pressed():
	print(123)
	hide()

func _on_Reset_pressed(): # untested
	Settings.reset()
	update_settings()

func _on_LineEdit_text_changed(new_text):
	Settings.translation_language = new_text
