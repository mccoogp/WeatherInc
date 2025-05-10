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
var count = 0
@export var offset1 = Vector2(.3,.3)
@export var offset2 = Vector2(0.3, 0.3)
@export var offset3 = Vector2(0.3, 0.3)
@export var offset4 = Vector2(0.3, 0.3)
@export var offset5 = Vector2(0.3, 0.3)

func _ready() -> void:
	$Main.texture = image
	$ProductionImage.position = offset1
	$Disaster.position = offset2
	$Disaster2.position = offset3
	$Disaster3.position = offset4
	$Disaster4.position = offset5
	

func _input(event):
	$ProductionImage.texture = null
	for prod in product:
		$ProductionImage.texture = load("res://icons/" + prod + ".png")
	$Disaster.texture = null
	for dis in disaster:
		if dis == "rain":
			if count < 100:
				$Disaster.texture = load("res://4caster Art/disasters/rain.png")
			elif count < 200:
				$Disaster.texture = load("res://4caster Art/disasters/lightning.png")
			else:
				count = 0
		else:
			$Disaster.texture = load("res://4caster Art/disasters/" + dis + ".png")
		
func _process(delta: float) -> void:
	$ProductionImage.modulate = Color(setup,setup,setup)
	count += 1
	for dis in disaster:
		if dis == "rain":
			if count < 10:
				$Disaster.texture = load("res://4caster Art/disasters/rain.png")
			elif count < 20:
				$Disaster.texture = load("res://4caster Art/disasters/lightning.png")
			elif count < 30:
				$Disaster.texture = load("res://4caster Art/disasters/snow.png")
			else:
				count = 0
	$Disaster2.texture = $Disaster.texture 
	$Disaster3.texture = $Disaster.texture 
	$Disaster4.texture = $Disaster.texture 
