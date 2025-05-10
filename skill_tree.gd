extends Control
var json_data
var skill_name_label 
var skill_description_label
var skill_box
var btn_active
var levels = [0, 0, 0, 0, 0]
var skill_dict = {
	'ag':0,
	'in':1,
	'en':2,
	'te':3
}
var current_skill

func _ready() -> void:
	const FILENAME = 'res://data/skill_tree.json'
	json_data = load_json_data(FILENAME)
	print(json_data)
	
	skill_name_label = get_node('Skill Descriptions/Name')
	skill_description_label = get_node('Skill Descriptions/Description')
	skill_box = get_node('Skill Descriptions')

func load_json_data(path : String):
	const filename = 'res://data/skill_tree.json'
	var json_text = FileAccess.get_file_as_string(filename)
	var json_dict = JSON.parse_string(json_text).get('Skills')
	return json_dict

func load_skill_description(name) -> void:
	var skill_name = json_data[name]['name']
	var skill_description = json_data[name]['description']
	
	var skill_level = int(name[-1])
	var category = skill_dict[name.split('_')[0]]
	
	if levels[category] >= skill_level:
		skill_description = "Already bought"
	elif levels[category] + 1 < skill_level:
		skill_description = "Must buy the previous level first."
	else:
		skill_description = json_data[name]['description']
		
	if name == btn_active:
		skill_box.visible = !skill_box.visible
	else:
		skill_box.visible = true
	
	if skill_box.visible:
		current_skill = name
		
	btn_active = name
	
	if str(name).substr(0, 2) == "ag":
		skill_name_label.text = "Agriculture"
	if str(name).substr(0, 2) == "in":
		skill_name_label.text = "Industrial"
	if str(name).substr(0, 2) == "en":
		skill_name_label.text = "Environmental"
	if str(name).substr(0, 2) == "te":
		skill_name_label.text = "Technology"
	
	skill_name_label.text += " " + str(name).substr(3, 1)
	skill_description_label.text = skill_description

func buy_skill(name) -> void:
	var level = int(name[-1])
	var category = skill_dict[name.split('_')[0]]
	
	var energy_cost = 1000 * pow(level, 2)
	var research_cost = level

	if levels[category] + 1 > level:
		print("Already bought")
	elif levels[category] + 1 < level:
		print("Need prerequisite upgrade")
	else:
		var world = find_parent('world')
		var news = get_node("../ScrollContainer")
		world.research_text += name + " "
		if world.energyprod >= energy_cost and world.research >= research_cost:
			levels[category] += 1
			world.energyprod -= energy_cost
			world.research -= research_cost
			print("Bought", name)
			print("Cost: Energy =", energy_cost, "| Research =", research_cost)
			if name.begins_with("en_"):
				find_parent("world").temp -= 5.0
			load_skill_description(name) # Update description immediately after purchase
		else:
			print("Not enough resources.")
			print("Required -> Energy:", energy_cost, "| Research:", research_cost)
			print("You have -> Energy:", world.energyprod, "| Research:", world.research)

func _on_buy_button_pressed() -> void:
	if skill_box.visible:
		buy_skill(current_skill)

func _on_ag_1_pressed() -> void:
	print('ag_1 pressed')
	load_skill_description('ag_1')

func _on_ag_2_pressed() -> void:
	print('ag_2 pressed')
	load_skill_description('ag_2')

func _on_ag_3_pressed() -> void:
	print('ag_3 pressed')
	load_skill_description('ag_3')
	
func _on_ag_4_pressed() -> void:
	print('ag_4 pressed')
	load_skill_description('ag_4')
	
func _on_ag_5_pressed() -> void:
	print('ag_5 pressed')
	load_skill_description('ag_5')

func _on_in_1_pressed() -> void:
	print('in_1 pressed')
	load_skill_description('in_1')
	
func _on_in_2_pressed() -> void:
	print('in_2 pressed')
	load_skill_description('in_2')
	
func _on_in_3_pressed() -> void:
	print('in_3 pressed')
	load_skill_description('in_3')
	
func _on_in_4_pressed() -> void:
	print('in_4 pressed')
	load_skill_description('in_4')
	
func _on_in_5_pressed() -> void:
	print('in_5 pressed')
	load_skill_description('in_5')
	
func _on_en_1_pressed() -> void:
	print('en_1 pressed')
	load_skill_description('en_1')
	
func _on_en_2_pressed() -> void:
	print('en_2 pressed')
	load_skill_description('en_2')
	
func _on_en_3_pressed() -> void:
	print('en_3 pressed')
	load_skill_description('en_3')
	
func _on_en_4_pressed() -> void:
	print('en_4 pressed')
	load_skill_description('en_4')
	
func _on_en_5_pressed() -> void:
	print('en_5 pressed')
	load_skill_description('en_5')

func _on_te_1_pressed() -> void:
	print('te_1 pressed')
	load_skill_description('te_1')
	
func _on_te_2_pressed() -> void:
	print('te_2 pressed')
	load_skill_description('te_2')
	
func _on_te_3_pressed() -> void:
	print('te_3 pressed')
	load_skill_description('te_3')
	
func _on_te_4_pressed() -> void:
	print('te_4 pressed')
	load_skill_description('te_4')
	
func _on_te_5_pressed() -> void:
	print('te_5 pressed')
	load_skill_description('te_5')
