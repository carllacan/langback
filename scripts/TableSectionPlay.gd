extends PanelContainer

onready var lines_list = find_node("LinesList")

var answers = {}

func _ready():
	pass

func load_section(section):
	for line in section:
		if len(line) > 0:
			var line_box = HBoxContainer.new()
			lines_list.add_child(line_box)
			
			var label = Label.new()
			label.text = line[0]
			line_box.add_child(label)
			if len(line) > 1:
				var question = LineEdit.new()
				answers[question] = line[1]
				line_box.add_child(question)
				question.connect("text_changed", self, "_ontext_change", [line_box])
			
func _ontext_change(a, linebox):
	var status # 0 ok so far, 1 wrong, 2 done
	for child in linebox.get_children():
		if child is LineEdit:
			print(child.text)
			print(len(answers[child]))
			if child.text == answers[child]:
				status = 2
			elif child.text == answers[child].substr(0, len(child.text)):
				status = 0
			else:
				status = 1
	for child in linebox.get_children():
		if child is Label:
			match status:
				0:
					child.add_color_override("font_color", Color())
				1:
					child.add_color_override("font_color", Color.red)
				2:
					child.add_color_override("font_color", Color.green)
				
		
