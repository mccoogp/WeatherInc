extends Node2D





@export var districts: Array[Node2D] = []
var totalpop = 0
var foodprod = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event):
	for district in 9:
		if districts[district].clicked == true:
			if "food" in districts[district].production:
				districts[district].production.erase("food")
			else:
				if "food" not in districts[district].production:
					districts[district].production.append("food")
			districts[district].clicked = false
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_SPACE):
			totalpop = 0
			foodprod = 0
			for district in 9:
				totalpop += districts[district].population
				if "food" in districts[district].production:
					foodprod += 3000
		$Label.food += foodprod - totalpop
