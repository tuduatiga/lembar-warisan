class_name HurtboxComponent extends Area2D

@export var health_component: HealthComponent

func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HURTBOX
	self.collision_mask = Enums.CollisionLayer.HITBOX

	self.area_entered.connect(self._on_area_entered)
	self.area_exited.connect(self._on_area_exited)


func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is HitboxComponent:
		if not self.owner.is_ancestor_of(hitbox):
			health_component.damage(hitbox.attack)


func _on_area_exited(hitbox: Area2D) -> void:
	if hitbox is HitboxComponent and self.owner:
		if self.owner == hitbox.owner:
			return
