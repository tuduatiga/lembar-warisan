class_name HitboxComponent extends Area2D

@export var attack: Attack


func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HITBOX
	self.collision_mask = Enums.CollisionLayer.HURTBOX
