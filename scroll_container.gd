extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const FILENAME = 'res://data/news.json'
	var json_data = load_json_data(FILENAME)
	print(json_data)
	#var vbox = get_node('TextureRect/VBoxContainer')
	#
	#for key in json_data:
		#var item = json_data[key]
		#var headline = item['Headline']
		#var body = item['Body']
		#
		#var title_label = Label.new()
		#title_label.text = headline
		#title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#var body_label = Label.new()
		#body_label.text = body
		#body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#vbox.add_child(title_label)
		#vbox.add_child(body_label)

		

func load_json_data(path : String):
	var filename = 'res://data/news.json'
	var json_text = FileAccess.get_file_as_string(filename)
	var json_dict = JSON.parse_string(json_text).get('News')
	return json_dict

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var texture_rect = get_node("../TextureRect")
	texture_rect.visible = !$"..".hide
	var transparent_bg = get_node("../Transparent_bg")
	transparent_bg.visible = !$"..".hide
	var scroll_container = get_node("../ScrollContainer")
	scroll_container.visible = !$"..".hide


func _on_update_toggle_button_down() -> void:
	$"..".clicked = true

func _on_skill_tree_toggle_button_down() -> void:
	var skill_tree = get_node("../SkillTree")
	skill_tree.visible = !skill_tree.visible
	$"..".skillclicked = true
