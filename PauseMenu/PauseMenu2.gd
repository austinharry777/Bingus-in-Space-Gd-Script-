extends CanvasLayer

onready var fadeout = $TextureRect/Fadeout
onready var player = get_node("/root/Base1/PlayerHorizontal")
var exited_game = false

func _ready():
	# Pause the game
	get_tree().paused = true
	$TextureRect/Control/VBoxContainer/Return.grab_focus()

func _process(_delta):
	# If the player presses escape, unpause the game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = false
		queue_free() # Delete the pause menu
		player.is_paused = false
		
	#if the player presses "p", unpause the game
	if Input.is_action_just_released("pause_game"):
		get_tree().paused = false
		queue_free() # Delete the pause menu
		player.is_paused = false

func _on_BackToTitle_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if exited_game == false:
		exited_game = true
		fadeout.visible = true
		fadeout.get_node("AnimationPlayer").play("fadeout")
		yield(get_tree().create_timer(2), "timeout")
		# Resume the game
		get_tree().paused = false
		reset_player_variables()
		stop_all_timers()
		delete_all_enemies()
		var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
		if error != OK:
			print("Error: ", error)
		queue_free() # Delete the pause menu

func _on_Return_pressed():
	get_tree().paused = false
	queue_free() # Delete the pause menu
	player.is_paused = false
	

func stop_all_timers():
	var timerobject_parent = get_node("/root/Base1/Level2ObjectTimers") 
	for child in timerobject_parent.get_children():
		if child is Timer:
			child.queue_free() 
	var timerenemy_parent = get_node("/root/Base1/Level2EnemyTimers") 
	for child in timerenemy_parent.get_children():
		if child is Timer:
			child.queue_free()
	var timerpath_parent = get_node("/root/Base1/Level2PathTimers") 
	for child in timerpath_parent.get_children():
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

