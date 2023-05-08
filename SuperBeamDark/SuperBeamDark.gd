extends Area2D

const SPEED = 1200

func _process(delta):
	var velocity = Vector2(0, -1) * SPEED * delta
	translate(velocity)
	if position.y < -200:
		queue_free()
