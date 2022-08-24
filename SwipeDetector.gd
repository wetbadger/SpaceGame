extends Timer


signal swiped(direction)
signal swiped_canceled(start_position)

export(float, 1.0, 1.5) var MAX_DIAGONAL_SLOPE = 1.3

onready var timer = self
var swipe_start_position = Vector2()


# Called when the node enters the scene tree for the first time.
func _input(event): # Replace with function body.
	if not event is InputEventScreenTouch:
		return
	if event.pressed and event.position.y < 650:
		_start_detection(event.position)
	elif not timer.is_stopped():
		_end_detection(event.position)
		
func _start_detection(position):
	swipe_start_position = position
	timer.start()
	
func _end_detection(position):
	timer.stop()
	var direction = (position - swipe_start_position).normalized()
	if abs(direction.x) + abs(direction.y) >= MAX_DIAGONAL_SLOPE:
		return
	
	if abs(direction.x) > abs(direction.y):
		emit_signal('swiped', Vector2(-sign(direction.x), 0.0))
	else:
		emit_signal('swiped', Vector2(0.0, -sign(direction.y)))
	
func _on_Timer_timeout():
	emit_signal('swiped_canceled', swipe_start_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
