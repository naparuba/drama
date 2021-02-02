extends Actor


onready var stomp_area: Area2D = $StompArea2D

export var score: = 100


func _ready() -> void:
	self.set_physics_process(false)
	self._current_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	self._current_velocity.x *= -1 if self.is_on_wall() else 1
	self._current_velocity.y = self.move_and_slide(self._current_velocity, FLOOR_NORMAL).y


func _on_StompArea2D_area_entered(other: Area2D) -> void:
	if other.global_position.y > stomp_area.global_position.y:
		return
	self.die()


func die() -> void:
	PlayerData.score += score
	self.queue_free()
