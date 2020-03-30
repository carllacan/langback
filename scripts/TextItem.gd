extends PanelContainer

func load_text_info(text_info):

	find_node("OriginalLanguage").text = text_info["Language"]
	find_node("TextTitle").text = text_info["Title"]
	var sentence_num = len(text_info["Sentences"])
	
	find_node("SentenceNumber").text = "%s sentences" % sentence_num
