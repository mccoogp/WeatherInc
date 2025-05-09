extends Node2D





@export var districts: Array[Node2D] = []
var totalpop = 0
var foodprod = 0

var food_modifier = 1.0
var env_modifier = 0.0
var ind_modifier = 1.0
var tech_modifier = 1.0

var phase = 3
var food = 10000
var money = 50000
var temp = 60
var year = 1
var factories = 0
var energyprod = 0
var research = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TopBar/Variables.text = "  = " + str(food) + "\n   = " + str(money)
	$TopBar/Variables2.text = "  = " + str(factories) + "\n   = " + str(energyprod)

	
var adjacents = {0: [1,4,6], 1: [0,4,2], 2: [1,3,4,5], 3: [2,5,10], 4: [0,1,2,5,6,7,8], 5: [2,3,4,8,9,10], 6: [0,4,7,11], 7: [4,6,8,11,12,13], 8: [4,5,7,9,13,14], 9: [5,8,10,14], 10: [3,5,9,14,15], 11:[6,7,12], 12: [11,7,13], 13: [12,7,8,14,15], 14: [8,9,10,13,15], 15: [10,13,14]}

var zoom = -1

var defaultcenter = Vector2(420, 250)
var defaultzoom = 0.9
var cameracenter =  defaultcenter
var camerazoom = defaultzoom

var frame1pos = Vector2(9200, 250)

var spaceclicked = false

var posprod = ["none", "grain", "meat", "fish", "factory", "oil", "research"]
var curprod = 0
var checkprod = false

var activatefact = false
var activateresearch = false

var previousvis = [false, false, false]
var frame = 0

func ElectResults(random = 0):
	var totalpopulation = 0
	var populations = []

	for district in 16:
		totalpopulation += districts[district].population
		populations.append( [districts[district].population, district] )
		districts[district].votes = 2

	
	
	for i in 504:
		populations.sort()
		districts[populations[-1][1]].votes += 1
		populations[-1][0] -= totalpopulation/504
		populations.sort()
	
	var district_nodes = [$District, $District2, $District3, $District4,
	$District5, $District6, $District7, $District8,
	$District9, $District10, $District11, $District12,
	$District13, $District14, $District15, $District16]


	var totalvotes = 0
	
	for district in 16:
		if districts[district].popularity + randf_range(-1,1) * random > 50:
			var color = Color(0.2, 0.8, 0.2)
			var tween = create_tween()
			tween.tween_property(districts[district], "modulate", color, 0.3)
		else:
			var color = Color(0.5, 0.2, 0.6)
			var tween = create_tween()
			tween.tween_property(districts[district], "modulate", color, 0.3)
		totalvotes += districts[district].votes
	return totalvotes
		

func GenPopularity(random = 0):
	var totalpopulation = 0
	var popularity = 0
	for district in 16:
		totalpopulation += districts[district].population
		popularity += districts[district].population * (districts[district].popularity + (randf_range(-1,1) * random))
	return popularity/totalpopulation
	
func ResetColor():
	var district_nodes = [$District, $District2, $District3, $District4,
	$District5, $District6, $District7, $District8,
	$District9, $District10, $District11, $District12,
	$District13, $District14, $District15, $District16]


	for district in 16:
		var tween = create_tween()
		tween.tween_property(district_nodes[district], "modulate", Color(1, 1, 1, 1), 1.0)



func popularity_down(district):
	'''
	removes 5-15% of your popularity in the given inputed district number
	'''
	district.popularity *= randf_range(8.5,9.5)/10
	
func popularity_up(district):
	'''
	gains 5-15% of the population you are not popular amoung in the given inputed district number
	'''
	district.popularity += (100-districts[district].popularity)* randf_range(0.5,1.5)/10
	
func disaster(temp):
	'''
	creates a random number and if the current temp is higher then a random disaster is triggered
	'''
	var disasters = ["tornado", "drought", "rain", "fire", "volcano", "disease"]
	var ran = randi_range(50,300)
	if ran < temp and randf() <= 1.0 - env_modifier:
		return disasters[randi_range(0,len(disasters)-1)]
	else:
		return('none')
	


	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
				frame = 2
				$Camera2D.position = Vector2(-1420, 297)
				$Camera2D.zoom = Vector2(1,1)
				previousvis = [$CanvasLayer.visible, $"Popularity bar".visible, $Start.visible]
				$CanvasLayer.visible = false
				$"Popularity bar".visible =  false
				$Start.visible = false
	
	if Input.is_key_pressed(KEY_SPACE):
		spaceclicked = true
	
	if frame == 0:
		if phase == 2:
			if zoom == -1:
				curprod = 0
				for district in 16:
					if districts[district].clicked == true and $CanvasLayer/News.skillclicked == false:
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
						if curprod == -1:
							curprod = len(posprod)
						if curprod == len(posprod):
							curprod = 0
						
						if curprod == 0:
							$TopBar/LeftMenu/Industry/Sprite2D.texture = null
							$TopBar/LeftMenu/Industry/Label.text = "Industry:
							None"
							$TopBar/LeftMenu/Industry/Label3.text = ""
							$TopBar/LeftMenu.extras[0] = 0
							$TopBar/LeftMenu/Industry/Label2.text = ""
							$DistrictMenu/Popularity/Tax_Label.text = "Tax: " + str(districts[zoom].tax) + "%"
						else:
							$TopBar/LeftMenu/Industry/Sprite2D.texture = load("res://icons/" + posprod[curprod] + ".png")
							$TopBar/LeftMenu/Industry/Label.text = "Industry:
								" + posprod[curprod]
							$TopBar/LeftMenu/Industry/Label3.text = ""
							$TopBar/LeftMenu.extras[0] = 0
							$DistrictMenu/Popularity.extra
							if posprod[curprod] in districts[zoom].product:
								$TopBar/LeftMenu/Industry/Label3.text += "
								Press x to remove"
								$TopBar/LeftMenu.extras[0] += 1
								$TopBar/LeftMenu/Industry/Label2.text = ""
							else:
								if len(districts[zoom].product) == 0:
									$TopBar/LeftMenu/Industry/Label3.text += "
									Press enter to confirm"
									$TopBar/LeftMenu.extras[0] += 1
								else:
									$TopBar/LeftMenu/Industry/Label3.text += "
									No available space"
									$TopBar/LeftMenu.extras[0] += 1
								if posprod[curprod] == "fish":
									$TopBar/LeftMenu/Industry/Label3.text += "
									Requires: Water access"
									if districts[zoom].water == true:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements not met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.RED
									$TopBar/LeftMenu.extras[0] += 2
								elif posprod[curprod] == "factory":
									$TopBar/LeftMenu/Industry/Label3.text += "
									Cost: $100,000"
									if money >= 100000:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements not met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.RED
									$TopBar/LeftMenu.extras[0] += 2
								elif posprod[curprod] == "oil":
									$TopBar/LeftMenu/Industry/Label3.text += "
									Requires: 1 factory"
									$TopBar/LeftMenu.extras[0] += 2
									if factories >= 1:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements not met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.RED
								elif posprod[curprod] == "research":
									$TopBar/LeftMenu/Industry/Label3.text += "
									Cost: $500,000
									Requires 1 factory"
									if money >= 500000 and factories >= 1:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.GREEN
									else:
										$TopBar/LeftMenu/Industry/Label2.text = "Reuirements not met"
										$TopBar/LeftMenu/Industry/Label2.get_label_settings().font_color = Color.RED
									$TopBar/LeftMenu.extras[0] += 3
								else:
									$TopBar/LeftMenu/Industry/Label2.text = ""
					if Input.is_key_pressed(KEY_UP):
						districts[zoom].newtax += 0.5
						$DistrictMenu/Popularity/Tax_Label.text = "Tax: " + str(districts[zoom].newtax) + "%"
					if Input.is_key_pressed(KEY_DOWN):
						districts[zoom].newtax -= 0.5
						if districts[zoom].newtax < 0:
							districts[zoom].newtax = 0

						$DistrictMenu/Popularity/Tax_Label.text = "Tax: " + str(districts[zoom].newtax) + "%"		
					if curprod > 0:
						if Input.is_key_pressed(KEY_X):
							if posprod[curprod] in districts[zoom].product:
								if checkprod == false:
									$TopBar/LeftMenu/Industry/Label3.text += "
									Press X to confirm."
									checkprod = true
									$TopBar/LeftMenu.extras[0] += 1
								else:
									districts[zoom].popularity *= randf_range(7.5,9.5)/10
									districts[zoom].product.erase(posprod[curprod])
									checkprod = false
									$TopBar/LeftMenu/Industry/Label.text = "Industry:
									" + posprod[curprod]
									if len(districts[zoom].product) == 0:
										$TopBar/LeftMenu/Industry/Label3.text += "
										Press enter to confirm"
										$TopBar/LeftMenu.extras[0] += 1
									else:
										$TopBar/LeftMenu/Industry/Label3.text += "
										No available space"
										$TopBar/LeftMenu.extras[0] += 1
									if posprod[curprod] == "factory":
										$TopBar/LeftMenu/Industry/Label3.text += "
										Cost: $100,000"
										$TopBar/LeftMenu.extras[0] += 1

									if posprod[curprod] == "oil":
										$TopBar/LeftMenu/Industry/Label3.text += "
										Requires: 1 factory"
										$TopBar/LeftMenu.extras[0] += 1
									if posprod[curprod] == "research":
										$TopBar/LeftMenu/Industry/Label3.text += "
										Cost: $500,000
										Requires: 1 factory"
										$TopBar/LeftMenu.extras[0] += 2
									
						if Input.is_key_pressed(KEY_ENTER):
							if len(districts[zoom].product) == 0:
								var changed = false
								
								if posprod[curprod] == "grain":
									changed = true
									districts[zoom].popularity += (100-districts[zoom].popularity)* randf_range(0,1)/10
								if posprod[curprod] == "meat":
									changed = true
									districts[zoom].setup = 0
									districts[zoom].popularity += (100-districts[zoom].popularity)* randf_range(0.5, 1.5)/10
								if posprod[curprod] == "fish" and districts[zoom].water == true:
									changed = true
									districts[zoom].popularity *= randf_range(8.5,9.5)/10
								if posprod[curprod] == "factory" and money >= 100000:
									districts[zoom].setup = 0
									money -= 100000
									changed = true
									districts[zoom].popularity += (100-districts[zoom].popularity)* randf_range(1.5,3)/10
									for dist in adjacents[zoom]:
										districts[dist].popularity *=  randf_range(8,10)/10
								if posprod[curprod] == "oil" and factories > 0:
									districts[zoom].setup = 0
									factories -= 1
									changed = true
								if posprod[curprod] == "research" and factories > 0 and money >= 500000:
									districts[zoom].setup = 0
									factories -= 1
									money -= 500000
									changed = true
								
								if changed == true:
									districts[zoom].product.append(posprod[curprod])
									$TopBar/LeftMenu/Industry/Label.text = "Industry:
									" + posprod[curprod]
									$TopBar/LeftMenu/Industry/Label3.text = "
									Press x to remove"
									$TopBar/LeftMenu.extras[0] = 1
								
				if event is InputEventKey and event.pressed:
					if Input.is_key_pressed(KEY_BACKSPACE):
						cameracenter =  defaultcenter
						camerazoom = defaultzoom
						zoom = -1
					
					if Input.is_key_pressed(KEY_TAB):
						cameracenter =  defaultcenter
						camerazoom = defaultzoom
						zoom = -1
						
				
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
						if districts[zoom].clicked == false and $DistrictMenu.anyclicked == false:
							cameracenter =  defaultcenter
							camerazoom = defaultzoom
							zoom = -1
							for district in 16:
								if districts[district].clicked == true:
									districts[district].clicked = false
							$TopBar/LeftMenu/Industry/Sprite2D.texture = null
							$TopBar/LeftMenu/Industry/Label.text = "Industry:
							None"
							$TopBar/LeftMenu/Industry/Label3.text = ""
							$DistrictMenu/Popularity.extra = 0
							$TopBar/LeftMenu/Industry/Label2.text = ""
							
						if $DistrictMenu.industry_clicked == true:
							frame = 1
							$Camera2D.position = frame1pos
							$Camera2D.zoom = Vector2(1,1)
							$"Popularity bar".visible = false
							$CanvasLayer.visible = false
							
		if phase == 2 or phase == 3:
			if zoom == -1:
				if event is InputEventKey and event.pressed:
					if Input.is_key_pressed(KEY_W):
						defaultcenter.y -= 30/defaultzoom
						$Camera2D.position.y -= 30/defaultzoom
					if Input.is_key_pressed(KEY_S):
						defaultcenter.y += 30/defaultzoom
						$Camera2D.position.y += 30/defaultzoom
					if Input.is_key_pressed(KEY_A):
						defaultcenter.x -= 30/defaultzoom
						$Camera2D.position.x -= 30/defaultzoom
					if Input.is_key_pressed(KEY_D):
						defaultcenter.x += 30/defaultzoom
						$Camera2D.position.x += 30/defaultzoom
					if Input.is_key_pressed(KEY_EQUAL):
						defaultzoom += 0.1*defaultzoom
						$Camera2D.zoom = Vector2(defaultzoom, defaultzoom)
					if Input.is_key_pressed(KEY_MINUS):
						defaultzoom -= 0.1*defaultzoom
						$Camera2D.zoom = Vector2(defaultzoom, defaultzoom)
	if frame == 1:
		if event is InputEventKey and event.pressed:
			if Input.is_key_pressed(KEY_BACKSPACE):
				frame = 0
				$Camera2D.position = defaultcenter
				$Camera2D.zoom = Vector2(defaultzoom, defaultzoom)
				$DistrictMenu.industry_clicked = false
				$CanvasLayer.visible = true
				$"Popularity bar".visible = true
	if frame == 2:
		if Input.is_key_pressed(KEY_BACKSPACE):
				frame = 0
				$Camera2D.position = defaultcenter
				$Camera2D.zoom = Vector2(defaultzoom, defaultzoom)
				$CanvasLayer.visible = previousvis[0]
				$"Popularity bar".visible =  previousvis[1]
				$Start.visible = previousvis[2]

func _process(delta: float) -> void:
	$TopBar/Variables.text = "  = " + str(food) + "\n  = " + str(money)
	$TopBar/Variables2.text = "   = " + str(factories) + "\n   = " + str(energyprod)
	if activateresearch:
				$TopBar/Variables3.text = "  = " + str(totalpop) + "\n  = " + str(research)
	if $CanvasLayer/News.skillclicked:
		$CanvasLayer/News.skillclicked = false
		if $CanvasLayer/News/SkillTree.visible == false:
			frame = 0
			$CanvasLayer/ColorRect.visible = $CanvasLayer/News/SkillTree.visible

	if $CanvasLayer/News/SkillTree.visible == true:
		$CanvasLayer/ColorRect.visible = $CanvasLayer/News/SkillTree.visible
		frame = 3
	if frame == 0:
		#print($Camera2D.zoom, $Camera2D.position)
		#print(camerazoom, cameracenter)
		
		$Camera2D.position.x += (cameracenter.x - $Camera2D.position.x)/15
		$Camera2D.position.y += (cameracenter.y - $Camera2D.position.y)/15
		$Camera2D.zoom.x += (camerazoom - $Camera2D.zoom.x)/30
		$Camera2D.zoom.y += (camerazoom - $Camera2D.zoom.y)/30
		
		#$Label4.position = $Camera2D.position + Vector2(256, -290)/$Camera2D.zoom.y
		#$Label4.scale = Vector2(1,1)/$Camera2D.zoom.x
		
		
		if zoom == -1:
			$DistrictMenu.visible = false
			$TopBar/LeftMenu.visible = false
			$DistrictMenu.position = $Camera2D.position + Vector2(-479, -184)/$Camera2D.zoom.x   
			$DistrictMenu.scale = Vector2(0.15,0.15)/$Camera2D.zoom.x
			cameracenter = defaultcenter
			camerazoom = defaultzoom
		else:
			$DistrictMenu.visible = true
			$TopBar/LeftMenu.visible = true
			$DistrictMenu.position = $Camera2D.position + Vector2(-479, -184)/$Camera2D.zoom.x   
			$DistrictMenu.scale = Vector2(0.15,0.15)/$Camera2D.zoom.x
			$DistrictMenu/Popularity/Tax_Label.text = "Tax: " + str(districts[zoom].newtax) + "%"
			$TopBar/LeftMenu/DistrictPopulation/Label.text = str(districts[zoom].population)
			var estimate = districts[zoom].popularity
			$TopBar/LeftMenu/DistrictPopularity/ColorRect.size.x = estimate
			$TopBar/LeftMenu/DistrictPopularity/ColorRect2.size.x = 100 - estimate
			$TopBar/LeftMenu/DistrictPopularity/ColorRect2.position.x = 49 + 2*estimate
			$TopBar/LeftMenu/Label.text = $DistrictMenu/Popularity/Tax_Label.text

			
	

	if $CanvasLayer/News.clicked == true or spaceclicked == true:
		spaceclicked = false
		$CanvasLayer/News.clicked = false
		phase += 1
		if phase == 2:
			$CanvasLayer/News.hide = true
			if year % 4 == 0:
				$CanvasLayer/News.text = "Election"
			else:
				$CanvasLayer/News.text = "Advance"
			if activateresearch:
				$CanvasLayer/News/SkillTreeToggle.visible = true
			
		if phase == 3:
			cameracenter =  defaultcenter
			camerazoom = defaultzoom
			zoom = -1
			if year % 4 == 0:
				print(ElectResults(5))
				
				
			else:
				phase += 1
			$CanvasLayer/News.text = "Advance"
		if phase == 4:
			ResetColor()
			var skill_tree_script = get_node('CanvasLayer/News/SkillTree')
			food_modifier = 1.0 + skill_tree_script.levels[0] * 0.1
			env_modifier = skill_tree_script.levels[2] * 0.1
			ind_modifier = 1.0 + skill_tree_script.levels[1] * 0.1
			tech_modifier = 1.0 + skill_tree_script.levels[3] * 0.1
			
			year += 1
			factories = 0
			research = 0
			totalpop = 0
			foodprod = 0
			
			#disasters
			for district in 16:
				var thing = disaster(temp)
				if thing == "none":
					districts[district].disaster = []
				elif thing == "tornado":
					districts[district].disaster = ["tornado"]
					districts[district].product = []
					districts[district].population *= 0.75
				
				elif thing == "drought":
					if districts[district].water:
						pass
					else:
						districts[district].disaster = ["drought"]
						if "meat" in districts[district].product:
							districts[district].product = []
							districts[district].population *= 0.75
						elif "grain" in districts[district].product:
							districts[district].product = []
							districts[district].population *= 0.75
						else:
							districts[district].population *= 0.75
				
				elif thing == "rain":
					if not districts[district].water:
						pass
					else:
						districts[district].disaster = ["rain"]
						districts[district].product = []
						districts[district].population *= 0.75
				
				elif thing == "fire":
					districts[district].disaster = ["fire"]
					if districts[district].water:
						districts[district].population *= 0.90
					else:
						districts[district].product = []
						districts[district].population *= 0.75
				
				elif thing == "volcano":
					districts[district].disaster = ["volcano"]
					districts[district].population *= 0.90
					var moving = districts[district].population * randf_range(20,60)/100
					var movement = int(moving / 5)
					for dist in adjacents[district]:
						districts[dist].population += movement
						districts[district].population -= movement
						
				elif thing == "disease":
					districts[district].disaster = ["disease"]
					if "meat" in districts[district].product:
							districts[district].product = []
							districts[district].population *= 0.65
					else:
						districts[district].population *= 0.75
					
							
			
			#taxes
			for district in 16:
				if districts[district].newtax > 100:
					districts[district].newtax = 100
				if districts[district].tax < districts[district].newtax:
					for a in range(int((districts[district].newtax-districts[district].tax)/0.5)):
						popularity_down(districts[district])
				if districts[district].tax > districts[district].newtax:
					for a in range(int((districts[district].tax-districts[district].newtax)/0.5)):
						popularity_up(districts[district])		
				districts[district].tax = districts[district].newtax
			
			#production	
			for district in 16:
				if "oil" in districts[district].product:
					energyprod +=  districts[district].productivity * districts[district].population * districts[district].setup * ind_modifier
				
			for district in 16:
				totalpop += districts[district].population
				if "grain" in districts[district].product:
					var district_foodprod = 3 * districts[district].productivity * districts[district].population
					foodprod += district_foodprod
					money += district_foodprod * districts[district].tax
				if "meat" in districts[district].product or "fish" in districts[district].product:
					var district_foodprod = 5 * districts[district].productivity * districts[district].population * districts[district].setup
					foodprod += district_foodprod
					money += district_foodprod * districts[district].tax
					districts[district].setup = 1
				if "factory" in districts[district].product:
					factories += 1
					activatefact = true
					districts[district].setup = 1
				if "oil" in districts[district].product:
					districts[district].setup = 1
				if "research" in districts[district].product:
					districts[district].setup = 1
					research += 1
					activateresearch = true
			
			
			food += foodprod * food_modifier
			if food >= totalpop * 1.2:
				food -= totalpop *1.2
				for district in 16:
					districts[district].population *= randf_range(100,110)/100
					districts[district].popularity += (100-districts[district].popularity)* randf_range(0,1)/10
			elif food >= totalpop:
				food -= totalpop
			else:
				for district in 16:
					districts[district].population *= food/totalpop
				food = 0
			food /= 2
			food = floor(food)
			
			$CanvasLayer/News/SkillTreeToggle.visible = false
			totalpop = 0
			for district in 16:
				for dist in adjacents[district]:
					var moving = districts[district].population * randf_range(0,5)/100
					districts[dist].population += moving
					districts[district].population -= moving
			for district in 16:
				districts[district].population = float(int(districts[district].population))
				totalpop += districts[district].population
			$TopBar/Variables3.text = "  = " + str(totalpop) 
			
			var estimate = GenPopularity(10)
			$"Popularity bar/ColorRect".size.x = estimate
			$"Popularity bar/ColorRect2".size.x = 100 - estimate
			$"Popularity bar/ColorRect2".position.x = 49 + 2*estimate
			
			
			$TopBar/Variables.visible = true
			$TopBar/TopMenu.visible = true
			$TopBar/Variables.visible = true
			$TopBar/Variables2.visible = true
			$TopBar/Variables3.visible = true
			#$Label4.visible = true
			$"Popularity bar".visible = true
			$Start.visible = false
			$CanvasLayer/News.hide = false
			$CanvasLayer/News.text = "Next"
			temp += 1
			phase = 1
			$TopBar/Variables3/Research
			if activateresearch:
				$TopBar/Variables3/Research.visible = true
				$TopBar/Variables3.text = "  = " + str(totalpop) + "\n  = " + str(research)
			
			#news stuff
			$CanvasLayer/News/ScrollContainer/TextureRect/VBoxContainer/Production_title/Temp.text = "Average surface\ntempurature: " + str(temp) + "°F"
			if foodprod >= totalpop:
				$CanvasLayer/News/ScrollContainer/TextureRect/VBoxContainer/Production_title/Food_calc.text = str(foodprod) + "\n-" + str(totalpop) + "\n________\n+" + str(foodprod - totalpop)
			else:
				$CanvasLayer/News/ScrollContainer/TextureRect/VBoxContainer/Production_title/Food_calc.text = str(foodprod) + "\n-" + str(totalpop) + "\n________\n-" + str(foodprod - totalpop)
			$CanvasLayer/News.show()
