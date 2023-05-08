extends Area2D

var velocity = Vector2(0,0)
var speed = 50
onready var fire_anim = $AnimatedSprite

func _on_JetFireBall_body_entered(body:Node):
	body.take_damage() 
	queue_free() 

func _process(delta):
	fire_anim.play("fireball")
	translate(velocity * speed * delta) 
	if velocity.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

	#turn on collision shape if animation frame is 8 or above
	if fire_anim.frame >= 10:
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true

	if position.y > 1000:
		queue_free()

func set_fireball_direction(direction: Vector2):
	velocity = direction




