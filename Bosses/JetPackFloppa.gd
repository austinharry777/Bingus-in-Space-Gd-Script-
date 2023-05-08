extends Area2D

var speed: int = 300
var velocity = Vector2()
var boss_arrived = false
var boss_direction = 1 # 1 = right, -1 = left
var scored = false

onready var player = get_node("/root/TestScene/Player")
onready var flash = $AnimatedSprite/AnimationPlayer
onready var anim_player = $AnimatedSprite #reference to the animated sprite
onready var collisionshape = $CollisionPolygon2D
onready var boss_meter = get_node("/root/TestScene/Player/HUD/BossBar")
onready var explosion1= $AnimatedSprite2
onready var explosion1_fade= $AnimatedSprite2/AnimationPlayer
onready var explosion2= $AnimatedSprite3
onready var explosion2_fade= $AnimatedSprite3/AnimationPlayer
onready var explosion3= $AnimatedSprite4
onready var explosion3_fade= $AnimatedSprite4/AnimationPlayer
onready var explosion4= $AnimatedSprite5
onready var explosion4_fade= $AnimatedSprite5/AnimationPlayer
onready var explosion5= $AnimatedSprite6
onready var explosion5_fade= $AnimatedSprite6/AnimationPlayer
onready var explosion_sound = $ExplosionSound
onready var final_fade = $AnimatedSprite/AnimationPlayer2

#reference to jetpack fireball and firing positions
export (PackedScene) var fireball 
onready var fireballfaceright = $Fireballfaceright
onready var fireballfaceleft = $Fireballfaceleft

#reference to colored bullets and laser firing positions
export (PackedScene) var lightbullet
export (PackedScene) var darkbullet
onready var laserfaceright = $Laserfaceright
onready var laserfaceleft = $Laserfaceleft

#reference to drones and throwing positions
onready var drone = preload("res://Enemies/FloppaDroneRandom.tscn")
onready var lightdrone = preload("res://Enemies/FloppaLightDroneRandom.tscn")
onready var darkdrone = preload("res://Enemies/FloppaDarkDroneRandom.tscn")
onready var dronethrowright = $Dronethrowright
onready var dronethrowleft = $Dronethrowleft

#reference to spiralbullet gun positions and bullets
export (PackedScene) var lightspiralbullet
export (PackedScene) var darkspiralbullet
onready var spiralbulletright = $SpiralBulletRight
onready var spiralbulletleft = $SpiralBulletLeft

#fireball variables
var time_since_fireball_fired: float = 0
var fireball_cooldown: float = 1

#laser variables
var time_since_laser_fired: float = 0
var laser_cooldown: float = 0.02
var light_laser = true
var laser_firing: int = 0

#drone variables
var time_since_drone_thrown: float = 0
var drone_cooldown: float = 2

#spiral bullet variables
var time_since_spiral_bullet_fired: float = 0
var spiral_bullet_cooldown: float = 2
var light_spiral = true

func _ready():
	boss_meter.visible = true # make the boss meter visible

func _process(delta):
	time_since_fireball_fired += delta
	time_since_laser_fired += delta
	time_since_drone_thrown += delta
	time_since_spiral_bullet_fired += delta

	if time_since_fireball_fired >= fireball_cooldown and boss_arrived == true:
		shoot_fireball()
		time_since_fireball_fired = 0

	if time_since_drone_thrown >= drone_cooldown and boss_arrived == true:
		throw_drone()
		time_since_drone_thrown = 0

	if Game.boss_health >= 1000:
		if boss_arrived == false:
			velocity = Vector2(1,1)
			if position.y >= 160:
				position.y = 160
				boss_arrived = true

		elif boss_arrived == true:
			velocity = Vector2(1,0)

		if time_since_laser_fired >= laser_cooldown and boss_arrived == true:
			shoot_laser()
			time_since_laser_fired = 0
	
		if position.x >= 1120:
			boss_direction = -1
			$AnimatedSprite.flip_h = false 
		elif position.x <= 160:
			boss_direction = 1
			$AnimatedSprite.flip_h = true
		
		velocity.x = (velocity.x * boss_direction) * speed
		velocity.y = velocity.y * speed
		position += velocity * delta
	
	else:
		
		if time_since_spiral_bullet_fired >= spiral_bullet_cooldown and boss_arrived == true:
			shoot_spread_bullet()
			time_since_spiral_bullet_fired = 0
		
		if scored == true:
			speed = 0
			boss_arrived = false
		
		else:
			speed = 100
			#move the boss towards the player using differences in position
			velocity = player.position - position

			#flip sprite based on x position
			if velocity.x > 0:
				$AnimatedSprite.flip_h = true
				rotation = lerp_angle(rotation, velocity.angle(), 0.02)
				
			elif velocity.x < 0:
				$AnimatedSprite.flip_h = false
				rotation = lerp_angle(rotation, velocity.angle() + 3.14, 0.02)
			
		#normalize and move the boss
		velocity = velocity.normalized() * speed
		position += velocity * delta

func _on_JetPackFloppa_body_entered(body:Node):
	body.take_damage() # this is the function that is called in the player script

func _on_JetPackFloppa_area_entered(area:Area2D):
	if area.collision_layer == 2:
		self.take_damage(2)
		flash.play("flash")
		
	if area.collision_layer == 4:
		self.take_damage(2)
		flash.play("flash")

	if area.collision_layer == 64:
		self.take_damage(Game.super_beam_damage_modifier *1)
		flash.play("flash")

	if area.collision_layer == 128:
		self.take_damage(Game.super_beam_damage_modifier *1)
		flash.play("flash")

func take_damage(damage):
	Game.boss_health -= damage
	if Game.boss_health <= 0 and scored == false:
		Game.score += 20000
		scored = true
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		explosion_sound.play()
		explosion1.visible = true
		explosion1.play("explosion")
		explosion1_fade.play("fade")

func _on_AnimatedSprite5_animation_finished():
	explosion_sound.pitch_scale = 0.6
	explosion_sound.play()
	anim_player.play("finalexplosion")
	final_fade.play("shipexplosionfade")

func _on_AnimatedSprite4_animation_finished():
	explosion_sound.play()
	explosion4.visible = true
	explosion4.play("explosion")
	explosion4_fade.play("fade")

func _on_AnimatedSprite3_animation_finished():
	explosion_sound.play()
	explosion3.visible = true
	explosion3.play("explosion")
	explosion3_fade.play("fade")

func _on_AnimatedSprite2_animation_finished():
	explosion_sound.play()
	explosion2.visible = true
	explosion2.play("explosion")
	explosion2_fade.play("fade")

func shoot_fireball():
	var fireball_instance = fireball.instance()
	
	if $AnimatedSprite.flip_h == true:
		fireball_instance.global_position = fireballfaceright.global_position
		get_parent().add_child(fireball_instance)
		fireball_instance.set_fireball_direction(Vector2(-1,0))
		yield(get_tree().create_timer(0.7), "timeout")
		fireball_instance.set_fireball_direction(Vector2(0,1))
		fireball_instance.speed = 1000
		
	elif $AnimatedSprite.flip_h == false:
		fireball_instance.global_position = fireballfaceleft.global_position
		get_parent().add_child(fireball_instance)
		fireball_instance.set_fireball_direction(Vector2(1,0))
		yield(get_tree().create_timer(0.7), "timeout")
		fireball_instance.set_fireball_direction(Vector2(0,1))
		fireball_instance.speed = 1000

func shoot_laser():
	if light_laser and laser_firing % 3 == 0:
		var lightbullet_instance = lightbullet.instance()
		lightbullet_instance.scale = Vector2(1.5,1.5)
		
		if $AnimatedSprite.flip_h == true:
			lightbullet_instance.global_position = laserfaceright.global_position
			lightbullet_instance.rotation_degrees = 90
			get_parent().add_child(lightbullet_instance)
			lightbullet_instance.set_bullet_speed_and_direction(Vector2(3,0))
			yield(get_tree().create_timer(1), "timeout")
			if is_instance_valid(lightbullet_instance):
				var homing_direction = player.position - lightbullet_instance.global_position
				lightbullet_instance.set_bullet_speed_and_direction(homing_direction * 0.01)
				lightbullet_instance.rotation = homing_direction.angle() + 3.14/2
			else:
				return 
			
		elif $AnimatedSprite.flip_h == false:
			lightbullet_instance.global_position = laserfaceleft.global_position
			lightbullet_instance.rotation_degrees = -90
			get_parent().add_child(lightbullet_instance)
			lightbullet_instance.set_bullet_speed_and_direction(Vector2(-3,0))
			yield(get_tree().create_timer(1), "timeout")
			#check to see if bullet has not been destroyed
			if is_instance_valid(lightbullet_instance):
				var homing_direction = player.position - lightbullet_instance.global_position
				lightbullet_instance.set_bullet_speed_and_direction(homing_direction * 0.01)
				lightbullet_instance.rotation = homing_direction.angle() + 3.14/2
			else:
				return
			
			
	elif light_laser == false and laser_firing % 3 == 0:
		var darkbullet_instance = darkbullet.instance()
		darkbullet_instance.scale = Vector2(1.5,1.5)
		if $AnimatedSprite.flip_h == true:
			darkbullet_instance.global_position = laserfaceright.global_position
			darkbullet_instance.rotation_degrees = 90
			get_parent().add_child(darkbullet_instance)
			darkbullet_instance.set_bullet_speed_and_direction(Vector2(3,0))
			yield(get_tree().create_timer(1), "timeout")
			if is_instance_valid(darkbullet_instance):
				var homing_direction = player.position - darkbullet_instance.global_position
				darkbullet_instance.set_bullet_speed_and_direction(homing_direction * 0.01)
				darkbullet_instance.rotation = homing_direction.angle() + 3.14/2
			else:
				return
			
			
		elif $AnimatedSprite.flip_h == false:
			darkbullet_instance.global_position = laserfaceleft.global_position
			darkbullet_instance.rotation_degrees = -90
			get_parent().add_child(darkbullet_instance)
			darkbullet_instance.set_bullet_speed_and_direction(Vector2(-3,0))
			yield(get_tree().create_timer(1), "timeout")
			if is_instance_valid(darkbullet_instance):
				var homing_direction = player.position - darkbullet_instance.global_position
				darkbullet_instance.set_bullet_speed_and_direction(homing_direction * 0.01)
				darkbullet_instance.rotation = homing_direction.angle() + 3.14/2
			else:
				return
			
func throw_drone():
	var which_drone = randi()%3
	var drone_instance
	if which_drone == 0:
		drone_instance = drone.instance()
	elif which_drone == 1:
		drone_instance = lightdrone.instance()
	elif which_drone == 2:
		drone_instance = darkdrone.instance()

	if $AnimatedSprite.flip_h == true:
		drone_instance.global_position = dronethrowright.global_position
		get_parent().add_child(drone_instance)
		
	elif $AnimatedSprite.flip_h == false:
		drone_instance.global_position = dronethrowleft.global_position
		get_parent().add_child(drone_instance)

	anim_player.play("throwdrone")

func shoot_spread_bullet():
	if light_spiral:
		var lightspiralbullet_instance = lightspiralbullet.instance()
		if $AnimatedSprite.flip_h == true:
			lightspiralbullet_instance.global_position = spiralbulletright.global_position
			var rotation = deg2rad(spiralbulletright.rotation_degrees)
			get_parent().add_child(lightspiralbullet_instance)
			lightspiralbullet_instance.set_bullet_direction(Vector2(cos(rotation), -sin(rotation)).normalized())
			
		elif $AnimatedSprite.flip_h == false:
			lightspiralbullet_instance.global_position = spiralbulletleft.global_position
			var rotation = deg2rad(spiralbulletleft.rotation_degrees)
			get_parent().add_child(lightspiralbullet_instance)
			lightspiralbullet_instance.set_bullet_direction(Vector2(cos(rotation), -sin(rotation)).normalized())
			
	elif light_spiral == false:
		var darkspiralbullet_instance = darkspiralbullet.instance()
		if $AnimatedSprite.flip_h == true:
			darkspiralbullet_instance.global_position = spiralbulletright.global_position
			var rotation = deg2rad(spiralbulletright.rotation_degrees)
			get_parent().add_child(darkspiralbullet_instance)
			darkspiralbullet_instance.set_bullet_direction(Vector2(cos(rotation), -sin(rotation)).normalized())

		elif $AnimatedSprite.flip_h == false:
			darkspiralbullet_instance.global_position = spiralbulletleft.global_position
			var rotation = deg2rad(spiralbulletleft.rotation_degrees)
			get_parent().add_child(darkspiralbullet_instance)
			darkspiralbullet_instance.set_bullet_direction(Vector2(cos(rotation), -sin(rotation)).normalized())

func _on_LaserColorTimer_timeout():
	light_laser = !light_laser
	
func _on_LaserFiring_timeout():
	laser_firing += 1

func _on_AnimatedSprite_animation_finished():
	if anim_player.animation == "throwdrone":
		anim_player.play("default")
	if anim_player.animation == "finalexplosion":
		$LevelCompleteTimer.start()

func _on_SpiralBulletColorTimer_timeout():
	light_spiral = !light_spiral

func level_complete():
	# Show the Level Complete screen
	var level_complete_screen = load("res://Cutscenes/LevelComplete.tscn").instance()
	get_tree().get_root().add_child(level_complete_screen)

func _on_LevelCompleteTimer_timeout():
	level_complete() # Show the Level Complete screen
