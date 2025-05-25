extends Area2D

var _clear = false
var _visited = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_body_entered)


func _physics_process(_delta: float) -> void:
	var should_be_clear = true
	if self._visited:
		for body in self.get_overlapping_bodies():
			if body is PhysicsBody2D:
				if body is Bar and body.collision_layer & 0b10000 > 0:
					if body.open and not self._clear:
						body.transition_close()
					if not body.open and self._clear:
						body.transition_open()

				if body.collision_layer & 0b100:
					should_be_clear = false	

		self._clear = should_be_clear

func _body_entered(body: PhysicsBody2D) -> void:
	if self._clear:
		return

	if body.collision_layer & 0b10 > 0 and not self._visited:
		self._visited = true
		body.global_position.y = min(body.global_position.y, self.global_position.y-16)
