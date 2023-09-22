extends Control
# This Script Manage filement scale inside the slot

@onready var BGRect:TextureRect = $BG
@onready var ItemIcon:Button = $ItemIcon
@onready var UpdateTimer:Timer = $UpdateTimer
@onready var AmountLabel:Label =  $ItemIcon/AmountLabel
@onready var NameLabel:Label =  $ItemIcon/NameLabel


@export var ItemInfo:Dictionary = {}
@export var ItemIconPath_Key:String = "IconPath"
@export var MouseSlot:Control
@export var DefaultIcon:Resource = load("res://icon.svg")

var ItemAmount:int = 0
var MouseInSlot:bool=false

func _ready():
	# 初始化UI大小
	# BGRect.size = custom_minimum_size
	set_deferred("custom_minimum_size",BGRect.size)
	ItemIcon.custom_minimum_size = BGRect.get_size() - Vector2(15,15)
	ItemIcon.expand_icon = true
	ItemIcon.pressed.connect(_on_Icon_Clicked)
	pivot_offset = size/2
	initTimer()

func initTimer():
	# setUp UpdateTimer
	UpdateTimer.wait_time = 1
	UpdateTimer.timeout.connect(OnUpdateTimer_Timeout)
	UpdateTimer.start()

	
func OnUpdateTimer_Timeout():
	# update Item info to slotUI
	# 更新图标和数量
	UpdateItemInfo()
	#print("Slot Updated bv Timer")


func UpdateItemInfo():
	if ItemInfo :
		AmountLabel.text = str(ItemAmount)
		if ItemInfo.has("id"):
			NameLabel.text = str(ItemInfo["id"])
		if ItemInfo.has("amount"):
			AmountLabel.text = str(ItemInfo["amount"])
		if ItemInfo.has(ItemIconPath_Key):
			ItemIcon.icon = load(ItemInfo[ItemIconPath_Key])
		else:
			# 对于没有定义icon的物品，加载默认的ICON
			ItemIcon.icon = DefaultIcon
	else:
		# 空格子的显示方式
		AmountLabel.text = ""
		NameLabel.text = ""
		ItemIcon.icon = null



func SwapItemWithMouseSlot():
	if MouseSlot:
		print("SLOT_SWAPED")
		var tempDic:Dictionary = {}
		tempDic = MouseSlot.ItemInfo
		MouseSlot.ItemInfo = ItemInfo
		ItemInfo = tempDic
		print(MouseSlot.ItemInfo)
		print(ItemInfo)
	else:
		print("MouseSlot NULL")
	UpdateItemInfo()

func CheckDragging():
	if MouseInSlot and Input.is_action_pressed("MouseLeft"):
		SwapItemWithMouseSlot()
		position = get_global_mouse_position()-(size/2)
		print("draging")

func _on_Icon_Clicked():
	# 直接用按钮判断鼠标点击
	SwapItemWithMouseSlot()
	pass
