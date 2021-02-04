extends Area2D

class_name Coin, "res://assets/coin.png"

onready var anim_player: AnimationPlayer = $AnimationPlayer

export var score: = 100


func _on_body_entered(body: PhysicsBody2D) -> void:
	picked()


func picked() -> void:
	PlayerData.score += score
	anim_player.play("picked")
