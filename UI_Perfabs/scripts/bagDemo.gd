extends Control

@export var BagSapce:ItemContainer = ItemContainer.new() 
@export var slotScene:PackedScene
@export var MouseSlot:Control


@onready var BagGrid = $MarginContainer/ScrollContainer/GridContainer

func _ready():
	BagSapce.AddItem("15",1020)
	BagSapce.RemoveItem("15",300)
	initBag()
	BagSapce.PrintAllItems()
	pass


func initBag():
	# 初始化背包中的格子,将背包中的物品绘制到格子中
	var Itemindex:int = 0
	for x in range(BagSapce.MaxSlotCount):
		# put Item into SlotUI
		var c = slotScene.instantiate()
		BagGrid.add_child(c)
		c.MouseSlot = MouseSlot
		# 实例化slot,接下来将信息装填到slot
		if Itemindex < len(BagSapce.GetStock()):
			var key = BagSapce.GetStock()[Itemindex]["id"]
			print("key:  "+str(key))
			c.ItemInfo = BagSapce.GetStock()[Itemindex]
			Itemindex+=1

func _exit_tree():
	#SaveBag()
	pass

func SaveBag():
	var ItemInBag:Array = []
	for slot in BagGrid.get_children():
		if slot.ItemInfo and slot.ItemInfo.has("id"):
			ItemInBag.append(slot.ItemInfo["id"])
			# 将每个非空格子保存到资源文件
	BagSapce.ItemsInContainer_Stuck = ItemInBag
	BagSapce.SaveAsResource(BagSapce.resource_path)
	# 将bag资源更新
	print(BagSapce.ItemsInContainer_Stuck)
	pass
