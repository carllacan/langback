extends Node

const LANGUAGES = {"de":"Deutsch",
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
