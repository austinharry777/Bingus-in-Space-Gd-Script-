extends PathFollow2D

var speed: int = 700

func _process(delta):
    set_offset(get_offset() + speed * delta)
    if(loop == false and get_unit_offset() == 1):
        queue_free()