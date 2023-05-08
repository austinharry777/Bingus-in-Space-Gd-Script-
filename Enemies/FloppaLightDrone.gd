extends Area2D

onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var flash = $AnimatedSprite/AnimationPlayer2
onready var animation = $AnimatedSprite.get_animation()
onready var path_follow = get_parent()
onready var collisionshape = $CollisionPolygon2D
var scored: bool = false
onready var explosion_sound = $AudioStreamPlayer
var health: int = 8 #health of the floppa drone

func _process(_delta):
	free_self()

func _on_FloppaDrone_area_entered(area:Area2D):
	if area.collision_layer == 2:
		self.take_damage(1)
		flash.play("Flash")
		
	if area.collision_layer == 4 or area.collision_layer == 64\
	or area.collision_layer == 128:
		self.take_damage(8)
		

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

func take_damage(damage):
	health -= damage
	if health <= 0 and scored == false:
		Game.score += 200
		scored = true
		path_follow.speed = 0 #stop the floppa drone
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		explosion_sound.play()
		anim_player.play("explosion")
		explosion_fade.play("fade")







