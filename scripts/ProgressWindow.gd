extends MarginContainer

signal done(next_window, output)
var limit = 100
var text
#var text # text to be translated

onready var progress_bar = find_node("ProgressBar")

func enter(input):
	text = input
	begin_translation(text)
	show()
		
func exit():
	hide()

func set_limit(_limit):
	limit = _limit
	
func increase_progress():
	progress_bar.value += 100/limit
	progress_bar.value = ceil(progress_bar.value)
	
func begin_translation(text):

	print("Translating...")

	
	var translation = TranslationRequest.new(text)
	add_child(translation) # otherwise HTTPRequest won't work
	translation.connect("finished", self, "_on_translation_finished")
#	translation.set_text(text.body)
#	translation.set_language(language)
	
	set_limit(len(translation.sentences))
	translation.connect("sentence_translated", self, "increase_progress")
	translation.begin()
	
		
func _on_translation_finished(text):
#	_on_text_choice(text[0])
	emit_signal("done", "TextPlayWindow", text)
	
# TODO: stop translation button
