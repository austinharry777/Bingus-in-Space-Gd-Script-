extends Area2D

export (PackedScene) var lightcirclebullet
export (PackedScene) var lightbeam = preload("res://Enemies/LightBeam.tscn")
var health: int = 200
var y_speed: int = 400 #speed of the floppa ship
var stop_speed: int = 0 #speed of the floppa ship
var y_max_speed: int = 400
var stopped = false

var x_speed: int = 0 #speed of the floppa ship
var x_max_speed: int = 595

var y_move_direction: int = 1 #1 is down, -1 is up
var x_move_direction: int = 1 #1 is right, -1 is left
var max_speed_reached = false
var right_side_reached = false

#count of screen transversals back and forth for removing the floppa ship
var transversals: int = 0
var ready_to_leave = false

onready var animation = $AnimatedSprite.get_animation()
onready var flash = $Sprite/AnimationPlayer2
onready var anim_player = $AnimatedSprite
onready var collisionshape = $CollisionPolygon2D
onready var explosion_sound = $AudioStreamPlayer
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var sprite = $Sprite
onready var gunpoint = $GunPoint #gunpoint of the floppa ship
var scored = false

#bullet variables
var time_since_bullet_fired: float = 0
var bullet_cooldown: float = 1

#laser variables
var time_since_laser_fired: float = 0
var laser_cooldown: float = 0.06 #seconds

func _process(delta):
	time_since_bullet_fired += delta
	time_since_laser_fired += delta

	if time_since_bullet_fired > bullet_cooldown\
		and stopped == true\
		and transversals < 1:
		shoot_bullets()
		time_since_bullet_fired = 0

	if time_since_laser_fired > laser_cooldown\
		and ready_to_leave == false\
		and transversals >= 1:
		shoot_beam()
		time_since_laser_fired = 0
	
	if ready_to_leave == true:
		y_move_direction = -1
		if y_speed < y_max_speed:
			y_speed += 3
		if position.y < -200:
			queue_free()

	if stopped == true:
		#move the ship back and forth along x axis using smooth stops and gradual takeoffs
		if right_side_reached == false:
			if position.x < 1130:
				if x_speed < x_max_speed and max_speed_reached == false:
					x_speed += 3
				if x_speed >= x_max_speed:
					max_speed_reached = true
				if x_speed > stop_speed and max_speed_reached == true:
					x_speed -= 3
			if position.x >= 1130:
				x_speed = 0
				max_speed_reached = false
				x_move_direction = -1
				right_side_reached = true

		if right_side_reached == true:
			if position.x > 150:
				if x_speed < x_max_speed and max_speed_reached == false:
					x_speed += 3
				if x_speed >= x_max_speed:
					max_speed_reached = true
				if x_speed > stop_speed and max_speed_reached == true:
					x_speed -= 3
			if position.x <= 150:
				x_speed = 0
				max_speed_reached = false
				x_move_direction = 1
				right_side_reached = false
				transversals += 1
	
	if transversals == 2:
		ready_to_leave = true
	
	#move the floppa ship down and gradually slow it down to a stop
	if y_speed > stop_speed and stopped == false:
		y_speed -= 3
	if y_speed <= 0:
		stopped = true
		y_speed = 0

	position.y += y_speed * delta * y_move_direction #move the floppa ship up or down
	position.x += x_speed * delta * x_move_direction #move the floppa ship left or right

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "fade":
		self.queue_free()

func _on_AnimatedSprite_animation_finished():
	if animation == "explosion": 
		self.queue_free()

func _on_LightBeamShip_area_entered(area:Area2D):
	if area.collision_layer == 2:
		self.take_damage(1)
		flash.play("flash")
		
	if area.collision_layer == 4:
		self.take_damage(2)
		flash.play("flash")

	if area.collision_layer == 64:
		self.take_damage(Game.super_beam_damage_modifier *1)
		flash.play("flash")

	if area.collision_layer == 128:
		self.take_damage(Game.super_beam_damage_modifier *2)
		flash.play("flash")

func take_damage(damage):
	health -= damage
	if health <= 0 and scored == false:
		Game.score += 10000
		scored = true
		x_speed = 0 #stop the floppa ship
		y_speed = 0 #stop the floppa ship
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		explosion_sound.play()
		sprite.visible = false
		anim_player.scale = Vector2(2,2)
		anim_player.play("explosion")
		explosion_fade.play("fade")

func shoot_bullets():
	var bullet0 = lightcirclebullet.instance()
	var bullet1 = lightcirclebullet.instance()
	var bullet2 = lightcirclebullet.instance()
	var bullet3 = lightcirclebullet.instance()
	var bullet4 = lightcirclebullet.instance()
	var bullet_list = [bullet0, bullet1, bullet2, bullet3, bullet4]
	for bullet in bullet_list:
		bullet.global_position = gunpoint.global_position
		bullet.rotation = gunpoint.rotation
		bullet.speed = 450
		get_parent().add_child(bullet)
	bullet0.set_bullet_speed_and_direction(Vector2(-0.8, 1).normalized())
	bullet1.set_bullet_speed_and_direction(Vector2(-0.35, 1).normalized())
	bullet2.set_bullet_speed_and_direction(Vector2(0, 1).normalized())
	bullet3.set_bullet_speed_and_direction(Vector2(0.35, 1).normalized())
	bullet4.set_bullet_speed_and_direction(Vector2(0.8, 1).normalized())

func shoot_beam():
	var beam = lightbeam.instance()
	#add beam as a child of the LightBeamShip node so that it moves with the ship
	add_child(beam)
	beam.global_position = gunpoint.global_position
	beam.rotation = gunpoint.rotation
	beam.set_beam_speed_and_direction(Vector2(0, 1).normalized())




	

	

