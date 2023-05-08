extends Node2D

onready var bar = $TextureProgress #the progress bar
onready var anim_player = $TextureProgress/AnimationPlayer #the animation player

func _process(_delta):
	if bar.value >= 100:
		anim_player.play("flash")
	else:
		anim_player.stop(true) #stop the animation
		anim_player.play("RESET")  
		
 
