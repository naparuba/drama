tool
extends Button


export(String, FILE) var next_scene_path: = ""


func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""


func _on_button_up() -> void:
	self._act()


# Catch event not catch by GUI
# if enter/pause => enter the game
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self._act()
		get_tree().set_input_as_handled()
		

# This button launch the game
func _act():
	PlayerData.reset()
	get_tree().change_scene(next_scene_path)
