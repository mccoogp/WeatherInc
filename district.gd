extends Node2D

@export var DistrictNumber = 1
@export var water = false
@export var population = 1000
@export var productivity = 1
var product = []
var clicked = false

@export var center: Vector2
@export var zoom: float

@export var image: Texture

func _ready() -> void:
	$Main.texture = image

func _input(event):
	if "food" in product:
		$FoodImage.scale = Vector2(0.003, 0.003)
	else:
		$FoodImage.scale = Vector2(0, 0)
	if "factory" in product:
		$FactoryImage.scale = Vector2(0.0004, 0.0004)
	else:
		$FactoryImage.scale = Vector2(0, 0)
