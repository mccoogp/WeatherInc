extends Node2D

@export var DistrictNumber = 1
@export var water = false
@export var population = 1000
var production =[]
var clicked = false

@export var center: Vector2
@export var zoom: float

@export var image: Texture

func _ready() -> void:
	$Main.texture = image

func _input(event):
	if "food" in production:
		$FoodImage.scale = Vector2(0.003, 0.003)
	else:
		$FoodImage.scale = Vector2(0, 0)
