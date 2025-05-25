class_name HealthComponent extends Node2D

@export var max_health: int = 10

var _health: int


func _init() -> void:
	self._health = self.max_health


func damage(attack: AttackComponent):
	self._health -= attack.damage

	if not self._health:
		self.owner.queue_free()
