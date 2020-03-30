extends VBoxContainer

func split(string, delimiters):
	# Custom string split function that can use more than one delimiter.
	var parts = ['']
	for c in string:
		if c in delimiters:
			parts.append('')
		else:
			parts[-1] += c
	return parts

func _on_ResetButton_pressed():
	var text = find_node("TextEdit").text
	text = text.replace("\n","")
#	var sentences = text.split('.', false)
	var sentences = split(text, ['.','!'])
	for s in range(len(sentences)):
		sentences[s].dedent()
	print(sentences)
	
	find_node("TitleEdit").text = ""
	find_node("TextEdit").text = ""
