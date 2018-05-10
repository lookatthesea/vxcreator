extends Node

var view = ItemList.new()

var blank_icon = load("/root/Images/VNC/blank-file.png")

func init():
	view.add_item("notes.txt", blank_icon, false)
	view.add_item("calendar.dat", blank_icon, false)
	return self
