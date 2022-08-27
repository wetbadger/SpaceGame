extends KinematicBody

class_name Projectile

export (float) var speed = 100
export (int) var damage = 0
export (int, "vertical", "aimed_direct", "aimed_predict", "seek") var movement = "vertical"
export (float) var randomization  = 0 #how bad is the bot's aim?
