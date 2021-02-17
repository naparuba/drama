extends Popup

var npc_name setget name_set
var dialogue setget dialogue_set


onready var animation_player = $back/dialogue/AnimationPlayer
onready var label_name = $back/Name
onready var label_dialogue = $back/dialogue


func name_set(new_value):
	npc_name = new_value
	label_name.text = new_value


func dialogue_set(new_value):
	dialogue = new_value
	label_dialogue.bbcode_text = new_value


func open():
	#self.get_tree().paused = true
	self.popup()
	
	animation_player.playback_speed = 60.0 / dialogue.length()
	animation_player.play("ShowDialogue")


func close():
	#self.get_tree().paused = false
	self.hide()
