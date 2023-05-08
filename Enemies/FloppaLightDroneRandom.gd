extends Area2D

onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var flash = $AnimatedSprite/AnimationPlayer2
onready var animation = $AnimatedSprite.get_animation()
onready var collisionshape = $CollisionPolygon2D
var scored: bool = false
onready var explosion_sound = $AudioStreamPlayer
var health: int = 8 #health of the floppa drone

#randomize attributes
var speed = int(rand_range(200, 800))
var start_rotation = int(rand_range(0, 360))
var size = rand_range(0.5, 1.5)
var direction = Vector2.DOWN
var random_rotation 

func _ready():
	randomize() 
	self.scale = Vector2(size, size)
	self.rotation_degrees = start_rotation
	random_rotation = rand_range(-100, 100)
	var random_angle = rand_range(-20, 20)
	direction = Vector2(cos(random_angle), 1).normalized()

func _process(delta):
	#move the floppa drone
	position += direction * speed * delta
	#rotate the floppa drone
	rotation_degrees += random_rotation * delta
	free_self()

func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "fade":
		self.queue_free()

func _on_AnimatedSprite_animation_finished():
	if animation == "explosion": 
		self.queue_free()

func free_self():
	if position.y > 1000:
		self.queue_free()

func take_damage(damage):
	health -= damage
	if health <= 0 and scored == false:
		Game.score += 200
		scored = true
		self.speed = 0 #stop the floppa drone
		collisionshape.set_deferred("disabled", true) #disable the collision shape
		explosion_sound.play()
		anim_player.play("explosion")
		explosion_fade.play("fade")

func _on_FloppaDrone_area_entered(area: Area2D):
	if area.collision_layer == 2:
		self.take_damage(1)
		flash.play("Flash")
		
	if area.collision_layer == 4:
		self.take_damage(8)

	if area.collision_layer == 64:
		self.take_damage(Game.super_beam_damage_modifier *1)
		flash.play("Flash")

	if area.collision_layer == 128:
		self.take_damage(Game.super_beam_damage_modifier *2)
		flash.play("Flash")

func _on_FloppaDrone_body_entered(body: Node):
	body.take_damage()



