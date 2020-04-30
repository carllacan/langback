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

onready var main_menu = find_node("MainMenu")
onready var load_menu = find_node("LoadMenu")
onready var table_load_menu = find_node("TableLoadMenu")
onready var language_menu = find_node("LanguageMenu")
onready var table_create_window = find_node("TableCreateWindow")
onready var text_input_window = find_node("TextInputWindow")
onready var progress_window = find_node("ProgressWindow")
onready var progress_bar = find_node("ProgressBar")
onready var sentences_window = find_node("SentenceList")
onready var table_play_window = find_node("TablePlayWindow")
onready var settings_window = find_node("SettingsWindow")



func _ready():

	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
	language_menu.connect("language_selected", self, "_on_language_selection")
	load_menu.connect("text_chosen", self, "_on_text_choice")
	table_load_menu.connect("table_chosen", self, "_on_table_choice")
	text_input_window.connect("translation_requested", self, "_create_text")
	table_create_window.connect("table_created", self, "_on_table_creation")
	
	main_menu.hide()
	load_menu.hide()
	language_menu.hide()
	table_create_window.hide()
	text_input_window.hide()
	progress_window.hide()
	sentences_window.hide()
	table_play_window.hide()
	
	current_window = main_menu
	current_window.show()
	
	resize()

func change_window(new):
	current_window.hide()
	current_window = new
	current_window.show()
	
func _create_text(text_info):

	print("Translating...")

	
	var translation = TranslationRequest.new()
	add_child(translation) # otherwise HTTPRequest won't work
	translation.connect("translation_finished", self, "_on_translation_finished")
	translation.set_text(text_info)
	translation.set_language(language)
	
	progress_window.set_limit(len(translation.sentences))
	translation.connect("sentence_translated", progress_window, "increase_progress")
	translation.begin()

	
	change_window(progress_window)
	
	return
#
#func _create_text(text_info):
#	text =  find_node("TextEdit")
#	for c in REPLACEMENTS:
#		text = text.replace(c, REPLACEMENTS[c])
#
#	for sentence in Globals.split(text, SENTENCE_DELIMITERS):
#		if len(sentence) >=1:
#			sentences.append([sentence])
#	print(sentences)
#	translate_sentence(sentences[0][0], language, "en")
#
#func add_translation(translation):
#	for sentence_pair in sentences:
#		if len(sentence_pair) != 2:
#			sentence_pair.append(translation)
#			progress_bar.value += 100/len(sentences)
#			progress_bar.value = ceil(progress_bar.value)
#			break
#
#	# We need to check whether all sentences have already been translated.
#	# If they are not, translate the next one.
#	# If they are, go to the next step.
#	var all_translated = true
#	for sentence_pair in sentences:
#		if len(sentence_pair) != 2:
#			translate_sentence(sentence_pair[0], language, "en")
#			return
#			all_translated = false
#	if all_translated:
#		_on_translation_completion()
#
#func _on_translation_completion():
#	print("All done!")
#	print(sentences)
#	for sentence_pair in sentences:
#		print("Original:\t" + sentence_pair[0])
#		print("Translation:\t" + sentence_pair[1])
#
#	var text_info = {}
#	text_info["Title"] = text_title
#	text_info["Language"] = language
#	text_info["Sentences"] = []
#	for sentence in sentences:
#		var sentence_info = {"Original":sentence[0],
#							 "Translation":sentence[1],
#							 "Done":false}
#		if len(sentence_info["Translation"]) < 2:
#			continue
#		text_info["Sentences"].append(sentence_info)
#
#
#	var text = Text.new(text_info)
#	text.save()
#
#	_on_text_choice(text)
#
#
#func translate_sentence(sentence, origin, target):
#	var url_pattern = "https://api.mymemory.translated.net/get?q=%s&langpair=%s|%s"
#	var url = url_pattern % [sentence.percent_encode(), origin, target]
#
#	var headers = ["Content-Type: application/json"]
#	$HTTPRequest.request(url, headers)
#
#func _on_request_completed(result, response_code, headers, body):
#	print("Result:")
#	var parsed_res = parse_json(body.get_string_from_utf8())
#	if not "responseData" in parsed_res:
#		add_translation("--")
#		return
#	if not "translatedText" in parsed_res["responseData"]:
#		add_translation("--")
#		return
#	if not "matches" in parsed_res:
#		add_translation("--")
#		return
#	if len(parsed_res["matches"]) == 0:
#		add_translation("--")
#		return
#	if not "segment" in parsed_res["matches"][0]:
#		add_translation("--")
#		return
#
#	var translation = parsed_res["responseData"]["translatedText"]
#
#	for ch in TRANSLATION_REPLACEMENTS:
#		translation = translation.replace(ch, TRANSLATION_REPLACEMENTS[ch])
#	translation = translation.lstrip(" ")
#	translation = translation.rstrip(" ")
#
#	add_translation(translation)

func _on_CreateButton_pressed():
	change_window(language_menu)
	
func _on_LoadButton_pressed():
	change_window(load_menu)
	
func _on_language_selection(lang):
	language = lang
	change_window(text_input_window)


func _on_translation_finished(text):
	_on_text_choice(text[0])

func _on_text_choice(text): # rename to load text
#	text_info = _text_info
	sentences_window.add_text_info(text)
	change_window(sentences_window)
	
func _on_table_choice(table): # rename to load text
	_on_table_creation(table)


func _on_CancelButton_pressed():
	change_window(main_menu)

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


func _on_CreateTableButton_pressed():
	change_window(table_create_window)
	
func _on_TableButton_pressed():
	change_window(table_load_menu)

func _on_table_creation(table):
	table_play_window.load_table(table)
	change_window(table_play_window)
