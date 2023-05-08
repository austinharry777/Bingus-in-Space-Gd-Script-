extends Node2D

var timer = 0
var spawn_timer = 0.1
var spawn_count = 0
var all_spawned = false
var speed 
var x_pos
var y_pos
onready var enemy = preload("res://Enemies/FloppaLightDroneRandom.tscn")

func _process(delta):
	randomize() 
	x_pos = rand_range(420, 860)
	y_pos = -150
	if spawn_count >= 50:
		all_spawned = true

	timer = timer + delta

	if timer > spawn_timer and all_spawned == false:
		var new_enemy = enemy.instance()
		new_enemy.position = Vector2(x_pos, y_pos)
		add_child(new_enemy)
		spawn_count += 1
		timer = 0

func _on_KillTimer_timeout():
	queue_free() # Delete the node