extends KinematicBody2D

var speed: int = 450 #speed of the player
onready var tilt_player = $ShiptiltAnimation #player animation
export (PackedScene) var Bullet
export (PackedScene) var DarkBullet
export (PackedScene) var SuperBeam 
export (PackedScene) var SuperBeamHead
export (PackedScene) var SuperBeamDark 
export (PackedScene) var SuperBeamDarkHead



#Firing position of the guns
onready var left_gun = $LeftGun
onready var right_gun = $RightGun
onready var superbeampos = $SuperBeamPos

#dash animations and timers
onready var dash_flash = $ShiptiltAnimation/DashFlash #dash flash animation
onready var bingus_dash = $BingusDash
onready var dash_fade = $BingusDash/AnimationPlayer
onready var dash_timer = $DashTimer #refractory period for dash
var dash = false #true = dash, false = no dash

#refractory periods for shooting
var time_since_bullet_fired: float = 0
var time_since_superbeam_fired: float = 0
onready var superbeam_timer = $SuperBeamTimer
onready var superbeam_body_timer = $SuperBeamDelay 
var superbeam_fired = false
var superbeam_head = false
var superbeam_body_fire = false
var bullet_cooldown: float = 0.06 #seconds
var superbeam_cooldown: float = 0.008 #seconds
onready var gunflash = $GunFlash #gun flash animation

#color change mechanics and timers
var time_since_color_change: float = 0
var color_cooldown: float = 0.3 #seconds
var light_color = true #true = light, false = dark

#for screen constraints
const screen_height: int = 720
const screen_width: int  = 1280 
const player_width: int = 70
const player_height: int = 60 

#variable for no movement during launch
var launch = false 

#reference to afterburner animation
onready var afterburner = $AfterburnerAnimation

#reference to player ship explosion animation and bool for animations
onready var player_explosion = $ShiptiltAnimation/ShipExplosionFade
onready var explosion_sound = $ExplosionSound
var player_exploded = false

#invulnerability timer after death and flash animation
onready var invulnerable_flash = $ShiptiltAnimation/InvulnerableFlash
var is_vulnerable = true
var is_returning = false

#bool for making cursor appear when game is paused
var is_paused = false

func _ready():
	# Hide the mouse cursor for the entire game window
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _process(delta):
	#for rehiding the cursor after unpausing
	if not is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	time_since_color_change += delta
	time_since_bullet_fired += delta
	time_since_superbeam_fired += delta
	
	var velocity = Vector2()

	if is_returning == true:
		velocity.y -= 1
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
		if self.position.y <= 460:
			velocity.y = 0
			is_returning = false
			$IsVulnerableTimer.start()
			player_exploded = false
			bingus_dash.visible = true
		
	if launch == true and player_exploded == false:
		#screen constraints
		self.position.x = clamp(self.position.x, player_width / 2.0, screen_width - player_width / 2.0)
		self.position.y = clamp(self.position.y, player_height, screen_height - player_height / 2.0)
		
		if Input.is_action_pressed("shoot") and time_since_bullet_fired > bullet_cooldown:
			shoot() #shoot a bullet
			time_since_bullet_fired = 0 #reset the timer
		
		if Input.is_action_just_pressed("color_change") and time_since_color_change > color_cooldown:
			light_color = !light_color
			time_since_color_change = 0 
		
		if Input.is_action_just_pressed("superbeam") and superbeam_head == false:
			superbeam_head = true
			superbeamhead() #shoot a superbeam head
			superbeam_body_timer.start() #start the timer for the body
			
		if Input.is_action_just_pressed("superbeam"): 
			superbeam_fired = true
			superbeam_timer.start()

		if superbeam_fired == true and superbeam_body_fire == true:	
			if time_since_superbeam_fired > superbeam_cooldown:
				superbeam() #shoot a superbeam
				time_since_superbeam_fired = 0 #reset the timer
				
		if Input.is_action_just_pressed("dash") and Game.meter > 5 and dash_timer.is_stopped():
			dash = true
			is_vulnerable = false
			Game.meter -= 5
			dash_timer.start()

		if dash == true:
			speed = 1200
			bingus_dash.emitting = true
			dash_fade.play("dashfade")
			dash_flash.play("dashflash")
		else:
			speed = 450
			bingus_dash.emitting = false

		#pause game
		if Input.is_action_just_released("pause_game"):
			pause_game() #pause the game
			is_paused = true #make cursor visible

		#movement
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
		shiptilt_animation(velocity)
		shield() #shield animation
		bingus_dash.visible = true
		bingus_dash.direction = -velocity #bingus dash animation
		bingus_dash.initial_velocity = 300
		if velocity.x == 0 and velocity.y == 0:
			bingus_dash.initial_velocity = 0 

	#kill the bullet from memory when it goes off screen
	for bullet in get_parent().get_children():
		if bullet.position.y < 0:
			bullet.queue_free()

	#kill the superbeam from memory when it goes off screen
	for superbeam in get_parent().get_children():
		if superbeam.position.y < 0:
			superbeam.queue_free()

func shiptilt_animation(velocity):
	
	if player_exploded == false:
		
		var current_frame = tilt_player.get_frame()
		if light_color == true:
		
			if velocity.x > 0:
				tilt_player.flip_h = false
				tilt_player.play("shiptiltright")
				yield(tilt_player, "animation_finished") #wait for the animation to finish
				tilt_player.set_frame(4) #stay at the last frame of the animation
				
			elif velocity.x < 0:
				tilt_player.flip_h = true
				tilt_player.play("shiptiltright")
				yield(tilt_player, "animation_finished") #wait for the animation to finish
				tilt_player.set_frame(4) #stay at the last frame of the animation
				
			elif velocity.x == 0:
				if current_frame > 0: 
					tilt_player.play("shiptiltreverse")
					# tilt_player.set_frame(0)
					yield(tilt_player, "animation_finished") #wait for the animation to finish
					tilt_player.frame = 4
					tilt_player.stop()  #reset the animation to the first frame
				else:
					tilt_player.frame = 0 #reset the animation to the first frame
		else:
			if velocity.x > 0:
				tilt_player.flip_h = false
				tilt_player.play("darkshiptiltright")
				yield(tilt_player, "animation_finished") #wait for the animation to finish
				tilt_player.set_frame(4) #stay at the last frame of the animation
				
			elif velocity.x < 0:
				tilt_player.flip_h = true
				tilt_player.play("darkshiptiltright")
				yield(tilt_player, "animation_finished") #wait for the animation to finish
				tilt_player.set_frame(4) #stay at the last frame of the animation
				
			elif velocity.x == 0:
				if current_frame > 0: 
					tilt_player.play("darkshiptiltreverse")
					# tilt_player.set_frame(0)
					yield(tilt_player, "animation_finished") #wait for the animation to finish
					tilt_player.frame = 4
					tilt_player.stop()  #reset the animation to the first frame
				else:
					tilt_player.play("darkshiptiltreverse")
					tilt_player.frame = 0 #reset the animation to the first frame

func shoot():
	if light_color == true:
		var bullet = Bullet.instance()
		var bullet2 = Bullet.instance()
		get_parent().add_child(bullet)
		get_parent().add_child(bullet2)
		bullet.global_position = left_gun.global_position
		bullet2.global_position = right_gun.global_position 
		gunflash.play("gunflash")
		yield(gunflash, "animation_finished")
		gunflash.set_frame(0)
	else:
		var bullet = DarkBullet.instance()
		var bullet2 = DarkBullet.instance()
		get_parent().add_child(bullet)
		get_parent().add_child(bullet2)
		bullet.global_position = left_gun.global_position
		bullet2.global_position = right_gun.global_position 
		gunflash.play("darkgunflash")
		yield(gunflash, "animation_finished")
		gunflash.set_frame(0)

func superbeam():
	if light_color == true and Game.meter > 3:
		var superbeam = SuperBeam.instance()
		get_parent().add_child(superbeam)
		superbeam.global_position = superbeampos.global_position
		Game.meter -= 3
		
	elif light_color == false and Game.meter > 3:
		var superbeam = SuperBeamDark.instance()
		get_parent().add_child(superbeam)
		superbeam.global_position = superbeampos.global_position
		Game.meter -= 3

func superbeamhead():
	if light_color == true and Game.meter > 3:
		Game.super_beam_damage_modifier = int(floor(float(Game.meter) / 3.0))
		var superbeamhead = SuperBeamHead.instance()
		get_parent().add_child(superbeamhead)
		superbeamhead.global_position = superbeampos.global_position
		Game.meter -= 3
		
	elif light_color == false and Game.meter > 3:
		Game.super_beam_damage_modifier = int(floor(float(Game.meter) / 3.0))
		var superbeamhead = SuperBeamDarkHead.instance()
		get_parent().add_child(superbeamhead)
		superbeamhead.global_position = superbeampos.global_position
		Game.meter -= 3

func shield():
	if player_exploded == false:
		$Shield.visible = true
		
		if light_color == true:
			$Shield.play("lightshield")
			yield($Shield, "animation_finished")
			$Shield.set_frame(4)
		else:
			$Shield.play("darkshield")
			yield($Shield, "animation_finished")
			$Shield.set_frame(4)
	
func take_damage():
	if is_vulnerable == true:
		Game.lives -= 1
		is_vulnerable = false
		player_exploded = true
		
		#make all sprites invisible
		$Shield.visible = false
		bingus_dash.visible = false
		
		#play the explosion animation
		explosion_sound.play()
		tilt_player.play("shipexplosion")
		player_explosion.play("shipexplosionfade") #decreas the alpha of the explosion
		yield(tilt_player, "animation_finished")
		if Game.lives == 0:
			game_over()
		
		#reset the animation to the first frame
		tilt_player.set_frame(0)
		player_explosion.seek(0, true)
		player_explosion.stop() 
		
		#reset the player to below the screen, and make sprites visible again
		#we will move the player back to the center of the screen in the _process function
		self.position.x = 640
		self.position.y = 900
		invulnerable_flash.play("invulnerableflash")
		if light_color == true:
			tilt_player.play("shiptiltreverse")
			tilt_player.frame = 4
			tilt_player.stop()  #reset the animation to the first frame
		else:
			tilt_player.play("darkshiptiltreverse")
			tilt_player.frame = 4
			tilt_player.stop()  #reset the animation to the first frame
		
		is_returning = true #start the return to the center of the screen

func absorb_hit_light(amount):
	if light_color:
		Game.meter += amount
		if Game.meter >= 100:
			Game.meter = 100
	else:
		self.take_damage()

func absorb_hit_dark(amount):
	if light_color:
		self.take_damage()
	else:
		Game.meter += amount
		if Game.meter >= 100:
			Game.meter = 100

func game_over():
	# Show the Game Over screen
	var game_over_screen = load("res://GameOver/GameOverCanvas.tscn").instance()
	get_tree().get_root().add_child(game_over_screen)
		
func fill_meter(amount):
	Game.meter += amount

func add_score(amount):
	Game.score += amount

func pause_game():
	# Show the Pause screen
	var pause_screen = load("res://PauseMenu/PauseMenu.tscn").instance()
	get_tree().get_root().add_child(pause_screen)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


#signals from the timers and animations 

func _on_SuperBeamTimer_timeout():
	superbeam_fired = false
	superbeam_head = false
	superbeam_body_fire = false
	Game.super_beam_damage_modifier = 1
	
func _on_DashTimer_timeout():
	dash = false
	is_vulnerable = true

func _on_AnimationPlayer_animation_finished(_anim_name:String):
	dash_fade.stop()
	dash_fade.current_animation = "" #reset the animation to the first frame

func _on_LaunchTimer_timeout():
	launch = true #Mission begins!
	bingus_dash.visible = true
	afterburner.queue_free() #remove the afterburner animation

func _on_DashFlash_animation_finished(_anim_name:String):
	dash_flash.stop()
	dash_flash.current_animation = "" #reset the animation to the first frame

func _on_AfterburnerTimer_timeout():
	afterburner.visible = true
	afterburner.play("afterburner") #play the afterburner animation

func _on_IsVulnerableTimer_timeout():
	is_vulnerable = true
	
func _on_InvulnerableFlash_animation_finished(_anim_name:String):
	invulnerable_flash.stop()
	invulnerable_flash.current_animation = "" #reset the animation to the first frame

func _on_SuperBeamDelay_timeout():
	superbeam_body_fire = true




