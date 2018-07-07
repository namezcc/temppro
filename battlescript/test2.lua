Mbit = require "mbit"

print(Mbit.band(0x2,0x1))
print(Mbit.bor(0x2,0x1))
print(Mbit.bnot(0xF0))
print(Mbit.bxor(0x3,0x1))
print(Mbit.movel(1,3))
print(Mbit.mover(0x8,2))
print(Mbit.setbit(0,2,true))
print(Mbit.setbit(0x8,4,false))
print(Mbit.checkbit(0x8,4))
print(Mbit.checkbit(0x8,1))