extends Node2D





@export var districts: Array[Node2D] = []
var totalpop = 0
var foodprod = 0
var phase = 1
var food = 10000
var money = 150000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label4.text = "Food = " + str(food) + "\nMoney = " + str(money)
	pass


var zoom = -1
var cameracenter =  Vector2(420, 297)
var camerazoom = 1

var posprod = ["none", "grain", "meat", "fish", "factory", "oil", "research"]
var curprod = 0
var checkprod = false
var factories = 0


var frame = 0


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
	
	
	if frame == 0:
		if event is InputEventKey and event.pressed:
			if Input.is_key_pressed(KEY_SPACE) and zoom == -1:
				
				phase += 1
				
				if phase == 6:
					totalpop = 0
					foodprod = 0
					for district in 9:
						totalpop += districts[district].population
						if "grain" in districts[district].product or "meat" in districts[district].product or "fish" in districts[district].product:
							foodprod += 3 * districts[district].productivity * districts[district].population
					food += foodprod - totalpop
					phase = 1
				$Label.text = "Phase = " + str(phase)
				$Label4.text = "Food = " + str(food) + "\nMoney = " + str(money)
		if phase == 3:
			if zoom == -1:
				curprod = 0
				for district in 9:
					if districts[district].clicked == true:
						zoom = district
						cameracenter = districts[district].center
						camerazoom = districts[district].zoom
						districts[district].clicked = false
			else:
				if event is InputEventKey and event.pressed:
					if Input.is_key_pressed(KEY_RIGHT):
						curprod += 1
					if Input.is_key_pressed(KEY_LEFT):
						curprod -= 1
					if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT):
						if curprod == len(posprod):
							curprod = 0
						if curprod == 0:
							$DistrictMenu/Industry/Sprite2D.texture = null
							$DistrictMenu/Industry/Label.text = "Industry:
							None"
							$DistrictMenu/Popularity.extra = 0
							$DistrictMenu/Industry/Label2.text = ""
						else:
							$DistrictMenu/Industry/Sprite2D.texture = load("res://icons/" + posprod[curprod] + ".png")
							$DistrictMenu/Industry/Label.text = "Industry:
								" + posprod[curprod]
							if posprod[curprod] in districts[zoom].product:
								$DistrictMenu/Industry/Label.text += "
								Press x to remove"
								$DistrictMenu/Popularity.extra = 1
								$DistrictMenu/Industry/Label2.text = ""
							else:
								if len(districts[zoom].product) == 0:
									$DistrictMenu/Industry/Label.text += "
									Press enter to confirm"
									$DistrictMenu/Popularity.extra = 1
								else:
									$DistrictMenu/Industry/Label.text += "
									No available space"
									$DistrictMenu/Popularity.extra = 1
								if posprod[curprod] == "fish":
									$DistrictMenu/Industry/Label.text += "
									Requires: Water access"
									if districts[zoom].water == true:
										$DistrictMenu/Industry/Label2.text = "Reuirements met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$DistrictMenu/Industry/Label2.text = "Reuirements not met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.RED
									$DistrictMenu/Popularity.extra += 2
								if posprod[curprod] == "factory":
									$DistrictMenu/Industry/Label.text += "
									Cost: $100,000"
									$DistrictMenu/Popularity.extra += 2
									if money >= 100000:
										$DistrictMenu/Industry/Label2.text = "Reuirements met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$DistrictMenu/Industry/Label2.text = "Reuirements not met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.RED
								if posprod[curprod] == "oil":
									$DistrictMenu/Industry/Label.text += "
									Requires: 1 factory"
									$DistrictMenu/Popularity.extra += 2
									if factories >= 1:
										$DistrictMenu/Industry/Label2.text = "Reuirements met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$DistrictMenu/Industry/Label2.text = "Reuirements not met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.RED
								if posprod[curprod] == "research":
									$DistrictMenu/Industry/Label.text += "
									Cost: $500,000
									Requires 1 factory"
									if money >= 500000 and factories >= 1:
										$DistrictMenu/Industry/Label2.text = "Reuirements met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$DistrictMenu/Industry/Label2.text = "Reuirements not met"
										$DistrictMenu/Industry/Label2.get_label_settings().font_color = Color.RED
									$DistrictMenu/Popularity.extra += 3
					if curprod > 0:
						if Input.is_key_pressed(KEY_X):
							if posprod[curprod] in districts[zoom].product:
								if checkprod == false:
									$DistrictMenu/Industry/Label.text += "
									Press X to confirm"
									checkprod = true
									$DistrictMenu/Popularity.extra += 1
								else:
									districts[zoom].product.erase(posprod[curprod])
									checkprod = false
									$DistrictMenu/Industry/Label.text = "Industry:
									" + posprod[curprod]
									if len(districts[zoom].product) == 0:
										$DistrictMenu/Industry/Label.text += "
										Press enter to confirm"
										$DistrictMenu/Popularity.extra = 1
									else:
										$DistrictMenu/Industry/Label.text += "
										No available space"
										$DistrictMenu/Popularity.extra = 1
									if posprod[curprod] == "factory":
										$DistrictMenu/Industry/Label.text += "
										Cost: $100,000"
										$DistrictMenu/Popularity.extra += 1
									if posprod[curprod] == "oil":
										$DistrictMenu/Industry/Label.text += "
										Requires: 1 factory"
										$DistrictMenu/Popularity.extra += 1
									if posprod[curprod] == "research":
										$DistrictMenu/Industry/Label.text += "
										Cost: $500,000
										Requires 1 factory"
										$DistrictMenu/Popularity.extra += 2
						if Input.is_key_pressed(KEY_ENTER):
							if len(districts[zoom].product) == 0:
								districts[zoom].product.append(posprod[curprod])
								$DistrictMenu/Industry/Label.text = "Industry:
								" + posprod[curprod]
								$DistrictMenu/Industry/Label.text += "
								Press x to remove"
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
						if districts[zoom].clicked == false and $DistrictMenu.anyclicked == false:
							cameracenter =  Vector2(420, 297)
							camerazoom = 1
							zoom = -1
							for district in 9:
								if districts[district].clicked == true:
									districts[district].clicked = false
						if $DistrictMenu.industry_clicked == true:
							frame = 1
							$Camera2D.position = Vector2(1920, 297)
							$Camera2D.zoom = Vector2(1,1)
							
	if frame == 1:
		if event is InputEventKey and event.pressed:
			if Input.is_key_pressed(KEY_BACKSPACE):
				frame = 0
				$Camera2D.position = Vector2(420, 297)
				$Camera2D.zoom = Vector2(1,1)
				$DistrictMenu.industry_clicked = false

func _process(delta: float) -> void:
	if frame == 0:
		#print($Camera2D.zoom, $Camera2D.position)
		#print(camerazoom, cameracenter)
		$Camera2D.position.x += (cameracenter.x - $Camera2D.position.x)/15
		$Camera2D.position.y += (cameracenter.y - $Camera2D.position.y)/15
		$Camera2D.zoom.x += (camerazoom - $Camera2D.zoom.x)/30
		$Camera2D.zoom.y += (camerazoom - $Camera2D.zoom.y)/30
		
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
		
	
