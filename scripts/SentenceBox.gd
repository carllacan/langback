extends PanelContainer

signal done

onready var original_label = find_node("OriginalSentence")
onready var translation_box = find_node("UserTranslation")

var original = ""
var translation = ""

var done = false

func set_sentence(_original, _translation, done=false):
	original = _original
	translation = _translation
	original_label.text = translation
	translation_box.rect_min_size.y = original_label.rect_size.y+5
	
	if done:
		translation_box.text = original
		on_completion()
	
func _on_text_changed():
	var user_translation = translation_box.text
	if user_translation == "":
		find_node("Indicator").text = ""
	elif user_translation == original:
		on_completion()
	else:
		if user_translation == original.substr(0,len(user_translation)):
			find_node("Indicator").text = "OK"
		else:
			find_node("Indicator").text = "NOK"
			
func on_completion():
		find_node("Indicator").text = "Done!"
		translation_box.readonly = true
		done = true
		emit_signal("done")
