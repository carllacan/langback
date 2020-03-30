extends ScrollContainer

signal sentence_done(original)

var sentences
var text_info
var SentenceBox = load("res://scenes/SentenceBox.tscn")

func add_text_info(_text_info):
	text_info = _text_info
	find_node("TextTitle").text = text_info["Title"]
	add_sentences(text_info["Sentences"])


func add_sentences(_sentences):
	for sentence in _sentences:
		var new_sb = SentenceBox.instance()
		find_node("VBoxContainer").add_child(new_sb)
		new_sb.set_sentence(sentence["Original"], sentence["Translation"])
		new_sb.connect("done", self, "_on_sentence_done", [sentence["Original"]])
		
func _on_sentence_done(original):

	emit_signal("sentence_done", original)
