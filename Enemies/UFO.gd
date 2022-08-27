extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
var spin = RandomNumberGenerator.new()
var x_axis = 0
onready var player = get_parent().get_node("Space/Player")
onready var spacecoinLabel = get_parent().get_node("Space/Canvas/Sidebar/SpaceCoin")
onready var levelLabel = get_parent().get_node("Space/Canvas/Sidebar/Level")
onready var experienceLabel = get_parent().get_node("Space/Canvas/Sidebar/Experience")
onready var completion = get_parent().get_node("Space/Completion/Message")
#onready var hull = get_parent().get_node("Space/Hull/Healthbar")
const EXPLOSION = preload("../Effects/ParticleExplosion.tscn")
const EXPLOSION2 = preload("../Effects/ParticleExplosion2.tscn")

var ufo_speed = RandomNumberGenerator.new()
var speed = 40
# Called when the node enters the scene tree for the first time.
var speed_y = 0.5
var health = 2

func _ready():
	add_to_group("mobs")
	rng.randomize()
	ufo_speed.randomize()
	spin.randomize()
	spin = spin.randi_range(-1,1)
	speed = ufo_speed.randi_range(200, 400)
	x_axis = rng.randf_range(-0.5, 0.5)
	set_process(true) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if spin == -1:
	#	x_axis -= 0.03
	#if spin == 1:
	#	x_axis += 0.03
	var speed_x = x_axis
	
	if speed_y > 0:
		speed_y -= speed_x / 1000
	else:
		speed_y = 1
	
	var motion = Vector2(speed_x, speed_y) * speed
	set_position(get_position() + motion * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		global.current_hull -= 1
		#hull._on_health_updated(global.current_hull)
		var coords = get_position() 
		queue_free() # Replace with function body.
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.get_child(0).emitting = true
		explosion.set_position(Vector2(coords))
		if global.current_hull <= 0:
			
			global.death(player.roundSpacecoin)
			
			body.queue_free()
			var explosion2 = EXPLOSION2.instance()
			get_parent().add_child(explosion2)
			explosion2.get_child(0).emitting = true
			explosion2.set_position(Vector2(coords))
			#get_tree().change_scene("res://Hangar.tscn")
			completion.text = "Euchred by a UFO\nYou lost " + String(player.roundSpacecoin) + " Spacecoin\nYou lost "+String(global.experienceLost)+" experience"
			completion.visible = true
			player.chargeTimer.stop()
			player.shootTimer.stop()
			#print(global.dead)
	if body.name == "LeftWall" or body.name == "RightWall":
		x_axis = x_axis * -1
	if body.name == "BottomWall" and not global.dead:
		global.xp_up(1)
		experienceLabel.set_text("Experience: "+String(global.experience))
		levelLabel.set_text("Level:" + String(global.level))
		remove_from_group("mobs")

func destroy():
	
	queue_free()
	remove_from_group("mobs")
	
	
func _on_UFO_area_entered(area):
	if "UFO" in area.name or "BigUFO" in area.name:
		x_axis = x_axis * -1
		health -= 1
		$Hit.play()
	elif "Fireball" in area.name or "Laser" in area.name:
		health -= 1
		$Hit.play()
	elif "Flameblast" in area.name:
		health -= 5
	elif "Missile" in area.name:
		$MissileHit.play()
		health -= 5
	elif "SpaceShip" in area.name:
		health -= 2
	if health <= 0 and player != null:
		var coords = get_position() 

		
		var explosion = EXPLOSION.instance()
		get_parent().add_child(explosion)
		explosion.get_child(0).emitting = true
		explosion.set_position(Vector2(coords))
		#explosion.get_child(0).restart()
		global.spacecoin += 100
		player.roundSpacecoin += 100
		global.xp_up(5)
		spacecoinLabel.set_text("$"+String(global.spacecoin))
		experienceLabel.set_text("Experience: "+String(global.experience))
		levelLabel.set_text("Level:" + String(global.level))
		queue_free()
		
