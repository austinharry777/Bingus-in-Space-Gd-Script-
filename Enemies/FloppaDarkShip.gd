extends Area2D

export (PackedScene) var darkcirclebullet
onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var flash = $AnimatedSprite/AnimationPlayer2
onready var animation = $AnimatedSprite.get_animation()
onready var collisionshape = $CollisionPolygon2D
var scored: bool = false
onready var explosion_sound = $AudioStreamPlayer
var health: int = 100 #health of the floppa ship
onready var player = get_node("/root/Earth/Player")
onready var gunpoint = $GunPoint #gunpoint of the floppa ship

var speed: int = 400 #speed of the floppa ship
var stop_speed: int = 0 #speed of the floppa ship
var max_speed: int = 400
var stopped = false
var done_firing = false

#bullet variables
var time_since_bullet_fired = 0
var bullet_cooldown = 1
var shot_count = 0

var move_direction = 1 #direction of the floppa ship

func _process(delta):
	time_since_bullet_fired += delta

	if done_firing == true:
		move_direction = -1
		if speed < max_speed:
			speed += 3
			
	if stopped == true:
		var v = player.position - position	
		var angle = v.angle() - PI/2
		var r = global_rotation 
		global_rotation = lerp_angle(r, angle, .02)
	
	if time_since_bullet_fired > bullet_cooldown and stopped == true and done_firing == false:
		shoot()
		time_since_bullet_fired = 0
		shot_count += 1
		if shot_count >= 5:
			done_firing = true
			
	if speed <= 0:
		stopped = true
	
	#move the floppa ship down and gradually slow it down to a stop
	if speed > stop_speed and stopped == false:
		speed -= 3
	
	position.y += speed * delta * move_direction #move the floppa ship up or down
	
func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "fade":
		self.queue_free()
		
func _on_AnimatedSprite_animation_finished():
	if animation == "explosion": 
		self.queue_free()

func _on_FloppaDarkShip_area_entered(area:Area2D):
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
			
func _on_FloppaDarkShip_body_entered(body:Node):
	body.take_damage()
				
func take_damage(damage):
	health -= damage
	if health <= 0 and scored == false:
		Game.score += 5000
		scored = true
		speed = 0 #stop the floppa ship
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		anim_player.speed_scale = 1 #start the explosion animation
		explosion_sound.play()
		anim_player.scale = Vector2(1.5,1.5)
		anim_player.play("explosion")
		explosion_fade.play("fade")
						
func _on_KillTimer_timeout():
	queue_free() #kill the floppa ship if it's not killed by the player

func shoot():
	var bullet = darkcirclebullet.instance()
	get_parent().add_child(bullet)
	bullet.global_position = gunpoint.global_position
	bullet.rotation = gunpoint.rotation
	var direction = (player.global_position - bullet.global_position).normalized()
	bullet.set_bullet_speed_and_direction(direction) #shoot the bullet

