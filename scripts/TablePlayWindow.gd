extends VBoxContainer

var TableSectionPlay = load("res://scenes/TableSectionPlay.tscn")

onready var title_label = find_node("TitleBox")
onready var sections_grid = find_node("SectionsGrid")

func _on_CancelButton_pressed():
	emit_signal("done", "MainMenuWindow", null)

func enter(input):
	load_table(input)
	show()
	
func exit():
	hide()
	for table_box in sections_grid.get_children():
#		print(sentence_box.translation)
		sections_grid.remove_child(table_box)
		table_box.queue_free()
		
func load_table(table):
	title_label.text = table.title
	for section in table.sections:
		var new_tsp = TableSectionPlay.instance()
		sections_grid.add_child(new_tsp)
		new_tsp.load_section(section)
