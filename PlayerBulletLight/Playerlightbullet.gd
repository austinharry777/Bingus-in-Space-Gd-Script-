extends Area2D

var speed = 1400
onready var anim_player = $AnimatedSprite
onready var animation = $AnimatedSprite.get_animation()

func _process(delta):
	var velocity = Vector2(0, -1) * speed * delta
	translate(velocity)
	
func _on_Playerlightbullet_area_entered(_area:Area2D):
	anim_player.play("bulletstop")
	$BulletDeath.start()
	speed = 0
	
func _on_BulletDeath_timeout():
	queue_free()
