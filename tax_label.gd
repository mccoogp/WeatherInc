extends Label


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton:
		position.y = 1138.002 + 350 * $DistrictMenu/Popularity.extra
