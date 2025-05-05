extends Control


var json_data
var skill_name_label 
var skill_description_label
var skill_box
var btn_active

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const FILENAME = 'res://data/skill_tree.json'
	json_data = load_json_data(FILENAME)
	print(json_data)
	
	skill_name_label = get_node('Skill Descriptions/Name');
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
	
	if name == btn_active:
		skill_box.visible = !skill_box.visible
	else:
		skill_box.visible = true
			
	btn_active = name
	skill_name_label.text = name
	skill_description_label.text = skill_description
	
# Agriculture skill signals
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
	

# Industrial skill signals
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
	
# Environmental skill signals
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
	

# Technology skill signals
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
	
