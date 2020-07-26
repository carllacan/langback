extends Node

class_name Text

var language = ""
var title = ""
var sentences = []
var body = ""

var created
var last_played
var autosave = true # save everytime something changes

func _ready():
	created = Globals.get_datetime()
	last_played = Globals.get_datetime() # TODO: allow empty

func is_text():
	return true
	
func _init():
	pass
	
func set_language(lang):
	language = lang
	
func set_content(text_info):
	title = text_info["Title"]
	if "Creation" in text_info:
		created = text_info["Creation"]
	else:
		created = Globals.get_datetime()
	if "LastPlayed" in text_info:
		last_played = text_info["LastPlayed"]
	else:
		last_played = Globals.get_datetime()
	for s in text_info["Sentences"]:
		add_sentence(s)
		
func add_sentence(sentence_info):
		sentences.append(Sentence.new(sentence_info))
	
func reset():
	autosave = false # disable autosave to avoid saving for each sentence
	for sentence in sentences:
		sentence.reset()
	save()
	autosave = true
		
func make_filename():
	var fn = title
	var to_remove = ".,/ \\$%"
	for ch in to_remove:
		fn = fn.replace(ch, "")
	return fn.substr(0, 15) + ".json"
		
func make_dict():
	var text_info = {}
	text_info["Title"] = title
	text_info["Creation"] = created
	text_info["LastPlayed"] = last_played
	text_info["Language"] = language
	text_info["Sentences"] = []
	for sentence in sentences:
		var sentence_info = sentence.make_dict()
#		sentence_info["Original"] = sentence.original
#		sentence_info["Translation"] = sentence.translation
#		sentence_info["Done"] = sentence.done
		text_info["Sentences"].append(sentence_info)
	return text_info
		
func _on_sentence_change():
	if autosave:
		save()		

func update_played_date():
	last_played = Globals.get_datetime()
	
func save(update_played_date = true):
	if update_played_date:
		update_played_date()
	var savefile = File.new()
	var fn = make_filename()
	savefile.open("res://saved_texts/" + fn, File.WRITE)
	
	savefile.store_string(JSON.print(make_dict()))
	savefile.close()
	# TODO: if file exists add a number
	
func get_progress():
	var done = 0
	for s in sentences:
		if s.done:
			done += 1
	var total = len(sentences)
	return done
