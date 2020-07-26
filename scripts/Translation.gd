extends Node

class_name TranslationRequest

signal sentence_translated
signal finished(text)

const SENTENCE_DELIMITERS = ".!?…«»\"„“"
const REPLACEMENTS = {
	"’": "'",
	"\n":".",
	"\r":".",
 }
					
const TRANSLATION_REPLACEMENTS = {
	"…":"...",
	"&#39;":"'",
	"&quot":"",
}

var text

var language = ""
var text_title = ""
var text_body = ""	
var sentences = []

onready var httpreq = HTTPRequest.new()

func _init(_text):
	text = _text
	create_sentences()
	pass
	
func _ready():
	add_child(httpreq)
	httpreq.connect("request_completed", self, "_on_request_completed")
		
func set_language(_language):
	language = _language
	
#func set_text(text):
##	text_title = text_info[0]
##	text_body = text_info[1]
#	create_sentences()
	
func create_sentences():
	for c in REPLACEMENTS:
		text.body = text.body.replace(c, REPLACEMENTS[c])
		
	for sentence in Globals.split(text.body, SENTENCE_DELIMITERS):
		if len(sentence) >=1:
			sentences.append([sentence])


func begin():
	translate_sentence(sentences[0][0], language, "en")

func add_translation(translation):
	for sentence_pair in sentences:
		if len(sentence_pair) != 2:
			sentence_pair.append(translation)
			emit_signal("sentence_translated")
#			progress_bar.value += 100/len(sentences)
#			progress_bar.value = ceil(progress_bar.value)
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
#	text_info["Title"] = text_title
#	text_info["Language"] = language
#	text_info["Sentences"] = []
	for sentence in sentences:
		var sentence_info = {"Original":sentence[0],
							 "Translation":sentence[1],
							 "Done":false}
		if len(sentence_info["Translation"]) < 2:
			continue
#		text_info["Sentences"].append(sentence_info)
		text.add_sentence(sentence_info)
		print(text.sentences)
		
		
#	var text = Text.new()
#	text.load_content(text_info)
	text.save()
	emit_signal("finished", text)


func translate_sentence(sentence, origin, target):
	var url_pattern = "https://api.mymemory.translated.net/get?q=%s&langpair=%s|%s"
	var url = url_pattern % [sentence.percent_encode(), origin, target]

	var headers = ["Content-Type: application/json"]
	httpreq.request(url, headers)
	
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
#	var original = parsed_res["matches"][0]["segment"]

	for ch in TRANSLATION_REPLACEMENTS:
		translation = translation.replace(ch, TRANSLATION_REPLACEMENTS[ch])
	translation = translation.lstrip(" ")
	translation = translation.rstrip(" ")

	add_translation(translation)
