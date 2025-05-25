class_name HitboxComponent extends Area2D

signal area_hit
signal body_hit

@export var attack: Attack
@export var proprietor: Node2D


func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HITBOX
	self.collision_mask = Enums.CollisionLayer.HURTBOX

	self.area_entered.connect(self.area_hit.emit)
	self.body_entered.connect(self.body_hit.emit)
