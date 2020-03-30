extends VBoxContainer

const SAVED_TEXTS_DIR = "res://saved_texts/"
var TextItem = load("res://scenes/TextItem.tscn")


func _ready():
	connect("visibility_changed", self, "_on_visibility_change")
	
func _on_visibility_change():
	if visible:
		return
	load_saved_texts()
	
func load_saved_texts():
	var load_dir = Directory.new()
	load_dir.open(SAVED_TEXTS_DIR)
	load_dir.list_dir_begin(true, true)
	
	print("Getting saved texts...")
	while true:
		var filename = load_dir.get_next()

		if filename == "":
			break
		if filename.ends_with(".json"):
			var file = File.new()
			file.open(SAVED_TEXTS_DIR + filename, file.READ)
			var json_result = JSON.parse(file.get_as_text())
			if json_result.error != OK:
				continue
			var text_info = json_result.result

			file.close()
			var new_ti = TextItem.instance()
			add_child(new_ti)
			new_ti.load_text_info(text_info)
	
