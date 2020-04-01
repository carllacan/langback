extends HBoxContainer

signal language_selected(lang)

var LanguageBox = load("res://scenes/LanguageButton.tscn")

const LANGUAGES = {"en":"English",
					"de":"Deutsch",
					"fr":"Français",
					"it":"Italiano"}
					
onready var language_list = find_node("LanguageList")

func _ready():
	for lang in LANGUAGES:
		var new_lb = LanguageBox.instance()

		language_list.add_child(new_lb)
		new_lb.text = LANGUAGES[lang]
		new_lb.connect("pressed", self,  "_on_language_selected", [lang])
		
			
func _on_language_selected(lang):
	emit_signal("language_selected", lang)
		
