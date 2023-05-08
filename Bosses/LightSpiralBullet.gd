extends Area2D

export (PackedScene) var lightbullet
var speed = 1
var shooting = false
onready var bulletdelay = $BulletDelay 
var num_bullets = 90
var angle_step = 4
var start_angle = 0

var velocity = Vector2.ZERO

func _process(_delta):
	translate(velocity)
	if shooting == true:
		spawn_bullets()
		shooting = false
		
	
func set_bullet_direction(direction):
	velocity = direction * speed

func _on_LightSpiralBullet_body_entered(body:Node):
	body.absorb_hit_light(1)
	queue_free()

func _on_BulletDeath_timeout():
	queue_free()

func _on_SpeedZero_timeout():
	velocity = Vector2.ZERO
	shooting = true  

func spawn_bullets():
	bulletdelay.start() # start the timer to wait for the next bullet
	for i in range(num_bullets):
		var bullet = lightbullet.instance()
		bullet.global_position = global_position + Vector2(0,0)
		bullet.rotation_degrees = start_angle + i * angle_step
		get_parent().add_child(bullet)
		bullet.set_bullet_speed_and_direction(Vector2(1, 0).rotated(deg2rad(bullet.rotation_degrees - 90)))
		yield(bulletdelay, "timeout") # wait for the remaining delay before spawning the next bullet

func _on_BulletDelay_timeout():
	start_angle += angle_step
	if start_angle >= 360:
		bulletdelay.stop()
		queue_free()


