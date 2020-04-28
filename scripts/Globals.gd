extends Node

var LANGUAGES = {"de":"Deutsch",
				 "fr":"Français",
				 "it":"Italiano",
				 "pt":"Portuguese",
				 "es":"Spanish"}
				
const DATE_FIELDS = ["year", "month", "day", "hour","minute","second"]	

func get_datetime():
	var full_datetime = OS.get_datetime()
	var datetime = {}
	for field in DATE_FIELDS:
		datetime[field] = full_datetime[field]
	return datetime
	
func datetime_to_str(datetime):
	var fields = []
	for field in DATE_FIELDS:
		fields.append(datetime[field])
	return "%s/%s/%s %02d:%02d:%02d" % fields
	
func compare_text_box_creation_dates(a, b):
	for field in DATE_FIELDS:
		if a.text.created[field] < b.text.created[field]:
			return true
		elif a.text.created[field] > b.text.created[field]:
			return false
	return false
	
func compare_text_box_lastplayed_dates(a, b):
	for field in DATE_FIELDS:
		if a.text.last_played[field] < b.text.last_played[field]:
			return true
		elif a.text.last_played[field] > b.text.last_played[field]:
			return false
	return false
	
func compare_text_box_progress(a, b):
	if a.text.get_progress() < b.text.get_progress():
		return true
	return false
	
func load_json(filepath):
	var json_file = File.new()
	json_file.open(filepath, File.READ)
	var json_text = json_file.get_as_text()
	var json_parsing = JSON.parse(json_text)
	if json_parsing.error == OK:
		return json_parsing.result
	else:
		print("==================================================")
		print("Error loading JSON file at " + filepath)
		print('\t' + json_parsing.error_string)
		print("\tAt line: " + str(json_parsing.error_line))
		print("==================================================")
	
func _ready():
	LANGUAGES = load_json("res://info/languages.json")
	print(LANGUAGES)
	
