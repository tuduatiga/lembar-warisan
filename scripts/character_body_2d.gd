extends CharacterBody2D

const _SPEED: float = 200.0  # TODO: get value from GameManager


func _physics_process(_delta: float) -> void:
	var y_direction: float = Input.get_axis("ui_up", "ui_down")
	var x_direction: float = Input.get_axis("ui_left", "ui_right")

	if y_direction:
		self.velocity.y = y_direction * self._SPEED
	else:
		self.velocity.y = move_toward(self.velocity.x, 0, self._SPEED)

	if x_direction:
		self.velocity.x = x_direction * _SPEED
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, self._SPEED)

	self.move_and_slide()
