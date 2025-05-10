extends Node2D
var volume = 100


func _input(event):
	$volume.text = "volume: " + str(volume) + "%"
	if volume >= 100:
		$vol_up.visible = false
	else:
		$vol_up.visible = true
	if volume <= 0:
		$vol_down.visible = false
	else:
		$vol_down.visible = true


signal resume_game 

func _ready():
	$Button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("emmiting")
	emit_signal("resume_game")


func _on_vol_up_pressed() -> void:
	if volume < 100:
		volume += 20


func _on_vol_down_pressed() -> void:
	if volume > 0:
		volume -= 20
