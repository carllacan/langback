extends Node

class_name Table

var title = ""
var language
var created
var last_played
var sections = []

func _init():
	created = Globals.get_datetime()
	last_played = Globals.get_datetime() # TODO: allow empty
	
func is_text():
	return false
	
func set_title(_title):
	title = _title
	
func create_section(section_text):
	var new_section = []
	for line in section_text.split('\n'):
		var parts = line.replace('\n', '').split('|')
		new_section.append(parts)
	sections.append(new_section)
	
func load_table_info(table_info):
	title = table_info["Title"]
	sections = table_info["Sections"]
	
func make_filename():
	var fn = title
	var to_remove = ".,/ \\$%"
	for ch in to_remove:
		fn = fn.replace(ch, "")
	return fn.substr(0, 50) + ".json"
	
func make_dict():
	var table_info = {}
	table_info["Title"] = title
	table_info["Language"] = language
	table_info["Created"] = created
	table_info["LastPlayed"] = last_played
	table_info["Sections"] = sections
	return table_info
		
func update_played_date():
	last_played = Globals.get_datetime()
	
func save(update_played_date = true):
	if update_played_date:
		update_played_date()
	var savefile = File.new()
	var fn = make_filename()
	savefile.open("res://saved_tables/" + fn, File.WRITE)
	
	savefile.store_string(JSON.print(make_dict()))
	savefile.close()
	# TODO: if file exists add a number
