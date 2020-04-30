extends VBoxContainer

signal table_created(table)

var TableSectionEdit = load("res://scenes/TableSectionEdit.tscn")

onready var title_edit = find_node("TitleBox")
onready var sections_grid = find_node("SectionsGrid")

var sections = []

func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	
		
func _on_visibility_change():
	if visible:
		reset()
			
func reset():
	for section in sections_grid.get_children():
		sections_grid.remove_child(section)
		section.queue_free()
	add_section()
	
func add_section():
	var new_tse = TableSectionEdit.instance()
	sections.append(new_tse)
	sections_grid.add_child(new_tse)
	return new_tse
	
func _on_AddButton_pressed():
	var new_tse = add_section()
	new_tse.find_node("TextEdit").text = ""

func _on_RemoveButton_pressed():
	sections_grid.remove_child(sections_grid.get_children()[-1])
	
func _on_CreateButton_pressed():
	var table = Table.new()
	table.set_title(title_edit.text)
	
	for section in sections_grid.get_children():
		table.create_section(section.find_node("TextEdit").text)
	print(table.make_dict())
	table.save()
	
	emit_signal("table_created", table)


