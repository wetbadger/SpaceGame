extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var ACCELERATION = 50
#const FIREBALL_SPEED = 550

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sound.play()
	set_process(true) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	var speed_x = 0
#	var speed_y = -1
#	var motion = Vector2(speed_x, speed_y) * ACCELERATION
#	if ACCELERATION < FIREBALL_SPEED:
#		ACCELERATION += 1
#	set_position(get_position() + motion * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.


func _on_Missile_area_entered(area):
	if "UFO" in area.name or "SpaceShip" in area.name:
		queue_free() # Replace with function body.
