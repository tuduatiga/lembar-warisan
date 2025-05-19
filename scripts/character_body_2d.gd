extends CharacterBody2D

const SPEED: float = 200.0

var _sprite: AnimatedSprite2D

func get_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _ready():
	_sprite = self.find_child("AnimatedSprite2D")

func _physics_process(_delta):
	self.velocity = get_input() * SPEED

	if (self.velocity.x):
		_sprite.flip_h = self.velocity.x < 0

	_sprite.speed_scale = 1 + self.velocity.length() / SPEED

	var dir: String = "back" if self.velocity.y < 0 else "front"
	if self.velocity.length_squared() > 0:
		_sprite.animation = dir + "_walk"
	else:
		_sprite.animation = dir + "_idle"

	move_and_slide()
