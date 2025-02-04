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


func _input(event):
	
	if event is InputEventKey and event.pressed:
		if Input.is_key_pressed(KEY_SPACE) and zoom == -1:
			
			phase += 1
			
			if phase == 5:
				totalpop = 0
				foodprod = 0
				for district in 9:
					totalpop += districts[district].population
					if "food" in districts[district].production:
						foodprod += 3000
				food += foodprod - totalpop
				phase = 1
			$Label.text = "Phase = " + str(phase)
	if phase == 3:
		if zoom == -1:
			for district in 9:
				if districts[district].clicked == true:
					zoom = district
					cameracenter = districts[district].center
					camerazoom = districts[district].zoom
					districts[district].clicked = false
		else:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
					if districts[zoom].clicked == false and $DistrictMenu.anyclicked == false:
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
		$DistrictMenu.position = $Camera2D.position + Vector2(-409, -184)/$Camera2D.zoom.x   
		$DistrictMenu.scale = Vector2(0.15,0.15)/$Camera2D.zoom.x
	else:
		$DistrictMenu.visible = true
		$DistrictMenu.position = $Camera2D.position + Vector2(-409, -184)/$Camera2D.zoom.x   
		$DistrictMenu.scale = Vector2(0.15,0.15)/$Camera2D.zoom.x
