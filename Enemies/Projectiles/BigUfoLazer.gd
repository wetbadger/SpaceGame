extends Area2D
#this is named Lazer with a z because area.name would be the same as player's "laser"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const EXPLOSION2 = preload("../../Effects/ParticleExplosion2.tscn")
onready var player = get_parent().get_node("Space/Player")
onready var completion = get_parent().get_node("Space/Completion/Message")
#onready var hull = get_parent().get_node("Space/Hull/Healthbar")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sound.play()
	add_to_group("mobs")
	set_process(true)

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
	var angle = get_rotation()
	# Define some speed
	var speed = 300

	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	var dir = - get_transform().x

	# Move
	set_position(get_position() + dir * (speed * delta))


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BULazer_body_entered(body):
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
			completion.text = "Lacerated by a Laser\nYou lost " + String(player.roundSpacecoin) + " Spacecoin\nYou lost "+String(global.experienceLost)+" experience"
			completion.visible = true
			player.chargeTimer.stop()
			player.shootTimer.stop()
			#print(global.dead)
