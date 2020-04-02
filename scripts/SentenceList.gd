extends ScrollContainer

signal sentence_done(original)
signal sentence_reset(original)

var sentences
var text_info
var SentenceBox = load("res://scenes/SentenceBox.tscn")

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	
func _on_visibility_change():
	if visible:
		return
	for sentence_box in find_node("ListContainer").get_children():
		print(sentence_box.translation)
		find_node("ListContainer").remove_child(sentence_box)
		sentence_box.queue_free()
	
func add_text_info(_text_info):
	text_info = _text_info
	find_node("TextTitle").text = text_info["Title"]
	add_sentences(text_info["Sentences"])

func add_sentences(_sentences):
	var last_sb = null
	for sentence in _sentences:
		var new_sb = SentenceBox.instance()
		find_node("ListContainer").add_child(new_sb)
		new_sb.set_sentence(sentence["Original"], sentence["Translation"], sentence["Done"])
		new_sb.connect("done", self, "_on_sentence_done", [sentence["Original"]])
		new_sb.connect("reset", self, "_on_sentence_rest", [sentence["Original"]])
		if last_sb != null:
			last_sb.set_focus_next(new_sb)
		last_sb = new_sb
		
func _on_sentence_done(original):
	emit_signal("sentence_done", original)
	
func _on_sentence_rest(original):
	emit_signal("sentence_reset", original)
	
