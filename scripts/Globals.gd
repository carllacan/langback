extends Node

const LANGUAGES = {"de":"Deutsch",
				   "fr":"Français",
				   "it":"Italiano",
				   "pt":"Portuguese",
				   "es":"Spanish"}
				
func get_datetime():
	var full_datetime = OS.get_datetime()
	var datetime = {}
	for field in ["year", "month", "day", "hour","minute","second"]:
		datetime[field] = full_datetime[field]
	return datetime
	
func datetime_to_str(datetime):
	var fields = []
	for field in ["year", "month", "day", "hour","minute","second"]:
		fields.append(datetime[field])
	return "%s/%s/%s %02d:%02d:%02d" % fields
