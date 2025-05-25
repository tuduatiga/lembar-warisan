class_name HitBox extends Area2D

@export var health_component: HealthComponent


func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HITBOX
	self.collision_mask = Enums.CollisionLayer.HURTBOX


func damage(attack: AttackComponent):
	if self.health_component:
		self.health_component.damage(attack)
