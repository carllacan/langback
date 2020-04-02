extends Node

#class_name Settings

const SETTINGS_SAVEFILE = "res://settings.json"
const DEFAULT_SETTINGS_FILE = "res://default_settings.json"

var translation_language = "en" setget set_translation_language
var fullscreen = false setget set_fullscreen

func _ready():
	load_settings()

func reset():
	load_settings(DEFAULT_SETTINGS_FILE)
	
func save_settings(file = SETTINGS_SAVEFILE):
	var settings = {}
	settings["translation_language"] = translation_language
	settings["fullscreen"] = fullscreen
	
	var settings_json = JSON.print(settings)
	var settings_file = File.new()
	settings_file.open(SETTINGS_SAVEFILE, File.WRITE)
	settings_file.store_string(settings_json)
	settings_file.close()
	
func load_settings(file = SETTINGS_SAVEFILE):
	var settings_file = File.new()
	settings_file.open(SETTINGS_SAVEFILE, File.READ)
	var settings_json = settings_file.get_as_text()
	settings_file.close()
	
	var json_parse = JSON.parse(settings_json)
	if json_parse.error != OK:
		print("Error loading settings")
		return
	var settings = json_parse.result
	translation_language = settings["translation_language"]
	fullscreen = settings["fullscreen"]


func set_translation_language(val):
	if val in ["en", "es"]:
		translation_language = val 
	else:
		print("maaal")
		return
	print("Translation language setting changed to %s" % val)

func set_fullscreen(val):
	fullscreen = val
	save_settings()
	print("Fullscreen by default setting changed to %s" % val)
