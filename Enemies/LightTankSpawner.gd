extends Node2D

var timer = 0
var spawn_timer = 2
var spawn_count = 0
var all_spawned = false
onready var enemy = preload("res://Enemies/LightTank.tscn")


func _process(delta):
	
	if spawn_count >= 15:
		all_spawned = true

	timer = timer + delta

	if timer > spawn_timer and all_spawned == false:
		var new_enemy = enemy.instance()
		add_child(new_enemy)
		spawn_count += 1
		timer = 0
		if spawn_count >= 7:
			new_enemy.bullet_cooldown = 0.2
			
func _on_KillTimer_timeout():
	queue_free() # Delete the node


