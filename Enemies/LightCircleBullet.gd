extends Area2D

var velocity = Vector2(0, 0)
var speed = 300

func _on_LightCircleBullet_body_entered(body:Node):
	body.absorb_hit_light(5)
	queue_free()

func _on_BulletDeath_timeout():
    queue_free()

func _process(delta):
    translate(velocity * speed * delta) 

func set_bullet_speed_and_direction(direction: Vector2):
    velocity = direction