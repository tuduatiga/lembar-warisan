extends StaticBody2D

const SPEED = 800.0

@export var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var velocity = direction * SPEED
	self.translate(velocity * delta)

func _on_body_entered(body: Node2D) -> void:
	print(typeof(body))
