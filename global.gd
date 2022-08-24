extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spacecoin = 0
var experience = 0
var level = 1
var expPoints = 1 #upgrade points
var weapons = ["laser"] #["laser", "fireball", "missile"]
var selectedWeapon = 0
var numOfMissiles = 0
var hull = 1
var gas_port_level = 1
var bomb_bay = 1
var bombs = 1

var current_hull = hull

var dead = false
var winner = false

var experienceLost = 0

var left_play_edge = 0
var right_play_edge = 480
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func xp_up(x):
	experience += x
	if experience >= pow(2, level) * 100:
		level += 1
		expPoints += 1
func death(lostCoin):
	spacecoin -= lostCoin
	#if level is 1 go back to 0, elso go back to begining of level
	var a
	if level == 1:
		a = 0
	else:
		a = 1
	var experienceBefore = experience
	# take off 3% experience unless level is too low
	if round(experience * 0.97) < pow(2, level-1) * 100 * a:
		experience = pow(2, level-1) * 100 * a
	else:
		experience = round(experience * 0.97)
	experienceLost = experienceBefore - experience
	dead = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
