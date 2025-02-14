extends Sprite2D


var industry_clicked:bool = false
var popularity_clicked:bool = false
var anyclicked = false
func _process(delta: float) -> void:
	var click = false
	if industry_clicked == true:
		click = true
	if popularity_clicked == true:
		click = true
	if click == false:
		anyclicked = false
