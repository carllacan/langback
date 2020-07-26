extends Node2D

#const SENTENCE_DELIMITERS = ".!?…«»\"„“"
#const REPLACEMENTS = {
#	"’": "'",
#	"\n":".",
#	"\r":".",
# }
#
#const TRANSLATION_REPLACEMENTS = {
#	"…":"...",
#	"&#39;":"'",
#	"&quot":"",
#}
	
#var title = ""
var language
#var sentences = []
#var text_title = ""
var current_window

onready var main_menu_window = find_node("MainMenu")
onready var text_load_window = find_node("TextLoadMenu")
onready var table_load_menu = find_node("TableLoadMenu")
onready var language_selection_window = find_node("LanguageMenu")
onready var text_create_window = find_node("TextCreateWindow")
onready var table_create_window = find_node("TableCreateWindow")
onready var progress_window = find_node("ProgressWindow")
onready var progress_bar = find_node("ProgressBar")
onready var text_play_window = find_node("TextPlayWindow")
onready var table_play_window = find_node("TablePlayWindow")
onready var settings_window = find_node("SettingsWindow")

onready var windows = {}


func _ready():

#	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
#	language_menu.connect("language_selected", self, "_on_language_selection")
#	load_menu.connect("text_chosen", self, "_on_text_choice")
#	text_input_window.connect("translation_requested", self, "_create_text")
#	table_load_menu.connect("table_chosen", self, "_on_table_choice")
#	table_create_window.connect("table_created", self, "_on_table_creation")
	
#	load_menu.connect("done", self, "_on_done")
	
#	windows["MainMenuWindow"] = main_menu_window
#	windows["LanguageSelectionWindow"] = language_selection_window
#	windows["TextCreateWindow"] = text_create_window
#	windows["TextLoadWindow"] = load_window
#	windows["TranslateWindow"] = text_play_window
#	windows["TableCreateWindow"] = table_create_window
#	windows["TableLoadWindow"] = table_load_menu
	
	var window_names = ["MainMenuWindow",
						"TextLoadWindow",
						"TableLoadWindow",
						"LanguageSelectionWindow",
						"TextCreateWindow",
						"TableCreateWindow",
						"ProgressWindow",
						"TextPlayWindow",
						"TablePlayWindow",
						]
	
	for wname in window_names:
		windows[wname] = find_node(wname)
		if windows[wname] == null:
			print(wname)
			print("ERROR: window %s not found" % wname)
#	for window in windows.values():
		windows[wname].connect("done", self, "_on_done")
		windows[wname].hide()
	
#	main_menu.hide()
#	load_menu.hide()
#	language_menu.hide()
#	table_create_window.hide()
#	text_input_window.hide()
#	progress_window.hide()
#	sentences_window.hide()
#	table_play_window.hide()
	
	current_window = windows["MainMenuWindow"]
	current_window.show()
	
	resize()

#func change_window(new):
#	current_window.hide()
#	current_window = new
#	current_window.show()
	
func _on_done(next_window_name, output):
	var next_window = windows[next_window_name]
	current_window.exit()
	current_window = next_window
	if output != null:
		next_window.enter(output)
	else:
		next_window.enter()
	
	
func _create_text(text):

	print("Translating...")

	
	var translation = TranslationRequest.new(text)
	add_child(translation) # otherwise HTTPRequest won't work
	translation.connect("translation_finished", self, "_on_translation_finished")
#	translation.set_text(text_info)
	translation.set_language(language)
	
	progress_window.set_limit(len(translation.sentences))
	translation.connect("sentence_translated", progress_window, "increase_progress")
	translation.begin()

	
#	change_window(progress_window)
	

#func _on_CreateButton_pressed():
#	change_window(language_menu)
	
#func _on_LoadButton_pressed():
#	change_window(load_menu)
	
#func _on_language_selection(lang):
#	language = lang
#	change_window(text_input_window)


#func _on_translation_finished(text):
#	_on_text_choice(text[0])

#func _on_text_choice(text): # rename to load text
#	text_info = _text_info
#	sentences_window.add_text_info(text)
#	change_window(sentences_window)
	
#func _on_table_choice(table):
#	_on_table_creation(table)


#func _on_CancelButton_pressed():
#	change_window(main_menu)

func _input(event):
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()

func _on_FullscreenButton_pressed():
	toggle_fullscreen()
	
func toggle_fullscreen():
	OS.window_fullscreen = not OS.window_fullscreen
#	resize()
	
func resize():
	var new_size = get_node("/root").size#OS.get_real_window_size()
	find_node("VBoxContainer").rect_size = new_size
	find_node("VBoxContainer").rect_size = new_size
		
func _on_SettingsButton_pressed():
	settings_window.show()

func _on_CheckButton_toggled(button_pressed):
	Settings.fullscreen = button_pressed


#func _on_CreateTableButton_pressed():
#	change_window(table_create_window)
	
#func _on_TableButton_pressed():
#	change_window(table_load_menu)

#func _on_table_creation(table):
#	table_play_window.load_table(table)
#	change_window(table_play_window)
