extends Area2D

const SPEED = 2000

func _process(delta):
	var velocity = Vector2(0, -1) * SPEED * delta
	translate(velocity)
	
