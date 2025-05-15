extends CharacterBody2D

const _SPEED: float = 200.0  # TODO: get value from GameManager
var _dir: String = "front"

func _physics_process(_delta: float) -> void:
	var y_direction: float = Input.get_axis("ui_up", "ui_down")
	var x_direction: float = Input.get_axis("ui_left", "ui_right")

	var sprite: AnimatedSprite2D = self.find_child("AnimatedSprite2D")
	if y_direction:
		self.velocity.y = y_direction * self._SPEED
		if y_direction > 0:
			_dir = "front"
		else:
			_dir = "back"
	else:
		self.velocity.y = move_toward(self.velocity.x, 0, self._SPEED)
		_dir = "front"

	if x_direction:
		self.velocity.x = x_direction * _SPEED
		sprite.flip_h = x_direction < 0
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, self._SPEED)

	self.move_and_slide()

	sprite.speed_scale = 1+self.velocity.length()/_SPEED
	if self.velocity.length():
		sprite.animation = _dir+"_walk"
	else:
		sprite.animation = _dir+"_idle"
