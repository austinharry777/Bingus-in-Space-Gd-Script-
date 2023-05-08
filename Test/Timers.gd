extends Node2D



func _on_JetPackFfloppa_timeout():
	
	var boss = load("res://Bosses/JetPackFloppa.tscn").instance()
	get_tree().get_root().add_child(boss)
	$JetPackFfloppa.queue_free()
