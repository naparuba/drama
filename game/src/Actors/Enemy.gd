extends Actor


class_name Enemy, "res://assets/enemy.png"

onready var stomp_area: Area2D = $StompArea2D
onready var stomp_area_shape = $StompArea2D/CollisionShape2D
onready var collision_shape = $ CollisionShape2D

export var speed: = Vector2(400.0, 500.0)
export var score: = 100
export var max_health = 3

export var is_moving = true

onready var human = $human

var _facing = 'left'
var _health = max_health
var _is_dead = false


func _ready() -> void:
	self.set_physics_process(false)
	if self.is_moving:		
		self._current_velocity.x = -speed.x
		self.human.set_state('walk_left')
	else:
		self.human.set_state('idle_left')
	


func _physics_process(delta: float) -> void:
	if not self.is_moving:
		return
		
	if self.is_on_wall():	
		self._current_velocity.x *= -1
		if self._facing == 'left':
			self._facing = 'right'
		else:
			self._facing = 'left'
		human.set_state('walk_'+self._facing)
		print('ENEMY MOVE TO %s' % 'walk_'+self._facing)
		
	self._current_velocity.y = self.move_and_slide(self._current_velocity, FLOOR_NORMAL).y


func _on_StompArea2D_area_entered(other: Area2D) -> void:
	if other.global_position.y > stomp_area.global_position.y:
		return
	self.take_damage(2)


func take_damage(damage):
	if self._is_dead:  # dead do not dead twice ^^
		return
	self._health -= damage
	
	if self._health <=0:
		self.die()
	else:
		self.human.get_hit()

func is_dead():
	return self._is_dead


func die() -> void:
	self.is_moving = false
	self._is_dead = true
	self.stomp_area_shape.disabled = true
	self.collision_shape.disabled = true
	self.human.die()
	PlayerData.score += score
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(2.6)
	timer.connect("timeout", self, "delete")
	self.add_child(timer)   # note : add before start
	timer.start()


func delete():
	print('DELETE enemy')
	self.queue_free()
