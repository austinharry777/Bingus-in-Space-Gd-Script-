extends Area2D

onready var anim_player = $AnimatedSprite
onready var explosion_fade = $AnimatedSprite/AnimationPlayer
onready var animation = $AnimatedSprite.get_animation()
onready var collisionshape = $CollisionPolygon2D
var scored = false
onready var explosion_sound = $AudioStreamPlayer

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

func _on_FloppaDrone_area_entered(_area:Area2D):
	if scored == false:
		Game.score += 200
		scored = true
	self.speed = 0 #stop the floppa drone
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