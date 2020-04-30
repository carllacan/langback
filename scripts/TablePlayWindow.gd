extends VBoxContainer

var TableSectionPlay = load("res://scenes/TableSectionPlay.tscn")

onready var title_label = find_node("TitleBox")
onready var sections_grid = find_node("SectionsGrid")

func load_table(table):
	title_label.text = table.title
	for section in table.sections:
		var new_tsp = TableSectionPlay.instance()
		sections_grid.add_child(new_tsp)
		new_tsp.load_section(section)
