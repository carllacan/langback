extends Node

class_name Sentence

signal done
signal reset

var original = ""
var translation = ""
var done = false

func _init(sentence_info):
	original = sentence_info["Original"]
	translation = sentence_info["Translation"]
	if "Done" in sentence_info:
		done = sentence_info["Done"]
	else:
		done = false
	
func mark_done():
	done = true
	emit_signal("done")
	
func reset():
	done = false
	emit_signal("reset")
	
func make_dict():
	var sentence_info = {}
	sentence_info["Original"] = original
	sentence_info["Translation"] = translation
	sentence_info["Done"] = done
	return sentence_info
