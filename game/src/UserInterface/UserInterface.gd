extends Node


onready var scene_tree: SceneTree = get_tree()
onready var score_label: Label = $Score
onready var fps_label: Label = $Fps
onready var pause_overlay: ColorRect = $PauseOverlay
onready var title_label: Label = $PauseOverlay/Title
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton
onready var sound_game_over = $sounds/game_over


onready var combo_bloc = $combos
onready var red_overlay = $red_overlay
onready var combo_label = $combos/combo
onready var player_power_level = 0
onready var scooter = $scooter

var SCOOTER_BASE_COLOR = Color('ff4d54')
var base_color_levels = {
	0: 'adff4d',
	1: 'fff84d',
	2:'ff9f4d',
	3: 'ff4d54',
}
var SCOOTER_DARK_COLOR = Color('982d31')
var dark_color_levels = {
	0: '66982d',
	1: '98942d',
	2:'985e2d',
	3: '982d31',
}

const MESSAGE_DIED: = "You died"

var paused: = false setget set_paused


func _ready() -> void:
	PlayerData.connect("updated", self, "update_interface")
	PlayerData.connect("died", self, "_on_Player_died")
	PlayerData.connect("reset", self, "_on_Player_reset")
	PlayerData.connect("update_combo_value", self, "_on_Player_update_combo_value")
	PlayerData.connect("combo_flash", self, "_on_Player_combo_flash")
	PlayerData.connect("combo_hide", self, "_on_Player_combo_hide")
	
	self._hide_combos()
	
	update_interface()


func _process(delta):
	self.fps_label.text = 'Fps:     %s' % Engine.get_frames_per_second()

func _on_Player_died() -> void:
	self.paused = true
	title_label.text = MESSAGE_DIED
	self.sound_game_over.play()


func _on_Player_reset() -> void:
	self.paused = false


func _on_Player_increase_power(power_level):
	self.player_power_level = power_level
	

# NOTE: _input to be priority for main menu taht is still there?
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and title_label.text != MESSAGE_DIED:
		self.paused = not self.paused
		# stop propagation
		get_tree().set_input_as_handled()


func update_interface() -> void:
	score_label.text = "Score: %s" % PlayerData.score
	self._on_Player_update_combo_value(PlayerData.combo_value)


func _set_scooter_color(color_number):
	pass

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value


func _on_Player_combo_flash():
	print('UI:COMBO FLASH')
	
func _on_Player_combo_hide():
	print('UI:COMBO HIDE')
	self._hide_combos()


func _show_combos():
	self.combo_bloc.visible = true
	
func _hide_combos():
	self.combo_bloc.visible = false

func _on_Player_update_combo_value(combo_value):
	print('ui::_on_Player_update_combo_value::combo value =%s' % combo_value)
	if combo_value == 0:
		self._hide_combos()
	else:
		self._show_combos()
		self.combo_label.text = "Combo: x%s" % combo_value
