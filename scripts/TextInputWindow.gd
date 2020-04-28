extends VBoxContainer

signal translation_requested(text_info)

onready var title_edit = find_node("TitleEdit")
onready var text_edit = find_node("TextEdit")
onready var word_count = find_node("WordCounter")

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	title_edit.connect("text_changed", self, "_on_text_change")
	text_edit.connect("text_changed", self, "_on_text_change")
	
	title_edit.set_focus_next(text_edit.get_path())
		
func reset():
	title_edit.text = ""
	text_edit.text = ""
	_on_text_change() # text_changed is not automatically emitted

func _on_visibility_change():
	if not visible:
		return
	reset()
	
func _on_text_change():
	update_word_counter()

	
func update_word_counter():
	var num_words = 0
	# TODO make the multi-delimiter split global and use it here
	num_words += len(title_edit.text.split(" ", false))
	num_words += len(text_edit.text.split(" ", false))
	word_count.text = "Words: %s" % num_words
	var l = Label.new()
#	l.color
	if num_words > 1000:
		word_count.add_color_override("font_color", Color.darkred)
		find_node("WordCounterAnimation").play("excess")
	else:
		word_count.add_color_override("font_color", Color())

func _input(event):
	if event.is_action_pressed("ui_focus_prev") and has_focus():
		if focus_previous != "":
			print(123)
#			get_node(focus_previous).grab_focus()
#		get_tree().set_input_as_handled()
#	elif event.is_action_pressed("ui_focus_next") and has_focus():
#		if focus_next != "":
#			get_node(focus_next).grab_focus()
#		get_tree().set_input_as_handled()

func _on_CreateButton_pressed():
	emit_signal("translation_requested", [title_edit.text, text_edit.text])
