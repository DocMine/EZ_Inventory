@icon("res://addons/EZ_Inventory/Icon/bag.svg")
extends Resource
class_name ItemContainer
# 定义一个资源类，用来表示容纳某种物品的容器
# 基础容器(ItemContainer_Base)使用条目数限制容器大小，同时其包含的物品拥有顺序

@export var itemdatabase:ItemDatabase = ItemDatabase.new() ## 包含物品信息的数据库，背包只保存有限信息
@export var ItemsInContainer_Stuck:Array ## 此容器的主要内容，包含由字典组成的列表

@export_group("容器参数")
@export var CheckSlotCount:bool = true ## 勾选则限制容器格子数量
@export var MaxSlotCount:int = 10 ## 容器能容纳的最大格子数

@export var CheckWeight:bool = true ## 勾选则限制容器容纳重量
@export var MaxWeight:int = 100  ## 容器能容纳的最大重量
@export var DefaultStuckSize:int = 100 ## 默认的物品堆叠大小,除非数据库中的物品设置了"stuck_size"属性



@export_group("列表字典键")
@export var ItemId_Key:String = "id" ## 指定组成容器列表字典的键
@export var ItemAmount_Key:String = "amount"
@export var ItemWeight_Key:String = "weight"
@export var StuckSize_Key:String = "stuck_size"
@export var ItemIconPath_Key:String = "icon_path"
@export var DefaultIconPath:String = "res://icon.svg"



var WeightNow:float=0
var CountNow:int = 0


func AddItem(ItemId:String,Amount:int)->void:
	var ItemInfoDic:Dictionary
	var lastAmount:int = Amount
	var StuckSize:int = GetStuckSize(ItemId)
	while lastAmount > StuckSize:
		# 剩下的数量无法装入同一个格子,则递归装入
		AddItem(ItemId,StuckSize)
		lastAmount -= StuckSize
	# 如果可以装入一个格子，则检查背包整体是否可以加入格子
	if CanAddItem(ItemId, Amount):
		ItemInfoDic = {
			ItemId_Key:ItemId , 
			ItemAmount_Key: lastAmount, 
			ItemIconPath_Key:DefaultIconPath,
			StuckSize_Key: StuckSize}
		# 构建用于背包保存的字典
		if itemdatabase.ItemDic.has(ItemIconPath_Key):
			# 如果数据库指定了icon，则指定icon
			ItemInfoDic[ItemIconPath_Key] = itemdatabase.ItemDic[ItemIconPath_Key]
		ItemsInContainer_Stuck.append(ItemInfoDic)
	else:
		print("装入"+str(ItemId)+"失败, 数量:"+str(Amount))


func CanAddItem(ItemId:String,Amount:int)->bool:
	# 这个函数判断目前背包还能否添加指定的物品
	if itemdatabase.ItemDic.has(ItemId):
		#首先确保物品在数据库中
		if CheckSlotCount:
			CountNow = len(ItemsInContainer_Stuck)
			if  CountNow >= MaxSlotCount:
				# 格子占满了
				print("bag full")
				return false
		if CheckWeight:
			WeightNow = 0
			for item_num_dic in ItemsInContainer_Stuck:
				# 遍历整个背包，刷新重量
				var id = item_num_dic[ItemId_Key]
				var ItemWeight:float = 0.0
				if itemdatabase.ItemDic[id].has(ItemWeight_Key):
					ItemWeight = float(itemdatabase.ItemDic[id][ItemWeight_Key])
				WeightNow += item_num_dic["amount"] * ItemWeight
			if WeightNow > MaxWeight:
				return false
	else:
		print("Item not in database, add failed")
		return false
	return true


func RemoveItem(ItemId:String,Amount:int)->bool:
	# 将物品从容器中删除相应数量
	var idlist:Array = []
	for itemDic in ItemsInContainer_Stuck:
		idlist.append(itemDic[ItemId_Key])
	# 得到物品堆叠大小和包含所有id的列表
	if ItemId in idlist:
		# 开始删除过程
		var lastAmount:int = Amount #剩余需要删除的数量
		var StuckSize:int = GetStuckSize(ItemId)
		for index in range(len(ItemsInContainer_Stuck)):
			if ItemsInContainer_Stuck[index][ItemId_Key] == ItemId:
				# 对于指定物品,减去相应数量
				if lastAmount < ItemsInContainer_Stuck[index][ItemAmount_Key]:
					ItemsInContainer_Stuck[index][ItemAmount_Key] -= lastAmount
					lastAmount = 0
				else:
					# 一个格子不够减,则寻找下一个符合条件的格子
					lastAmount -= ItemsInContainer_Stuck[index][ItemAmount_Key]
					ItemsInContainer_Stuck[index][ItemAmount_Key] = 0
		for index in range(len(ItemsInContainer_Stuck)-1,-1,-1):
			# 逆序遍历来删除
			if ItemsInContainer_Stuck[index][ItemAmount_Key]<=0:
				ItemsInContainer_Stuck.pop_at(index)
		# print("移除了"+str(Amount-lastAmount)+"个 "+str(ItemId))
		return true
	else:
		print("背包中没有指定物品"+str(ItemId)+",移除失败")
		return false


func SaveAsResource(FilePath:String):
	# 将整个资源文件保存到path
	# 这里应该判断路径中的目录是否存在，不存在的话要新建目录
	ResourceSaver.save(self, FilePath)

func GetStock()->Array:
	return ItemsInContainer_Stuck

func GetStuckSize(ItemId:String)->int:
	var StuckSize:int = DefaultStuckSize
	if itemdatabase.ItemDic.has(ItemId) and itemdatabase.ItemDic[ItemId].has("stuck_size"):
		print("数据库中有stucksize， 以指定stucksize")
		StuckSize = int(itemdatabase.ItemDic[ItemId]["stuck_size"])
	# 首先确定StuckSize,没有则使用default
	return StuckSize

func PrintAllItems():
	print('bag:')
	print(ItemsInContainer_Stuck)
