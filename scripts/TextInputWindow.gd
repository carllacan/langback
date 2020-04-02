extends VBoxContainer

onready var title_edit = find_node("TitleEdit")
onready var text_edit = find_node("TextEdit")
onready var word_count = find_node("WordCounter")

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	title_edit.connect("text_changed", self, "_on_text_change")
	text_edit.connect("text_changed", self, "_on_text_change")
	
func reset():
	title_edit.text = ""
	text_edit.text = ""
	_on_text_change() # text_changed is not automatically emitted

func _on_visibility_change():
	if not visible:
		return
	reset()
	
func _on_text_change():
	var num_words = 0
	# TODO make the multi-delimiter split global and use it here
	num_words += len(title_edit.text.split(" ", false))
	num_words += len(text_edit.text.split(" ", false))
	word_count.text = "Words: %s" % num_words
	var l = Label.new()
#	l.color
	if num_words > 1000:
		word_count.add_color_override("font_color", Color.darkred)
	else:
		word_count.add_color_override("font_color", Color())
