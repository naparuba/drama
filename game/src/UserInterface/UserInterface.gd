extends Node


onready var scene_tree: SceneTree = get_tree()
onready var score_label: Label = $Score
onready var fps_label: Label = $Fps
onready var pause_overlay: ColorRect = $PauseOverlay
onready var title_label: Label = $PauseOverlay/Title
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton
onready var sound_game_over = $sounds/game_over

const MESSAGE_DIED: = "You died"

var paused: = false setget set_paused


func _ready() -> void:
	PlayerData.connect("updated", self, "update_interface")
	PlayerData.connect("died", self, "_on_Player_died")
	PlayerData.connect("reset", self, "_on_Player_reset")
	update_interface()


func _process(delta):
	self.fps_label.text = 'Fps:     %s' % Engine.get_frames_per_second()

func _on_Player_died() -> void:
	self.paused = true
	title_label.text = MESSAGE_DIED
	self.sound_game_over.play()


func _on_Player_reset() -> void:
	self.paused = false


# NOTE: _input to be priority for main menu taht is still there?
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and title_label.text != MESSAGE_DIED:
		self.paused = not self.paused
		# stop propagation
		get_tree().set_input_as_handled()


func update_interface() -> void:
	score_label.text = "Score: %s" % PlayerData.score


func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
