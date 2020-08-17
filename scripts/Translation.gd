extends Node

class_name TranslationRequest

signal sentence_translated
signal finished(text)

#const SENTENCE_DELIMITERS = ".!?…«»\"„“"
const SENTENCE_DELIMITERS = ".!?…"
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

var sentences = []

var httpreq

func _init(_text):
	text = _text
	create_sentences()
	pass
	
func _ready():
	# Define the HTTPRequest object, which requests translation from the API
	httpreq = HTTPRequest.new()
	# the HTTPRequest objects must be a child, or it won't work
	add_child(httpreq)
	httpreq.connect("request_completed", self, "_on_request_completed")
		
	
func create_sentences():
	# Splits sentences using periods and other characters, and adds them to
	# the translation queue
	
	# First preprocess the text and replace problematic characters.
	for c in REPLACEMENTS:
		text.body = text.body.replace(c, REPLACEMENTS[c])
		7
	# Use the multi-delimiter method to split the text into sentences
	for sentence in Globals.split(text.body, SENTENCE_DELIMITERS):
		if len(sentence) >=1:
			sentences.append([sentence])

func begin():
	# Trigger the translation of sentences
	translate_sentence(sentences[0][0], text.language, "en")
	
func add_translation(translation):
	# triggered each time a translation request is finished
	# adds the translation results to the sentence list
	
	# Look for the appropriate pair in the dictionary and append it
	for sentence_pair in sentences:
		if len(sentence_pair) != 2:
			sentence_pair.append(translation)
			emit_signal("sentence_translated")
			break

	check_if_done()
	
func check_if_done():
	# Check whether all sentences have already been translated.
	# If they are not, translate the next one.

	for sentence_pair in sentences:
		# If a sencente is still not done trigger its translation
		if len(sentence_pair) != 2:
			translate_sentence(sentence_pair[0], text.language, "en")
			return # no need to check further
			
	# If we get here all sentences have a translation, so we finish the process
	_on_translation_completion()

func _on_translation_completion():
	# Triggered iff all sentences have been translated
	
	print("All done!")

	for sentence_pair in sentences:
		var original = sentence_pair[0]
		var translation = sentence_pair[1]
		
		if original == "--" or len(translation) < 2:# or len(sentence_info["Original"]) < 2:
			continue
			
		print("Original:\t" + original)
		print("Translation:\t" + translation)
		
		var sentence_info = {"Original":original,
							 "Translation":translation,
							 "Done":false}

		text.add_sentence(sentence_info)
		print(text.sentences)

	text.save()
	emit_signal("finished", text)


func translate_sentence(sentence, origin, target):
	# Send the HTTP request to the API
	var url_pattern = "https://api.mymemory.translated.net/get?q=%s&langpair=%s|%s"
	var url = url_pattern % [sentence.percent_encode(), origin, target]

	var headers = ["Content-Type: application/json"]
	httpreq.request(url, headers)
	
func _on_request_completed(result, response_code, headers, body):
	# Parse the HTTP response and pass the results to the next step
	# Triggered when the HTTP request finishes and is responded
	
	# scheme of a response from mymemory:
	
	
	var response_text = body.get_string_from_utf8()
	var parsed_res = parse_json(response_text)
	
	var response_ok = true	
#	if not "responseData" in parsed_res:
#		print("No responseData field in response")
#		response_ok = false
#	elif not "translatedText" in parsed_res["responseData"]:
#		print("No translatedText field in responseData")
#		response_ok = false
	if not "matches" in parsed_res:
		print("No matches field in response")
		response_ok = false
	elif len(parsed_res["matches"]) == 0:
		print("matches list contains no elements")
		response_ok = false
	elif not "segment" in parsed_res["matches"][0]:
		print("No segments field in first element of mathces list")
		response_ok = false
		
	if not response_ok:
		print(response_text)
		add_translation("--")
		return
		
	var quota_full = parsed_res["quotaFinished"]

	var translation = parsed_res["responseData"]["translatedText"]

	for ch in TRANSLATION_REPLACEMENTS:
		translation = translation.replace(ch, TRANSLATION_REPLACEMENTS[ch])
		
	# Remove leading spaces
	while translation[0] == " ":
		translation = translation.lstrip(" ")
	# Remove trailing spaces
	translation = translation.rstrip(" ")

	add_translation(translation)
