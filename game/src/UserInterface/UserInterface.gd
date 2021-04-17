extends Node


onready var scene_tree: SceneTree = get_tree()
onready var bomb_timer_label = $bomb_timer
onready var bomb_timer_timer = $bombs/Timer
onready var bombs_label: Label = $bombs
onready var health_label: Label = $health
onready var fps_label: Label = $Fps
onready var pause_overlay: ColorRect = $PauseOverlay
onready var title_label: Label = $PauseOverlay/Title
onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton
onready var sound_game_over = $sounds/game_over


onready var combo_bloc = $combos
onready var red_overlay = $red_overlay
onready var combo_label = $combos/combo

var bomb_time = 140

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
	
	self._on_bomb_tick_timeout()
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
	bombs_label.text = "Bombs: %s / 8" % PlayerData.bombs
	health_label.text = "Health: %.1f / 8" % PlayerData.health
	self._on_Player_update_combo_value(PlayerData.combo_value)



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


func _on_bomb_tick_timeout():
	self.bomb_time -= 1
	
	var min_ = int(self.bomb_time / 60)
	var sec_ = int(self.bomb_time % 60)
	
	bomb_timer_label.text = ('%d' % min_) + ':' + ('%d' % sec_)
