extends Area2D

#variables and references to flopilot head and main scene
var speed: int = 50
var velocity = Vector2()
var boss_arrived = false
var boss_direction = 1 # 1 = right, -1 = left
var scored = false
var begin_phase2 = false

onready var flash = $AnimatedSprite/AnimationPlayer #reference to the flash animation
onready var anim_player = $AnimatedSprite #reference to the animated sprite
onready var headhitbox = $HeadHitbox #reference to the head hitbox
onready var eyehitbox = $EyeArea/EyeHitbox #reference to the eye hitbox
onready var boss_meter = get_node("/root/TestScene/PlayerHorizontal/HUDSide/BossBar") #this will need to be changed when testing

#hella explosion variables and references
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

#references to the bullet scenes and position nodes
export (PackedScene) var lightbullet
export (PackedScene) var darkbullet
export (PackedScene) var lightspiralbullet
export (PackedScene) var darkspiralbullet
onready var bulletfirepoint = $BulletFirePoint
#spiral bullet variables
var spiral_bullet_shot = false
var time_since_spiral_bullet_fired: float = 0
var spiral_bullet_cooldown: float = 2.5
var light_spiral = true
var spiral_bullet_count = 0

#arm references and variables
export (PackedScene) var arm

onready var armtimerfirstphase = $ArmTimerFirstPhase
var arm1_fired = false
var arm2_fired = false
var arm3_fired = false
var arm4_fired = false
var arm_cooldown: float = 1
var time_since_arm_fired: float = 0
var arm_speed: float = 200
var arm_attack_time_phase1: bool = false

#bullet stream variables and references
var time_since_bullet_fired: float = 0
var bullet_cooldown: float = 0.03 #how long between each bullet
onready var bulletstreamfirstphase = $BulletStreamFirstPhase
var time_to_shoot = false #when this is true, the boss will shoot the bullet stream
var start_angle = -60 #the angle at which the bullet stream will start
var end_angle = -120 #the angle at which the bullet stream will end
var angle_increment = 0.15 #how much the angle will increment by each time a bullet is fired
# var num_bullets = 200 #how many bullets will be fired in the bullet stream
onready var lightbulletspawner = $LightBulletSpawner
onready var lightbulletspawner2 = $LightBulletSpawner2
var light_timer_started = false 
var rotate_down_light = false #when this is true, the light bullet stream will rotate down
var rotate_up_light = false #when this is true, the light bullet stream will rotate up
onready var darkbulletspawner = $DarkBulletSpawner
onready var darkbulletspawner2 = $DarkBulletSpawner2

#fire platform variables and references
export (PackedScene) var fireplatform



func _ready():
	Game.boss_health = 2000
	boss_meter.visible = true # make the boss meter visible
	randomize() #randomize the random number generator

func _process(delta):
	
	if boss_arrived == true:
		shoot_spread_bullet(delta) #shoot the spiral bullet

	if Game.boss_health >= 1000:
		if boss_arrived == false:
			velocity = Vector2(-1,0)
			if position.x <= 1220:
				position.x = 1220
				boss_arrived = true

		elif boss_arrived == true:
			velocity = Vector2(0,0)

		if arm_attack_time_phase1 == true:
			arm_attack_phase1(delta)

		if time_to_shoot == true:
			shoot_phase1(delta)
			
	elif Game.boss_health < 1000:
		if begin_phase2 == false:
			reset_loop()
			begin_phase2 = true

	if begin_phase2 == true:
		
		if arm_attack_time_phase1 == true:
			arm_attack_phase1(delta)
		if time_to_shoot == true:
			shoot_phase1(delta)
			


	velocity.x = velocity.x * speed
	velocity.y = velocity.y * speed
	position += velocity * delta

func shoot_spread_bullet(delta):
	time_since_spiral_bullet_fired += delta

	if time_since_spiral_bullet_fired >= spiral_bullet_cooldown and spiral_bullet_shot == false:
	
		if spiral_bullet_count < 1: #if this is the first bullet
			#choose at random whether light_spiral is true or false, then fire the appropriate bullet
			light_spiral = randi() % 2 == 0
			
			if light_spiral:
				var lightspiralbullet_instance = lightspiralbullet.instance()
				lightspiralbullet_instance.global_position = bulletfirepoint.global_position
				lightspiralbullet_instance.speed = 200
				get_parent().add_child(lightspiralbullet_instance)
				lightspiralbullet_instance.set_bullet_direction(Vector2(-1,-0.5).normalized())
				spiral_bullet_count += 1
				light_spiral = false
			
			elif light_spiral == false:
				var darkspiralbullet_instance = darkspiralbullet.instance()
				darkspiralbullet_instance.global_position = bulletfirepoint.global_position
				darkspiralbullet_instance.speed = 200
				get_parent().add_child(darkspiralbullet_instance)
				darkspiralbullet_instance.set_bullet_direction(Vector2(-1,-0.5).normalized())
				spiral_bullet_count += 1
				light_spiral = true
			time_since_spiral_bullet_fired = 0
			anim_player.play("shoot")

		elif spiral_bullet_count >= 1: #if this is the second bullet
			
			if light_spiral and spiral_bullet_shot == false:
				var lightspiralbullet_instance = lightspiralbullet.instance()
				lightspiralbullet_instance.global_position = bulletfirepoint.global_position
				lightspiralbullet_instance.speed = 200
				get_parent().add_child(lightspiralbullet_instance)
				lightspiralbullet_instance.set_bullet_direction(Vector2(-1,0.5).normalized())
				spiral_bullet_count += 1
				spiral_bullet_shot = true
			
			elif light_spiral == false and spiral_bullet_shot == false:
				var darkspiralbullet_instance = darkspiralbullet.instance()
				darkspiralbullet_instance.global_position = bulletfirepoint.global_position
				darkspiralbullet_instance.speed = 200
				get_parent().add_child(darkspiralbullet_instance)
				darkspiralbullet_instance.set_bullet_direction(Vector2(-1,0.5).normalized())
				spiral_bullet_count += 1
				spiral_bullet_shot = true
			
			time_since_spiral_bullet_fired = 0
			anim_player.frame = 0
			anim_player.play("shoot")
			armtimerfirstphase.start()

func _on_ArmTimerFirstPhase_timeout():
	arm_attack_time_phase1 = true

func arm_attack_phase1(delta):
	time_since_arm_fired += delta
	
	if arm1_fired == false:
		#create an angle to fire the arm randomly between -155 and -187.5 degrees converted to radians
		var angle1 = deg2rad(rand_range(-155,-187.5))
		var arm1 = arm.instance()
		arm1.rotation = angle1
		get_tree().get_root().add_child(arm1)
		arm1_fired = true
		time_since_arm_fired = 0
		anim_player.frame = 0
		#play the animation but stop on frame 3 and stay there
		anim_player.play("shoot")
		anim_player.stop()
		anim_player.frame = 3

	elif arm1_fired == true and arm2_fired == false and time_since_arm_fired > arm_cooldown:
		var angle2 = deg2rad(rand_range(-25, 7.5))
		var arm2 = arm.instance()
		arm2.rotation = angle2
		arm2.set_position(Vector2(896,1616))
		get_tree().get_root().add_child(arm2)
		arm2_fired = true
		time_since_arm_fired = 0
		if begin_phase2 == false:
			bulletstreamfirstphase.start()

	elif arm1_fired == true and arm2_fired == true\
	and arm3_fired == false and time_since_arm_fired > arm_cooldown\
	and begin_phase2 == true:
		#create an angle to fire the arm randomly between -155 and -187.5 degrees converted to radians
		var angle3 = deg2rad(rand_range(-167.5,-187.5))
		var arm3 = arm.instance()
		arm3.rotation = angle3
		arm3.position.x = 300
		get_tree().get_root().add_child(arm3)
		arm3_fired = true
		time_since_arm_fired = 0

	elif arm1_fired == true and arm2_fired == true\
	and arm3_fired == true and arm4_fired == false\
	and time_since_arm_fired > arm_cooldown and begin_phase2 == true:
		var angle4 = deg2rad(rand_range(-25, -5))
		var arm4 = arm.instance()
		arm4.rotation = angle4
		arm4.set_position(Vector2(300,1616))
		get_tree().get_root().add_child(arm4)
		arm4_fired = true
		time_since_arm_fired = 0
		bulletstreamfirstphase.start()
		


func shoot_phase1(delta):
	time_since_bullet_fired += delta
	if light_timer_started == false:
		$BulletRotationTimer.start()
		light_timer_started = true
	
	if rotate_down_light == true:
		lightbulletspawner.rotate(deg2rad(-angle_increment))
		lightbulletspawner2.rotate(deg2rad(-angle_increment))
		darkbulletspawner.rotate(deg2rad(angle_increment))
		darkbulletspawner2.rotate(deg2rad(angle_increment))
		if lightbulletspawner.rotation <= deg2rad(-200):
			rotate_down_light = false
			rotate_up_light = true

	if rotate_up_light == true:
		lightbulletspawner.rotate(deg2rad(angle_increment))
		lightbulletspawner2.rotate(deg2rad(angle_increment))
		darkbulletspawner.rotate(deg2rad(-angle_increment))
		darkbulletspawner2.rotate(deg2rad(-angle_increment))
		if lightbulletspawner.rotation >= deg2rad(-155):
			rotate_up_light = false
			rotate_down_light = false
			time_to_shoot = false
			reset_loop() #reset the loop to start again

	if time_since_bullet_fired > bullet_cooldown:
		#light bullet section
		var bullet = lightbullet.instance()
		bullet.position = lightbulletspawner.position + Vector2(130,0)
		bullet.rotation = (lightbulletspawner.rotation - deg2rad(115))
		bullet.scale = Vector2(1.5,1.5)
		lightbulletspawner.add_child(bullet)
		bullet.set_bullet_speed_and_direction((Vector2(1,0)) * 800)
		#dark bullet section
		var bullet2 = darkbullet.instance()
		bullet2.position = darkbulletspawner.position + Vector2(130,0)
		bullet2.rotation = (darkbulletspawner.rotation - deg2rad(70))
		bullet2.scale = Vector2(1.5,1.5)
		darkbulletspawner.add_child(bullet2)
		bullet2.set_bullet_speed_and_direction((Vector2(1,0)) * 800)

		if begin_phase2 == true:
			#light bullet section
			var bullet3 = lightbullet.instance()
			bullet3.position = lightbulletspawner2.position + Vector2(130,0)
			bullet3.rotation = (lightbulletspawner2.rotation - deg2rad(100))
			bullet3.scale = Vector2(1.5,1.5)
			lightbulletspawner2.add_child(bullet3)
			bullet3.set_bullet_speed_and_direction((Vector2(1,0)) * 800)
			#dark bullet section
			var bullet4 = darkbullet.instance()
			bullet4.position = darkbulletspawner2.position + Vector2(130,0)
			bullet4.rotation = (darkbulletspawner2.rotation - deg2rad(85))
			bullet4.scale = Vector2(1.5,1.5)
			darkbulletspawner2.add_child(bullet4)
			bullet4.set_bullet_speed_and_direction((Vector2(1,0)) * 800)
		
		time_since_bullet_fired = 0
		anim_player.frame = 0
		anim_player.play("shoot")

func platform_fire():
	pass


		
func _on_BulletDelayTimer_timeout():
	start_angle -= angle_increment

func _on_BulletStreamFirstPhase_timeout():
	time_to_shoot = true

func _on_BulletRotationTimer_timeout():
	rotate_down_light = true

func reset_loop():
	spiral_bullet_shot = false
	spiral_bullet_count = 0
	light_spiral = true
	light_timer_started = false
	rotate_down_light = false
	rotate_up_light = false
	time_to_shoot = false
	arm1_fired = false
	arm2_fired = false
	arm3_fired = false
	arm4_fired = false
	arm_attack_time_phase1 = false
	
func _on_EyeArea_area_entered(area:Area2D):
		
	if area.collision_layer == 2:
		self.take_damage(2)
		flash.play("flash")
		
	if area.collision_layer == 4:
		self.take_damage(2)
		flash.play("flash")

	if area.collision_layer == 64:
		self.take_damage(Game.super_beam_damage_modifier * 0.7)
		flash.play("flash")

	if area.collision_layer == 128:
		self.take_damage(Game.super_beam_damage_modifier * 0.7)
		flash.play("flash")

func _on_Flopilot_body_entered(body: Node):
	body.take_damage() 

func take_damage(damage):
	Game.boss_health -= damage
	if Game.boss_health <= 0 and scored == false:
		Game.score += 30000
		scored = true
		headhitbox.set_deferred("disabled", true) #disable the collision shape
		eyehitbox.set_deferred("disabled", true)
		explosion_sound.play()
		explosion1.visible = true
		explosion1.play("explosion")
		explosion1_fade.play("fade")




