extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var rng = RandomNumberGenerator.new()
var rand

onready var player = get_parent().get_node("Space/Player")
const EXPLOSION2 = preload("res://Effects/ParticleExplosion2.tscn")
onready var completion = get_parent().get_node("Space/Completion/Message")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sound.play()
	add_to_group("mobs")
	set_process(true)
	rng.randomize()
	rand = rng.randf_range(-0.2, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):

	# ...
	# look at
	# ...

	# You need an angle rotated 90 degrees,
	# because look_at considers that an angle of 0 is pointing up, not right.
	# (Adjust it if it's wrong in your case, depends on how your sprite looks)
	#var angle = get_rotation()
	# Define some speed
	

	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	var dir = - get_transform().x
	dir.x += rand
	dir.y += rand
	# Move
	set_position(get_position() + dir * (speed * delta))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	


func _on_EnemyFrbl_body_entered(body):
	if body.name == "Player":
		global.current_hull -= 1
		#hull._on_health_updated(global.current_hull)
		var coords = get_position() 
		queue_free() # Replace with function body.
		#var explosion = EXPLOSION.instance()
		#get_parent().add_child(explosion)
		#explosion.get_child(0).emitting = true
		#explosion.set_position(Vector2(coords))
		if global.current_hull <= 0:
			
			global.death(player.roundSpacecoin)
			
			body.queue_free()
			var explosion2 = EXPLOSION2.instance()
			get_parent().add_child(explosion2)
			explosion2.get_child(0).emitting = true
			explosion2.set_position(Vector2(coords))
			#get_tree().change_scene("res://Hangar.tscn")
			completion.text = "Fractured by a Fireball\nYou lost " + String(player.roundSpacecoin) + " Spacecoin\nYou lost "+String(global.experienceLost)+" experience"
			completion.visible = true
			player.chargeTimer.stop()
			player.shootTimer.stop()
			#print(global.dead)
