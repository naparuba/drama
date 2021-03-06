extends Node


signal updated
signal died
signal reset
signal update_combo_value
signal combo_flash
signal combo_hide


var score: = 0 #setget set_score
var deaths: = 0 #setget set_deaths

var combo_value = 0

var combo_timer = null
var combo_flash_timer = null

func _ready():
	self.combo_timer = Timer.new()
	add_child(self.combo_timer)
	self.combo_timer.wait_time = 10
	self.combo_timer.one_shot = true
	self.combo_flash_timer = Timer.new()
	self.combo_flash_timer.one_shot = true
	self.add_child(self.combo_flash_timer)
	self.combo_flash_timer.wait_time = 5
	
	self.combo_timer.connect("timeout",self,"_combo_hide") 
	self.combo_flash_timer.connect("timeout",self,"_combo_flash") 
	emit_signal('update_combo_value', self.combo_value)

func reset():
	self.score = 0
	self.deaths = 0
	emit_signal("reset")


func set_score(new_score: int) -> void:
	score = new_score
	emit_signal("updated")


func set_deaths(new_value: int) -> void:
	deaths = new_value
	emit_signal("died")


func kill_enemy(score):
	print('PlayerData::kill_enemi')
	self.score += score
	self.combo_value += 1
	print('KILL enemi, start timers (currnet combo:%s)' % self.combo_value)
	self.combo_timer.start()
	self.combo_flash_timer.start()
	emit_signal('update_combo_value', self.combo_value)


func _combo_flash():
	emit_signal('combo_flash')
	
func _combo_hide():
	self.combo_value = 0
	emit_signal('combo_hide')
