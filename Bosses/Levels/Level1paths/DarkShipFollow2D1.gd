extends PathFollow2D

var max_speed: int = 350
var slow_distance: int = 50
var stop_distance: int = 20
export var stop_point: Vector2

func _process(delta):
    # Calculate the distance between the sprite and the stop point
    var distance = (stop_point - get_global_position()).length()

    # Calculate the speed of the sprite based on the distance to the stop point
    var speed = lerp(max_speed, 0, distance / slow_distance)

    # Set the speed of the sprite
    set_offset(get_offset() + speed * delta)

    # #Stop the sprite when it reaches the stop point
    if distance < stop_distance:
        set_offset(get_offset())



    