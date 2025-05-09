extends Sprite2D

var extras = [0, 0]
@export var extend: Array[Node2D] = []

static func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
		return sum

func _process(delta: float) -> void:
	var extra = int(floor(sum_array(extras)/2))
	$LeftMenuBottom.position.y = -45 + 42 * extra
	for extending in len(extend):
		extend[extending].visible = false
	for extending in extra:
		extend[extending].visible = true
	$Industry/Label2.position.y = -540 + 112 * sum_array(extras)
	
func _input(event: InputEvent) -> void:
	print(extras)
