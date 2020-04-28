extends MarginContainer

var limit = 100

onready var progress_bar = find_node("ProgressBar")

func set_limit(_limit):
	limit = _limit
	
func increase_progress():
	progress_bar.value += 100/limit
	progress_bar.value = ceil(progress_bar.value)
