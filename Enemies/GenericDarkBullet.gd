extends Area2D

var velocity = Vector2(0, 0)

func _process(_delta):
    translate(velocity)

func _on_BulletDeath_timeout():
	queue_free()

func _on_GenericDarkBullet_body_entered(body:Node):
	body.absorb_hit_dark(2)
	queue_free()

func set_bullet_speed_and_direction(direction: Vector2):
    velocity = direction






