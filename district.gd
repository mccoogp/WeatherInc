extends Node2D

@export var DistrictNumber = 1
@export var water = false
@export var population = 1000
@export var productivity = 1
@export var tax = 1.5
var newtax = 1.5
@export var popularity = 50
var setup = 1
@export var product = [] 
var clicked = false
var votes = 0
@export var adjacent: Array[Node2D] = []

@export var center: Vector2
@export var zoom: float

@export var image: Texture
@export var disaster = []


func _ready() -> void:
	$Main.texture = image

func _input(event):
	$ProductionImage.texture = null
	for prod in product:
		$ProductionImage.texture = load("res://icons/" + prod + ".png")
	$Disaster.texture = null
	for dis in disaster:
		$Disaster.texture = load("res://4caster Art/disasters/" + dis + ".png")
		
func _process(delta: float) -> void:
	$ProductionImage.modulate = Color(setup,setup,setup)
