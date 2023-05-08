extends Area2D

onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var animation = $AnimatedSprite.get_animation()
onready var path_follow = get_parent()
onready var collisionshape = $CollisionPolygon2D
var scored = false
onready var explosion_sound = $AudioStreamPlayer

func _process(_delta):
	free_self()

func _on_FloppaDrone_area_entered(_area:Area2D):
	if scored == false:
		Game.score += 200
		scored = true
	path_follow.speed = 0 #stop the floppa drone
	collisionshape.set_deferred("disabled", true) #disable the collision shape
	explosion_sound.play()
	anim_player.play("explosion")
	explosion_fade.play("fade")
	
func _on_FloppaDrone_body_entered(body):
	body.take_damage()
	
func _on_AnimatedSprite_animation_finished():
	if animation == "explosion": 
		self.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "fade":
		self.queue_free()

func free_self():
	if position.y > 1000:
		self.queue_free()





