extends Path2D

var timer = 0
var spawn_timer = 0.3
var follower = preload("res://Levels/Level1paths/PathFollow2D5Light.tscn")
var spawn_count = 0
var all_spawned = false

func _process(delta):
    if spawn_count >= 14:
        all_spawned = true

    timer = timer + delta

    if timer > spawn_timer and all_spawned == false:
        var new_follower = follower.instance()
        add_child(new_follower)
        spawn_count += 1
        timer = 0

func _on_KillTimer_timeout():
	queue_free() # kill the path