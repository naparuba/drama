extends Actor


class_name Enemy, "res://assets/enemy.png"

onready var stomp_area: Area2D = $StompArea2D

export var speed: = Vector2(400.0, 500.0)
export var score: = 100

onready var human = $human

var _facing = 'left'

func _ready() -> void:
	self.set_physics_process(false)
	self._current_velocity.x = -speed.x
	self.human.set_state('walk_left')


func _physics_process(delta: float) -> void:
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
	self.die()


func die() -> void:
	PlayerData.score += score
	self.queue_free()
