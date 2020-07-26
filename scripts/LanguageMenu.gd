extends HBoxContainer

#signal language_selected(lang)
signal done(next_window_name, output)

var LanguageBox = load("res://scenes/LanguageButton.tscn")
var new_thing # could be a text or a table

const LANGUAGES = {"de":"Deutsch",
				   "fr":"Français",
				   "it":"Italiano",
				   "pt":"Portuguese",
				   "es":"Spanish"}
					
onready var language_list = find_node("LanguageList")
onready var language_grid = find_node("LanguageGrid")

func _ready():
	for lang in LANGUAGES:
#		var new_lb = LanguageBox.instance()
#		new_lb.text = LANGUAGES[lang]
		
		var new_lb = TextureButton.new()
#		var lang_texture = StreamTexture.new()
#		lang_texture.load_path = "res://flags/%s.png" % lang
		var lang_texture = load("res://flags/%s.png" % lang)
		new_lb.texture_normal = lang_texture
#		new_lb.texture_normal = lang_texture

		language_grid.add_child(new_lb)
		new_lb.connect("pressed", self,  "_on_language_selected", [lang])
			
func enter(input):
	new_thing = input
	show()
	
func exit():
	hide()
	
func _on_CancelButton_pressed():
	emit_signal("done", "MainMenuWindow", null)

func _on_language_selected(lang):
	new_thing.set_language(lang)
	if new_thing.is_text():
		emit_signal("done", "TextCreateWindow", new_thing)
	else:
		emit_signal("done", "TableCreateWindow", new_thing)
	
		
