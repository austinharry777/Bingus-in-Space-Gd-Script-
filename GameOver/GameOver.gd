extends TextureRect

onready var timer = $Timer
onready var fadeout = get_node("Fadeout")
onready var tween = $Tween
onready var music = get_node("/root/Earth/EarthSpawnTimers/GameOverMusic")
onready var button_press = $ButtonPress

func _ready():
	# Stop the game
	get_tree().paused = true
	#play the music
	music.play() 
	
func _process(_delta): 
	if Input.is_action_just_pressed("left_click"):
		tween.interpolate_property(music, "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start() # start the tween 
		fadeout.get_node("AnimationPlayer").play("Fadeout")
		yield(get_tree().create_timer(2), "timeout")
		var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
		if error != OK:
			print("Error: ", error)

func _on_Timer_timeout():
	fadeout.get_node("AnimationPlayer").play("Fadeout")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	reset_player_variables()
	stop_all_timers()
	delete_all_enemies()
	var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
	if error != OK:
		print("Error: ", error)
	self.queue_free()

func stop_all_timers():
	var timer_parent = get_node("/root/Earth/EarthSpawnTimers") 
	for child in timer_parent.get_children():
		if child is Timer:
			child.queue_free() 

func delete_all_enemies():
	var enemy_parent = get_node("/root")
	for child in enemy_parent.get_children():
		if child is Path2D or child is Area2D or child is Node2D:
			child.queue_free()
			

func reset_player_variables():
	Game.lives = 3
	Game.score = 0
	Game.meter = 0 

func _on_ButtonPress_timeout():
	button_press.queue_free()
	tween.interpolate_property(music, "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start() # start the tween
	fadeout.get_node("AnimationPlayer").play("Fadeout")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	reset_player_variables()
	stop_all_timers()
	delete_all_enemies()
	var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
	if error != OK:
		print("Error: ", error)
	self.queue_free()



