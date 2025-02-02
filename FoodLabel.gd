extends Label


var food = 10000


func _process(delta: float) -> void:
	text = "Food = " + str(food)
