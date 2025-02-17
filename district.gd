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
	$ProductionImage.texture = null
	for prod in product:
		$ProductionImage.texture = load("res://icons/" + prod + ".png")
