extends KinematicBody2D
export (PackedScene) var Fireball

const rotation_speed_for_missiles = 0.5
const ACCELERATION = 10000
const MAX_SPEED = 250
const FRICTION = 10000
const LASER_SCENE = preload("Effects/Laser.tscn")
const MISSILE_SCENE = preload("Effects/Missile.tscn")
const FIREBALL_SCENE = preload("Effects/Fireball.tscn")
const FLAMEBLAST_SCENE = preload("Effects/FlameBlast.tscn")
const BUTTON_DOWN = preload("../Assets/buttondown.png")
const BUTTON_UP = preload("../Assets/buttonup.png")
onready var debugLabel = get_parent().get_node("Canvas/Sidebar/DebugLabel")
onready var missiles = get_parent().get_node("NumOfMissiles/Missiles")
onready var bombBlast = get_parent().get_node("BombBlast")
onready var fireButton = get_parent().get_node("ButtonLayer/Sprite")
onready var num_of_bombs = get_parent().get_node("NumOfBombs/Bombs")
var fireballTex = preload("res://Assets/fireball.png")
var laserTex = preload("res://Assets/Laser.png")
var missileTex = preload("res://Assets/Missile.png")
var textureList = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rate_of_fire = pow(6, - (0.2 * global.gas_port_level))
var hull = global.hull
var bombs = global.bombs

var analog_velocity = Vector2(0,0)
var velocity = Vector2.ZERO
var leftMotion = true
var rightMotion = true
var downMotion = true
var upMotion = true
var justShoot = false

var _timer = null #do I need this?

var shootTimer = null
var chargeTimer = null
var spacecoin = global.spacecoin
var roundSpacecoin = 0
var flameblastCharged = false
var shootAgain = true
var fingerHeld = false

var lastInforceX = 0
var lastInforceY = 0
var secondFinger = false

var finger1Shooting = false
var finger2Shooting = false

var weapon = global.weapons[global.selectedWeapon]
onready var weaponButton = get_parent().get_node("Weapons/Weapon1")

onready var bullet_sprite = get_node("../Weapons/Weapon1/Sprite")

var nearest_mob1 = null
var nearest_mob2 = null
var mobs = null
var missilesOnScreen = false
var arrayOfMissiles = []
var arrayOfNearestMobs = []

func _ready():
	num_of_bombs.set_text(String(global.bombs))
	for nodes in get_tree().get_nodes_in_group("mobs"):
		nodes.remove_from_group("mobs")
	set_process(true)
	for weapon in global.weapons:
		if weapon == "laser":
			textureList.append(laserTex)
		if weapon == "fireball":
			textureList.append(fireballTex)
		if weapon == "missile":
			textureList.append(missileTex)
	
	bullet_sprite.set_texture(textureList[global.selectedWeapon])
	missiles.set_text(String(global.numOfMissiles))
	if weapon != "missile":
		missiles.visible = false
#	_timer = Timer.new()
#	add_child(_timer)
#
#	_timer.connect("timeout", self, "_on_Timer_timeout")
#	_timer.set_wait_time(rate_of_fire)
#	_timer.set_one_shot(false) # Make sure it loops
#	_timer.start()
	
	shootTimer = Timer.new()
	add_child(shootTimer)
	shootTimer.connect("timeout", self, "_on_shootTimer_timeout")
	shootTimer.set_wait_time(rate_of_fire)
	shootTimer.set_one_shot(false) # Make sure it loops
	
	chargeTimer = Timer.new()
	add_child(chargeTimer)
	chargeTimer.connect("timeout", self, "_on_chargeTimer_timeout")
	chargeTimer.set_wait_time(rate_of_fire*10)
	chargeTimer.set_one_shot(false) # Make sure it loops
	chargeTimer.start()

	#this funtion not used
func _on_Timer_timeout():
	if Input.is_action_pressed("shoot") and not justShoot:
		shoot()
	justShoot = false
	shootAgain = true
	
func _on_shootTimer_timeout():
	shootAgain = true
	if fingerHeld:
		shoot()

func _on_chargeTimer_timeout():
	flameblastCharged = true
	get_node("RedLight").visible = true
	

func shoot():
	if weapon == "fireball":
		if not flameblastCharged and shootAgain:
			chargeTimer.start()
			shootTimer.start()
			var fireball = FIREBALL_SCENE.instance()
			var fireball2 = FIREBALL_SCENE.instance()
			get_parent().add_child(fireball)
			get_parent().add_child(fireball2)
			fireball.set_position(get_node("RightCannon").get_global_position())
			fireball2.set_position(get_node("LeftCannon").get_global_position())
			#var fireball = Node2D.Fireball
			shootAgain = false
		elif shootAgain:
			chargeTimer.start()
			shootTimer.start()
			var flameblast = FLAMEBLAST_SCENE.instance()
			get_parent().add_child(flameblast)
			flameblast.set_position(get_node("Nose").get_global_position())
		flameblastCharged = false
		get_node("RedLight").visible = false
	if weapon == "laser":
		if shootAgain:
			shootTimer.start()
			var laser = LASER_SCENE.instance()
			get_parent().add_child(laser)
			laser.set_position(get_node("Nose").get_global_position())
			shootAgain = false
	if weapon == "missile":
		if shootAgain and global.numOfMissiles > 0:
			shootTimer.start()
			var missile = MISSILE_SCENE.instance()
			var missile2 = MISSILE_SCENE.instance()
			get_parent().add_child(missile)
			get_parent().add_child(missile2)
			missile.set_position(get_node("RightCannon").get_global_position())
			missile2.set_position(get_node("LeftCannon").get_global_position())
			missile.set_z_index(-1)
			missile2.set_z_index(-1)
			#get position of nearest mob or first created mob
			# get spawn nodes
			
			mobs = get_tree().get_nodes_in_group("mobs")

			# assume the first spawn node is closest
			if len(mobs) > 0:
				nearest_mob1 = mobs[0]
				nearest_mob2 = mobs[0]

			# look through spawn nodes to see if any are closer
			#missle right
			for mob in mobs:
				if mob.global_position.distance_to(missile.global_position) < nearest_mob1.global_position.distance_to(missile.global_position) and (missile.global_position.angle_to_point(mob.global_position) >= 1.5 and missile.global_position.angle_to_point(mob.global_position) <= 2.5):
					nearest_mob1 = mob
			#missile left
			for mob in mobs:
				if mob.global_position.distance_to(missile2.global_position) < nearest_mob2.global_position.distance_to(missile2.global_position) and (missile2.global_position.angle_to_point(mob.global_position) >= 0.5 and missile.global_position.angle_to_point(mob.global_position) <= 1.5):
					nearest_mob2 = mob
			#print(nearest_mob.global_position)
			#turn missile toward targeted mob
			arrayOfMissiles.append(missile)
			arrayOfMissiles.append(missile2)
			arrayOfNearestMobs.append(nearest_mob1)
			arrayOfNearestMobs.append(nearest_mob2)
			
			
			missilesOnScreen = true
#			if angleToMouse >180:
#				turretAngle++
#			else
#				turretAngle--
			#do splash damage
			shootAgain = false
			global.numOfMissiles -= 2
			missiles.set_text(String(global.numOfMissiles))
	#if fingerHeld:
		#shootTimer.start()
	

func bomb():
	
	#flashing white rectangle
	if global.bombs > 0:
		$Bomb.play()
		global.bombs -= 1
		num_of_bombs.set_text(String(global.bombs))
		var x = 0
		while x < 3:
			for mob in get_tree().get_nodes_in_group("mobs"):
				mob.queue_free()
			bombBlast.visible = true
			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			bombBlast.visible = false
			t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			x+=1
	

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	if leftMotion and rightMotion:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	else:
		if leftMotion:
			input_vector.x = -Input.get_action_strength("ui_left")
		if rightMotion:
			input_vector.x = Input.get_action_strength("ui_right")
	if upMotion and downMotion:
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	else:
		if upMotion:
			input_vector.y = -Input.get_action_strength("ui_up")
		if downMotion:
			input_vector.y = Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector*ACCELERATION*delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#print(analog_velocity)
	velocity+= analog_velocity * 3 #for some reason analog velocity needs to be higher
	var collision = move_and_collide(velocity)

	if collision:
		analog_force_change(Vector2(lastInforceX,lastInforceY), null) #bump the joystick slightly :)
		#compensate for the button being pushed against the wall
		velocity = velocity.slide(collision.normal)
		if collision.collider.name == "LeftWall":
			leftMotion = false
			rightMotion = true
		if collision.collider.name == "RightWall":
			rightMotion = false
			leftMotion = true
		if collision.collider.name == "BottomWall":
			downMotion = false
			upMotion = true
		if collision.collider.name == "TopWall":
			upMotion = false
			downMotion = true

	#reset motion to allow movement toward wall
	if Input.is_action_pressed("ui_left"):
		rightMotion = true
	if Input.is_action_pressed("ui_right"):
		leftMotion = true
	if Input.is_action_pressed("ui_up"):
		downMotion = true
	if Input.is_action_pressed("ui_down"):
		upMotion = true
	
	if Input.is_action_pressed("shoot"):# and not justShoot:
		#fireButton.set_texture(BUTTON_DOWN)
		shoot()
	if Input.is_action_just_released("shoot"):
		#fireButton.set_texture(BUTTON_UP)
		pass
	
	
	if Input.is_action_just_pressed("bomb"):# and not justShoot:
		bomb()
		
	if Input.is_action_just_pressed("weapon"):# and not justShoot:
		_on_Weapon1_button_down()
#	if Input.get_mouse_button_mask() == 1 and shootAgain == true:
#
#		var mouseCoords = get_viewport().get_mouse_position()
#		if mouseCoords[0] > 150 or mouseCoords[1] < 658:
#			justShoot = true
#			shoot()
#			shootAgain = false
			
	if fingerHeld:
		debugLabel.set_text("Still Shooting")
		justShoot = true
		shoot()
		shootAgain = false
		fingerHeld = true
		
	if missilesOnScreen:
		
		var i = 0
		for m in arrayOfMissiles:
			if arrayOfNearestMobs[i] != null and m != null:
				var angle = m.global_position.angle_to_point(arrayOfNearestMobs[i].global_position)
				if angle > 1.5 and angle > 0:
					m.rotation = m.rotation + (rotation_speed_for_missiles * delta)
					m.position += Vector2(0, -1).rotated(m.rotation) * 200 * delta
				elif angle > 0:
					m.rotation = m.rotation - (rotation_speed_for_missiles * delta)
					m.position += Vector2(0, -1).rotated(m.rotation) * 200 * delta
				else:
					m.position += Vector2(0, -1).rotated(m.rotation) * 200 * delta
			elif arrayOfNearestMobs[i] == null and m != null:
				m.position += Vector2(0, -1).rotated(m.rotation) * 200 * delta
			#print(m.global_position.angle_to_point(arrayOfNearestMobs[i].global_position))
			i+=1
			
#screen touch shooting
func _input(event):
	
	
	
	if event is InputEventScreenTouch and event.index == 0: #one finger
		#print(event.position)

		if (event.position.x > 320 or event.position.y < 650) and not finger1Shooting: #outside of analog stick and weapon select
			debugLabel.set_text("Shooting")
			fireButton.set_texture(BUTTON_DOWN)
			shoot()
			finger1Shooting = true

			fingerHeld = true

		elif finger1Shooting:
			finger1Shooting = false
			fingerHeld = false
			fireButton.set_texture(BUTTON_UP)

			
	if event is InputEventScreenTouch and event.index == 1: #two finger

		if (event.position.x > 320 or event.position.y < 650) and not finger2Shooting: #outside of analog stick and weapon select
			debugLabel.set_text("Shooting")
			shoot()
			finger2Shooting = true

			fingerHeld = true

		elif finger2Shooting:
			finger2Shooting = false
			fingerHeld = false
			
		#allow button to be triggered by second finger
		if (event.position.x <= 320 and event.position.y <= 650):
			_on_Weapon1_button_down()
			

func analog_force_change(inForce, inStick):
	
	#if(inStick.get_name()=="AnalogRight") or (inStick.get_name()=="AnalogLeft"):
	if (inForce.length() < 0.1):
		analog_velocity = Vector2(0,0) 
	else:
		
		#all this to let ship slide along walls
		lastInforceX = inForce.x
		lastInforceY = inForce.y
		if not leftMotion:
			if inForce.x < -0:
				analog_velocity = Vector2(0,-inForce.y)
			else:
				analog_velocity = Vector2(inForce.x,-inForce.y)
				leftMotion = true
		elif not rightMotion:
			if inForce.x > 0:
				analog_velocity = Vector2(0,-inForce.y)
			else:
				analog_velocity = Vector2(inForce.x,-inForce.y)
				rightMotion = true
		elif not upMotion:
			if inForce.y > 0:
				analog_velocity = Vector2(inForce.x,0)
			else:
				analog_velocity = Vector2(inForce.x,-inForce.y)
				upMotion = true
		elif not downMotion:
			if inForce.y < -0:
				analog_velocity = Vector2(inForce.x,0)
			else:
				analog_velocity = Vector2(inForce.x,-inForce.y)
				downMotion = true
		else:
			analog_velocity = Vector2(inForce.x,-inForce.y)
		
	#get rid of analog direction if colliding with wall
	#how do dis?
	
	#Convert analog velocity to 0 , 1 , -1 
	analog_velocity = analog_velocity.normalized()
#		analog_velocity.x = int(round(analog_velocity.x))
#		analog_velocity.y = int(round(analog_velocity.y))
		
		#analog_velocity.x = stepify(analog_velocity.x, 1)
		#analog_velocity.y = stepify(analog_velocity.y, 1)
		#print(analog_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#methods for touch screen
#func _input(event):
#	var pressed = isPressed(event)
#	var released = isReleased(event)
#	if pressed:
#		print(pressed)
#	if released:
#		print(released)
#
#func isPressed(event):
#	if event is InputEventScreenTouch:
#		return event.is_pressed()
#
#func isReleased(event):
#	if event.position.x > 150 or event.position.y < 658:
#		if event is InputEventScreenTouch:
#			return !event.is_pressed()


func _on_Weapon1_button_down():

	if global.selectedWeapon >= len(global.weapons) - 1:
		global.selectedWeapon = 0
	else:
		global.selectedWeapon += 1

	weapon = global.weapons[global.selectedWeapon]
	weaponButton.release_focus()
	bullet_sprite.set_texture(textureList[global.selectedWeapon])
	if global.weapons[global.selectedWeapon] == "missile":
		missiles.visible = true
	else:
		missiles.visible = false


func _on_SwipeDetector_swiped(direction):
	print(direction)
	if direction == Vector2(-1, 0) or direction == Vector2(1, 0):
		bomb()
