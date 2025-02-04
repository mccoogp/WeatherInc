extends Node2D





@export var districts: Array[Node2D] = []
var totalpop = 0
var foodprod = 0
var phase = 1
var food = 10000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

var zoom = -1
var cameracenter =  Vector2(420, 297)
var camerazoom = 1

func popularity_down(district):
	'''
	removes 5-15% of your popularity in the given inputed district number
	'''
	districts[district].popularity *= randf_range(8.5,9.5)/10
	

func popularity_up(district):
	'''
	gains 5-15% of the population you are not popular amoung in the given inputed district number
	'''
	districts[district].popularity += (100-districts[district].popularity)* randf_range(0.5,1.5)/10
	
	
func _input(event):
	'''
	Actives everytime an input is made
	'''
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_SPACE):
			'''
			Goes to next phase of game when space is pressed
			'''
			phase += 1
			
			if phase == 5:
				'''
				phase 5 is the resolving backround info phase so population is reset to 0 and recaluclated
				'''
				totalpop = 0
				foodprod = 0
				for district in 9:
					totalpop += districts[district].population
					#the .population thing is accessing the population varible from district.gd
					if "food" in districts[district].production:
						#checks wether the district produces food
						foodprod = districts[district].productivity * 3000
				food += foodprod - totalpop
				phase = 1
			$Label.text = "Phase = " + str(phase)
	if phase == 3:
		if zoom == -1:
			#zoom = -1 means its not zoomed in
			for district in 9:
				if districts[district].clicked == true:
					zoom = district
					cameracenter = districts[district].center
					camerazoom = districts[district].zoom
					districts[district].clicked = false
		else:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
					if districts[zoom].clicked == false:
						cameracenter =  Vector2(420, 297)
						camerazoom = 1
						zoom = -1
						for district in 9:
							if districts[district].clicked == true:
								districts[district].clicked = false
				
func _process(delta: float) -> void:
	
	#print($Camera2D.zoom, $Camera2D.position)
	#print(camerazoom, cameracenter)
	$Camera2D.position.x += (cameracenter.x - $Camera2D.position.x)/20
	$Camera2D.position.y += (cameracenter.y - $Camera2D.position.y)/20
	$Camera2D.zoom.x += (camerazoom - $Camera2D.zoom.x)/40
	$Camera2D.zoom.y += (camerazoom - $Camera2D.zoom.y)/40
	
	$Label2.position = $Camera2D.position + Vector2(256, -290)/$Camera2D.zoom.y
	$Label2.scale = Vector2(1,1)/$Camera2D.zoom.x
	
	
	if zoom == -1:
		$DistrictMenu.visible = false
		$DistrictMenu.position = $Camera2D.position + Vector2(-479, -234)/$Camera2D.zoom.x   
		$DistrictMenu.scale = Vector2(0.167,0.167)/$Camera2D.zoom.x
	else:
		$DistrictMenu.visible = true
		$DistrictMenu.position = $Camera2D.position + Vector2(-479, -234)/$Camera2D.zoom.x   
		$DistrictMenu.scale = Vector2(0.167,0.167)/$Camera2D.zoom.x
