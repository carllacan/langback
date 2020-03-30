extends ScrollContainer

var sentences
var text_info
var sentence_box = load("res://scenes/SentenceBox.tscn")

func add_text_info(_text_info):
	text_info = _text_info
	add_sentences(text_info["Sentences"])


func add_sentences(_sentences):
	for sentence_pair in _sentences:
		var new_sentence = sentence_box.instance()
		find_node("VBoxContainer").add_child(new_sentence)
		new_sentence.set_sentence(sentence_pair[0], sentence_pair[1])
