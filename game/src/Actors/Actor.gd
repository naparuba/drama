extends KinematicBody2D
class_name Actor


const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(400.0, 500.0)
export var GRAVITY: = 3500.0

var _velocity: = Vector2.ZERO


func _apply_gravity(delta:float) -> void:
	self._velocity.y += GRAVITY * delta


# The actor class compute the GRAVITY fall
func _physics_process(delta: float) -> void:
	self._apply_gravity(delta)
