class_name HurtboxComponent
extends Area2D

signal hit_received(attack: AttackData)

func receive_hit(attack: AttackData) -> void:
	hit_received.emit(attack)
