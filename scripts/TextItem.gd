extends PanelContainer

signal chosen
var text_info

func _ready():
	find_node("LoadButton").connect("pressed", self, "_when_chosen")
	
func _when_chosen():
	emit_signal("chosen", text_info)

func load_text_info(_text_info):
	text_info = _text_info
	find_node("OriginalLanguage").text = text_info["Language"]
	find_node("TextTitle").text = text_info["Title"]
	var sentence_num = len(text_info["Sentences"])
	find_node("SentenceNumber").text = "%s sentences" % sentence_num
