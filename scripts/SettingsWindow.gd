extends CenterContainer

func _on_visiblity_change():
	if visible: # if show
		pass # update controls
		
func _on_SaveButton_pressed():
	# Save settings
	hide()


func _on_CancelButton_pressed():
	hide()
