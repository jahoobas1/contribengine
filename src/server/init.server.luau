local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _CONTRIBENGINE = require(ReplicatedStorage.CONTRIBENGINE)

_CONTRIBENGINE.corebricks.EventSubscriber:Register("Test", "stos")

_CONTRIBENGINE.corebricks.EventSubscriber:Subscribe("Test", "stos", function()
	print("Hello World!")
end)

local dstst = _CONTRIBENGINE.corebricks.DataService:RetrieveDataStore("DSTEST")
print(_CONTRIBENGINE.corebricks.DataService:GetData(dstst, "ABC"))

wait(2)

_CONTRIBENGINE.corebricks.EventSubscriber:Fire("Test")

wait(1)

print("sub")
_CONTRIBENGINE.corebricks.EventSubscriber:Unsubscribe("Test")

wait(1)

print("fire")
_CONTRIBENGINE.corebricks.EventSubscriber:Fire("Test")
