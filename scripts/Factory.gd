extends Node2D

onready var c =  preload("res://scenes/circle.tscn")
onready var j =  preload("res://scenes/Jumper.tscn")

func  createCircle() -> CircleArea :
    return c.instance() as CircleArea

func  createJumper() -> Jumper :
    return j.instance() as Jumper
