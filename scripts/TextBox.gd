extends TextEdit

class_name TextBox

func set_focus_next(value):
	get_node(value).focus_previous = get_path()
	.set_focus_next(value)

func _input(event):
	if event.is_action_pressed("ui_focus_prev") and has_focus():
		if focus_previous != "":
			get_node(focus_previous).grab_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_focus_next") and has_focus():
		if focus_next != "":
			get_node(focus_next).grab_focus()
		get_tree().set_input_as_handled()
