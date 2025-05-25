class_name HealthComponent extends Node2D

signal damage_taken(health: int)

@export var max_health: int

var _health: int


func _ready() -> void:
	self._health = self.max_health


func damage(attack: Attack):
	self._health -= attack.attack_damage

	damage_taken.emit(self._health)
