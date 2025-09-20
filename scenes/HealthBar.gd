extends ProgressBar

func _ready():
	hide()

func update_health_bar(current_health: int, max_health: int):
	max_value = max_health
	value = current_health
	show()
	if current_health <= 0:
		hide()
