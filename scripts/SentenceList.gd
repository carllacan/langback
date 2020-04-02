extends ScrollContainer

#signal sentence_done(original)
#signal sentence_reset(original)

onready var listcontainer = find_node("ListContainer")

var sentences
var text_info
var SentenceBox = load("res://scenes/SentenceBox.tscn")

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	
func _on_visibility_change():
	if visible:
		return
	for sentence_box in listcontainer.get_children():
		print(sentence_box.translation)
		listcontainer.remove_child(sentence_box)
		sentence_box.queue_free()
	
func add_text_info(text):
	find_node("TextTitle").text = text.title
	add_sentences(text.sentences)

func add_sentences(_sentences):
	var last_sb = null
	for sentence in _sentences:
		var new_sb = SentenceBox.instance()
		listcontainer.add_child(new_sb)
		new_sb.set_sentence(sentence)
		new_sb.connect("grabbed_focus", self, "_when_a_sentence_grabs_focus")
		if last_sb != null:
			last_sb.set_focus_next(new_sb)
		last_sb = new_sb
		
	# Set focus on the first undone sentence_box
	for sb in listcontainer.get_children():
		if not sb.sentence.done:
			sb.grab_focus()
			break
		
func _when_a_sentence_grabs_focus():
	for sb in listcontainer.get_children():
		sb._when_other_sentence_grabs_focus()
			
#func _on_sentence_done(original):
#	emit_signal("sentence_done", original)
#
#func _on_sentence_rest(original):
#	emit_signal("sentence_reset", original)
#
#func add_text_info(_text_info):
#	text_info = _text_info
#	find_node("TextTitle").text = text_info["Title"]
#	add_sentences(text_info["Sentences"])

#func add_sentences(_sentences):
#	var last_sb = null
#	for sentence in _sentences:
#		var new_sb = SentenceBox.instance()
#		find_node("ListContainer").add_child(new_sb)
#		new_sb.set_sentence(sentence["Original"], sentence["Translation"], sentence["Done"])
#		new_sb.connect("done", self, "_on_sentence_done", [sentence["Original"]])
#		new_sb.connect("reset", self, "_on_sentence_rest", [sentence["Original"]])
#		if last_sb != null:
#			last_sb.set_focus_next(new_sb)
#		last_sb = new_sb
#
#func _on_sentence_done(original):
#	emit_signal("sentence_done", original)
#
#func _on_sentence_rest(original):
#	emit_signal("sentence_reset", original)
	
