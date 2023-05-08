extends TextureRect

onready var music = $AudioStreamPlayer
onready var fadeout = get_node("Fadeout")

func _ready():
	#stop the game
	get_tree().paused = true
	music.play()

func _on_Timer_timeout():
	# var level1 = get_node("/root")
	fadeout.get_node("AnimationPlayer").play("Fadeout")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
	if error != OK:
		print("Error: ", error)
	# level1.queue_free() #remove the level1 scene
	self.queue_free()

	
