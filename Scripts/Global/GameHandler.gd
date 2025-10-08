extends Node

var Player : PlayerCharacter

func collect_coin(value:int):
	Player.total_coins+= value
