extends Node2D

onready var level_music = $AudioStreamPlayer
onready var boss_music = $BossMusic
var tween = Tween.new()

func _on_2D1Timer_timeout():
	var enemy2D1 = load("res://Levels/Level1paths/Path2D1.tscn").instance()
	get_tree().get_root().add_child(enemy2D1)
	$"2D1Timer".queue_free()

func _on_2D2Timer_timeout():
	var enemy2D2 = load("res://Levels/Level1paths/Path2D2.tscn").instance()
	get_tree().get_root().add_child(enemy2D2)
	$"2D2Timer".queue_free()
	
func _on_2D3Timer_timeout():
	var enemy2D3 = load("res://Levels/Level1paths/Path2D3.tscn").instance()
	get_tree().get_root().add_child(enemy2D3)
	$"2D3Timer".queue_free()

func _on_2D4Timer_timeout():
	var enemy2D4 = load("res://Levels/Level1paths/Path2D4.tscn").instance()
	get_tree().get_root().add_child(enemy2D4)
	$"2D4Timer".queue_free()

func _on_2D5Timer_timeout():
	var enemy2D5 = load("res://Levels/Level1paths/Path2D5.tscn").instance()
	get_tree().get_root().add_child(enemy2D5)
	$"2D5Timer".queue_free()

func _on_2D6Timer_timeout():
	var enemy2D6 = load("res://Levels/Level1paths/Path2D6.tscn").instance()
	get_tree().get_root().add_child(enemy2D6)
	$"2D6Timer".queue_free()

func _on_2D7Timer_timeout():
	var enemy2D7 = load("res://Levels/Level1paths/Path2D7.tscn").instance()
	get_tree().get_root().add_child(enemy2D7)
	$"2D7Timer".queue_free()

func _on_2D8Timer_timeout():
	var enemy2D8 = load("res://Levels/Level1paths/Path2D8.tscn").instance()
	get_tree().get_root().add_child(enemy2D8)
	$"2D8Timer".queue_free()

func _on_RandomSpawner1Timer_timeout():
	var randomSpawner1 = load("res://Levels/Level1paths/RandomSpawner1.tscn").instance()
	get_tree().get_root().add_child(randomSpawner1)
	$"RandomSpawner1Timer".queue_free()

func _on_2D1LightTimer_timeout():
	var enemy2D1Light = load("res://Levels/Level1paths/Path2D1Light.tscn").instance()
	get_tree().get_root().add_child(enemy2D1Light)
	$"2D1LightTimer".queue_free()

func _on_2D2DarkTimer_timeout():
	var enemy2D2Dark = load("res://Levels/Level1paths/Path2D2Dark.tscn").instance()
	get_tree().get_root().add_child(enemy2D2Dark)
	$"2D2DarkTimer".queue_free()

func _on_2D3LightTimer_timeout():
	var enemy2D3Light = load("res://Levels/Level1paths/Path2D3Light.tscn").instance()
	get_tree().get_root().add_child(enemy2D3Light)
	$"2D3LightTimer".queue_free()

func _on_2D4DarkTimer_timeout():
	var enemy2D4Dark = load("res://Levels/Level1paths/Path2D4Dark.tscn").instance()
	get_tree().get_root().add_child(enemy2D4Dark)
	$"2D4DarkTimer".queue_free()

func _on_2D5LightTimer_timeout():
	var enemy2D5Light = load("res://Levels/Level1paths/Path2D5Light.tscn").instance()
	get_tree().get_root().add_child(enemy2D5Light)
	$"2D5LightTimer".queue_free()

func _on_2D6DarkTimer_timeout():
	var enemy2D6Dark = load("res://Levels/Level1paths/Path2D6Dark.tscn").instance()
	get_tree().get_root().add_child(enemy2D6Dark)
	$"2D6DarkTimer".queue_free()

func _on_2D7DarkTimer_timeout():
	var enemy2D7Dark = load("res://Levels/Level1paths/Path2D7Dark.tscn").instance()
	get_tree().get_root().add_child(enemy2D7Dark)
	$"2D7DarkTimer".queue_free()

func _on_2D8LightTimer_timeout():
	var enemy2D8Light = load("res://Levels/Level1paths/Path2D8Light.tscn").instance()
	get_tree().get_root().add_child(enemy2D8Light)
	$"2D8LightTimer".queue_free()

func _on_RandomSpawnerDarkTimer_timeout():
	var randomSpawnerDark = load("res://Levels/Level1paths/RandomSpawnerDark.tscn").instance()
	get_tree().get_root().add_child(randomSpawnerDark)
	$"RandomSpawnerDarkTimer".queue_free()

func _on_RandomSpawnerLight_timeout():
	var randomSpawnerLight = load("res://Levels/Level1paths/RandomSpawnerLight.tscn").instance()
	get_tree().get_root().add_child(randomSpawnerLight)
	$"RandomSpawnerLight".queue_free()

func _on_LightTankTimer1_timeout():
	var lightTank1 = load("res://Enemies/LightTankSpawner.tscn").instance()
	get_tree().get_root().add_child(lightTank1)
	$"LightTankTimer1".queue_free()
	
func _on_DarkTankTimer1_timeout():
	var darkTank1 = load("res://Enemies/DarkTankSpawner.tscn").instance()
	get_tree().get_root().add_child(darkTank1)
	$"DarkTankTimer1".queue_free()

func _on_DarkShipTimer1_timeout():
	var darkShip1 = load("res://Enemies/FloppaDarkShip.tscn").instance()
	get_tree().get_root().add_child(darkShip1)
	darkShip1.position.x = 640
	darkShip1.position.y = -110 
	$"DarkShipTimer1".queue_free()

func _on_LightShipTimer2_timeout():
	var lightShip2 = load("res://Enemies/FloppaLightShip.tscn").instance()
	get_tree().get_root().add_child(lightShip2)
	lightShip2.position.x = 640
	lightShip2.position.y = -110 
	$"LightShipTimer2".queue_free()

func _on_DualShipTimer1_timeout():
	var lightShip3 = load("res://Enemies/FloppaLightShip.tscn").instance()
	var darkShip3 = load("res://Enemies/FloppaDarkShip.tscn").instance()
	get_tree().get_root().add_child(lightShip3)
	get_tree().get_root().add_child(darkShip3)
	lightShip3.position.x = 320
	lightShip3.position.y = -110 
	darkShip3.position.x = 960
	darkShip3.position.y = -110
	$"DualShipTimer1".queue_free()

func _on_DualShipTimer2_timeout():
	var lightShip4 = load("res://Enemies/FloppaLightShip.tscn").instance()
	var darkShip4 = load("res://Enemies/FloppaDarkShip.tscn").instance()
	get_tree().get_root().add_child(lightShip4)
	get_tree().get_root().add_child(darkShip4)
	lightShip4.position.x = 960
	lightShip4.position.y = -110 
	darkShip4.position.x = 320
	darkShip4.position.y = -110
	$"DualShipTimer2".queue_free()

func _on_BeamShipTimer_timeout():
	var lightbeamShip = load("res://Enemies/LightBeamShip.tscn").instance()
	var darkbeamShip = load("res://Enemies/DarkBeamShip.tscn").instance()
	get_tree().get_root().add_child(lightbeamShip)
	get_tree().get_root().add_child(darkbeamShip)
	lightbeamShip.position.x = 150
	lightbeamShip.position.y = -100
	darkbeamShip.position.x = 1130
	darkbeamShip.position.y = -100
	$"BeamShipTimer".queue_free()

func _on_BossTimer_timeout():
	var boss = load("res://Bosses/JetPackFloppa.tscn").instance()
	get_tree().get_root().add_child(boss)
	get_tree().get_root().add_child(tween) # add the tween to the scene tree
	tween.interpolate_property(level_music, "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start() # start the tween
	yield(tween, "tween_completed")
	boss_music.play()
	$"BossTimer".queue_free()


