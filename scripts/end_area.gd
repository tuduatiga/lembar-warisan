extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(self._body_entered)


func _body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Player"):
		self.get_tree().root.get_node("Game").get_node("GameManager").win()
