class_name HealthComponent extends Node2D

signal damage_taken(health: int)

@export var max_health: int

var health: int


func _ready() -> void:
	self.health = self.max_health


func damage(attack: Attack):
	if self.health <= 0:
		return

	self.health -= attack.damage

	damage_taken.emit(self.health)
