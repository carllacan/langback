extends Node2D

#var title = ""
var language
var sentences = []
var current_window

onready var main_menu = find_node("MainMenu")
onready var load_menu = find_node("LoadMenu")
onready var language_menu = find_node("LanguageMenu")
onready var text_input_window = find_node("TextInputWindow")
onready var progress_window = find_node("ProgressWindow")
onready var progress_bar = find_node("ProgressBar")
onready var sentences_window = find_node("SentenceList")


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	
	language_menu.connect("language_selected", self, "_on_language_selection")
	
	main_menu.hide()
	load_menu.hide()
	language_menu.hide()
	text_input_window.hide()
	progress_window.hide()
	sentences_window.hide()
	
	current_window = main_menu
	current_window.show()

func change_window(new):
	
	current_window.hide()
	current_window = new
	current_window.show()
	
#func _create():
#	sentences = [["Ola","Hello"],["Ciao","Goodbye"]]
#	_on_translation_completion()

func _create():
	var text_box = find_node("TextEdit")
	var text = text_box.text
#	var url = "https://yandextranslatezakutynskyv1.p.rapidapi.com"
#	$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_POST, "translate")

	print("Translating...")

	text_input_window.hide()
	progress_window.show()

	for sentence in text.split("."):
		if len(sentence) >=1:
			sentences.append([sentence])
	print(sentences)
	translate_sentence(sentences[0][0], language, "en")

func add_translation(translation):
	for sentence_pair in sentences:
		if len(sentence_pair) != 2:
			sentence_pair.append(translation)
			progress_bar.value += 100/len(sentences)
			progress_bar.value = ceil(progress_bar.value)
			break

	# We need to check whether all sentences have already been translated.
	# If they are not, translate the next one.
	# If they are, go to the next step.
	var all_translated = true
	for sentence_pair in sentences:
		if len(sentence_pair) != 2:
			translate_sentence(sentence_pair[0], language, "en")
			return
			all_translated = false
	if all_translated:
		_on_translation_completion()

func _on_translation_completion():
	print("All done!")
	print(sentences)
	for sentence_pair in sentences:
		print("Original:\t" + sentence_pair[0])
		print("Translation:\t" + sentence_pair[1])

	var text_info = {}
	text_info["Title"] = find_node("TitleEdit").text
	text_info["Language"] = language
	text_info["Sentences"] = []
	for sentence in sentences:
		var sentence_info = {"Original":sentence[0],
							 "Translation":sentence[1]}
		
		
	save_text(text_info)
	
	progress_window.hide()
	sentences_window.show()
	sentences_window.add_sentences(sentences)


func translate_sentence(sentence, origin, target):
	var url_pattern = "https://api.mymemory.translated.net/get?q=%s&langpair=%s|%s"
	var url = url_pattern % [sentence.percent_encode(), origin, target]

	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers)
	
func _on_request_completed(result, response_code, headers, body):
	print("Result:")
	var parsed_res = parse_json(body.get_string_from_utf8())
	if not "responseData" in parsed_res:
		add_translation("--")
		return
	if not "translatedText" in parsed_res["responseData"]:
		add_translation("--")
		return
	if not "matches" in parsed_res:
		add_translation("--")
		return
	if len(parsed_res["matches"]) == 0:
		add_translation("--")
		return
	if not "segment" in parsed_res["matches"][0]:
		add_translation("--")
		return

	var translation = parsed_res["responseData"]["translatedText"]
	var original = parsed_res["matches"][0]["segment"]

	add_translation(translation)

func _on_CreateButton_pressed():
	change_window(language_menu)
	
func _on_LoadButton_pressed():
	change_window(load_menu)
	
func _on_language_selection(lang):
	language = lang
	change_window(text_input_window)

func make_filename(title):
	var fn = title
	var to_remove = ".,/ \\$%"
	for ch in to_remove:
		fn = fn.replace(ch, "")
	return fn.substr(0, 15) + ".json"
		
func save_text(text_info):
	var saved_texts = File.new()
	var fn = make_filename(text_info["Title"])
	saved_texts.open("res://saved_texts/" + fn, File.WRITE)
	saved_texts.store_string(JSON.print(text_info))
	saved_texts.close()
		


