extends Area2D

export (PackedScene) var darkbullet 
onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var flash = $AnimatedSprite/AnimationPlayer2
onready var animation = $AnimatedSprite.get_animation()
onready var collisionshape = $CollisionShape2D
var scored: bool = false
onready var explosion_sound = $AudioStreamPlayer
var health: int = 24 #health of the tank 
var yspeed = 250 #speed of the tank
var xspeed = 300 #speed of the tank
onready var gun_position = $GunPosition
var shoot_now = false

#bullet cooldown
var time_since_bullet_fired = 0
var bullet_cooldown = 0.5

func _process(delta):
	time_since_bullet_fired += delta
	position.y += yspeed * delta
	position.x += xspeed * delta
	free_self()
	if time_since_bullet_fired > bullet_cooldown and shoot_now == true and scored == false:
		shoot()
		time_since_bullet_fired = 0

func free_self():
	if position.y > 1000:
		self.queue_free()

func take_damage(damage):
	health -= damage
	if health <= 0 and scored == false:
		Game.score += 1000
		scored = true
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		explosion_sound.play()
		anim_player.play("explosion")
		explosion_fade.play("fade")

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "fade":
		queue_free()

func _on_AnimatedSprite_animation_finished():
	if animation == "explosion": 
		queue_free()

func _on_StopTimer_timeout():
	xspeed = 0
	anim_player.stop() #stop the animation
	shoot_now = true

func _on_DarkTank_area_entered(area:Area2D):
	
	if area.collision_layer == 4:
		self.take_damage(1)
		flash.play("flash")
		
	if area.collision_layer == 2:
		self.take_damage(2)
		flash.play("flash")

	if area.collision_layer == 64:
		self.take_damage(Game.super_beam_damage_modifier *2)
		flash.play("flash")

	if area.collision_layer == 128:
		self.take_damage(Game.super_beam_damage_modifier *1)
		flash.play("flash")

	
func _on_DarkTank_body_entered(body:Node):
	body.take_damage()

func shoot():
	var bullet = darkbullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = gun_position.global_position
	bullet.rotation = gun_position.rotation
	bullet.set_bullet_speed_and_direction(Vector2(3, 1)) #shoot the bullet

