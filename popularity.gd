extends Sprite2D

@export var menu: Node2D
@export var extra = 0
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_pixel_opaque(get_local_mouse_position()):
				print("here")
				menu.popularity_clicked = true
				print("here")
				menu.anyclicked = true
				print("here")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if is_pixel_opaque(get_local_mouse_position()):
				menu.popularity_clicked = false
	position.y = 1087.5 + 350 * extra
