extends ScrollContainer

var sentences
var sentence_box = load("res://scenes/SentenceBox.tscn")

func add_sentences(sentences):
	for sentence_pair in sentences:
		var new_sentence = sentence_box.instance()
		find_node("VBoxContainer").add_child(new_sentence)
		new_sentence.set_sentence(sentence_pair[0], sentence_pair[1])