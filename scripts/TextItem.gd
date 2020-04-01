extends HBoxContainer

signal chosen
var text_info


func load_text_info(_text_info):
	text_info = _text_info
	find_node("OriginalLanguage").text = text_info["Language"]
	find_node("TextTitle").text = text_info["Title"]
	var sentence_num = len(text_info["Sentences"])
	find_node("SentenceNumber").text = "%s sentences" % sentence_num


func _on_ContinueButton_pressed():
	emit_signal("chosen", text_info)


func _on_ResetButton_pressed():
	for sentence_num in range(len(text_info["Sentences"])):
		text_info["Sentences"][sentence_num]["Done"] = false
	emit_signal("chosen", text_info)
