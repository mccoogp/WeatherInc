extends Node2D

@export var DistrictNumber = 1
@export var water = false
@export var population = 1000
var production =[]
var clicked = false

func _input(event):
	if "food" in production:
		$FoodImage.scale = Vector2(0.003, 0.003)
	else:
		$FoodImage.scale = Vector2(0, 0)
