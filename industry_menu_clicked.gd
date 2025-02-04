extends Sprite2D

@export var menu: Node2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_pixel_opaque(get_local_mouse_position()):
				menu.industry_clicked = true
				print("working")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if is_pixel_opaque(get_local_mouse_position()):
				menu.industry_clicked = false
