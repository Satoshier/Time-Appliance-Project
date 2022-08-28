#!/bin/bash

# code written by Ahmad Byagowi for demonstration purposes of the SSD1327 OLED module over the i2c bus

I2CBUS=2
DEVADDR=0x3D

# Font 8x8
# Font starts with ASCII "0x20/32 (Space)
font_height=8
font_width=8
font=(
"0x00" "0x00" "0x00" "0x00" "0x00" "0x00" "0x00" "0x00"  # Space
"0x00" "0x00" "0x00" "0x00" "0x5F" "0x00" "0x00" "0x00"  # !
"0x00" "0x00" "0x00" "0x03" "0x00" "0x03" "0x00" "0x00"  # "
"0x00" "0x24" "0x7E" "0x24" "0x24" "0x7E" "0x24" "0x00"  # #
"0x00" "0x2E" "0x2A" "0x7F" "0x2A" "0x3A" "0x00" "0x00"  # $
"0x00" "0x46" "0x26" "0x10" "0x08" "0x64" "0x62" "0x00"  # %
"0x00" "0x20" "0x54" "0x4A" "0x54" "0x20" "0x50" "0x00"  # &
"0x00" "0x00" "0x00" "0x04" "0x02" "0x00" "0x00" "0x00"  # '
"0x00" "0x00" "0x00" "0x3C" "0x42" "0x00" "0x00" "0x00"  # (
"0x00" "0x00" "0x00" "0x42" "0x3C" "0x00" "0x00" "0x00"  # )
"0x00" "0x10" "0x54" "0x38" "0x54" "0x10" "0x00" "0x00"  # *
"0x00" "0x10" "0x10" "0x7C" "0x10" "0x10" "0x00" "0x00"  # +
"0x00" "0x00" "0x00" "0x80" "0x60" "0x00" "0x00" "0x00"  # "
"0x00" "0x10" "0x10" "0x10" "0x10" "0x10" "0x00" "0x00"  # -
"0x00" "0x00" "0x00" "0x60" "0x60" "0x00" "0x00" "0x00"  # .
"0x00" "0x40" "0x20" "0x10" "0x08" "0x04" "0x00" "0x00"  # /
"0x3C" "0x62" "0x52" "0x4A" "0x46" "0x3C" "0x00" "0x00"  # 0
"0x44" "0x42" "0x7E" "0x40" "0x40" "0x00" "0x00" "0x00"  # 1
"0x64" "0x52" "0x52" "0x52" "0x52" "0x4C" "0x00" "0x00"  # 2
"0x24" "0x42" "0x42" "0x4A" "0x4A" "0x34" "0x00" "0x00"  # 3
"0x30" "0x28" "0x24" "0x7E" "0x20" "0x20" "0x00" "0x00"  # 4
"0x2E" "0x4A" "0x4A" "0x4A" "0x4A" "0x32" "0x00" "0x00"  # 5
"0x3C" "0x4A" "0x4A" "0x4A" "0x4A" "0x30" "0x00" "0x00"  # 6
"0x02" "0x02" "0x62" "0x12" "0x0A" "0x06" "0x00" "0x00"  # 7
"0x34" "0x4A" "0x4A" "0x4A" "0x4A" "0x34" "0x00" "0x00"  # 8
"0x0C" "0x52" "0x52" "0x52" "0x52" "0x3C" "0x00" "0x00"  # 9
"0x00" "0x00" "0x00" "0x48" "0x00" "0x00" "0x00" "0x00"  # :
"0x00" "0x00" "0x80" "0x64" "0x00" "0x00" "0x00" "0x00"  # ;
"0x00" "0x00" "0x10" "0x28" "0x44" "0x00" "0x00" "0x00"  # <
"0x00" "0x28" "0x28" "0x28" "0x28" "0x28" "0x00" "0x00"  # =
"0x00" "0x00" "0x44" "0x28" "0x10" "0x00" "0x00" "0x00"  # >
"0x00" "0x04" "0x02" "0x02" "0x52" "0x0A" "0x04" "0x00"  # ?
"0x00" "0x3C" "0x42" "0x5A" "0x56" "0x5A" "0x1C" "0x00"  # @
"0x7C" "0x12" "0x12" "0x12" "0x12" "0x7C" "0x00" "0x00"  # A
"0x7E" "0x4A" "0x4A" "0x4A" "0x4A" "0x34" "0x00" "0x00"  # B
"0x3C" "0x42" "0x42" "0x42" "0x42" "0x24" "0x00" "0x00"  # C
"0x7E" "0x42" "0x42" "0x42" "0x24" "0x18" "0x00" "0x00"  # D
"0x7E" "0x4A" "0x4A" "0x4A" "0x4A" "0x42" "0x00" "0x00"  # E
"0x7E" "0x0A" "0x0A" "0x0A" "0x0A" "0x02" "0x00" "0x00"  # F
"0x3C" "0x42" "0x42" "0x52" "0x52" "0x34" "0x00" "0x00"  # G
"0x7E" "0x08" "0x08" "0x08" "0x08" "0x7E" "0x00" "0x00"  # H
"0x00" "0x42" "0x42" "0x7E" "0x42" "0x42" "0x00" "0x00"  # I
"0x30" "0x40" "0x40" "0x40" "0x40" "0x3E" "0x00" "0x00"  # J
"0x7E" "0x08" "0x08" "0x14" "0x22" "0x40" "0x00" "0x00"  # K
"0x7E" "0x40" "0x40" "0x40" "0x40" "0x40" "0x00" "0x00"  # L
"0x7E" "0x04" "0x08" "0x08" "0x04" "0x7E" "0x00" "0x00"  # M
"0x7E" "0x04" "0x08" "0x10" "0x20" "0x7E" "0x00" "0x00"  # N
"0x3C" "0x42" "0x42" "0x42" "0x42" "0x3C" "0x00" "0x00"  # O
"0x7E" "0x12" "0x12" "0x12" "0x12" "0x0C" "0x00" "0x00"  # P
"0x3C" "0x42" "0x52" "0x62" "0x42" "0x3C" "0x00" "0x00"  # Q
"0x7E" "0x12" "0x12" "0x12" "0x32" "0x4C" "0x00" "0x00"  # R
"0x24" "0x4A" "0x4A" "0x4A" "0x4A" "0x30" "0x00" "0x00"  # S
"0x02" "0x02" "0x02" "0x7E" "0x02" "0x02" "0x02" "0x00"  # T
"0x3E" "0x40" "0x40" "0x40" "0x40" "0x3E" "0x00" "0x00"  # U
"0x1E" "0x20" "0x40" "0x40" "0x20" "0x1E" "0x00" "0x00"  # V
"0x3E" "0x40" "0x20" "0x20" "0x40" "0x3E" "0x00" "0x00"  # W
"0x42" "0x24" "0x18" "0x18" "0x24" "0x42" "0x00" "0x00"  # X
"0x02" "0x04" "0x08" "0x70" "0x08" "0x04" "0x02" "0x00"  # Y
"0x42" "0x62" "0x52" "0x4A" "0x46" "0x42" "0x00" "0x00"  # Z
"0x00" "0x00" "0x7E" "0x42" "0x42" "0x00" "0x00" "0x00"  # [
"0x00" "0x04" "0x08" "0x10" "0x20" "0x40" "0x00" "0x00"  # <backslash>
"0x00" "0x00" "0x42" "0x42" "0x7E" "0x00" "0x00" "0x00"  # ]
"0x00" "0x08" "0x04" "0x7E" "0x04" "0x08" "0x00" "0x00"  # ^
"0x80" "0x80" "0x80" "0x80" "0x80" "0x80" "0x80" "0x00"  # _
"0x3C" "0x42" "0x99" "0xA5" "0xA5" "0x81" "0x42" "0x3C"  # `
"0x00" "0x20" "0x54" "0x54" "0x54" "0x78" "0x00" "0x00"  # a
"0x00" "0x7E" "0x48" "0x48" "0x48" "0x30" "0x00" "0x00"  # b
"0x00" "0x00" "0x38" "0x44" "0x44" "0x44" "0x00" "0x00"  # c
"0x00" "0x30" "0x48" "0x48" "0x48" "0x7E" "0x00" "0x00"  # d
"0x00" "0x38" "0x54" "0x54" "0x54" "0x48" "0x00" "0x00"  # e
"0x00" "0x00" "0x00" "0x7C" "0x0A" "0x02" "0x00" "0x00"  # f
"0x00" "0x18" "0xA4" "0xA4" "0xA4" "0xA4" "0x7C" "0x00"  # g
"0x00" "0x7E" "0x08" "0x08" "0x08" "0x70" "0x00" "0x00"  # h
"0x00" "0x00" "0x00" "0x48" "0x7A" "0x40" "0x00" "0x00"  # i
"0x00" "0x00" "0x40" "0x80" "0x80" "0x7A" "0x00" "0x00"  # j
"0x00" "0x7E" "0x18" "0x24" "0x40" "0x00" "0x00" "0x00"  # k
"0x00" "0x00" "0x00" "0x3E" "0x40" "0x40" "0x00" "0x00"  # l
"0x00" "0x7C" "0x04" "0x78" "0x04" "0x78" "0x00" "0x00"  # m
"0x00" "0x7C" "0x04" "0x04" "0x04" "0x78" "0x00" "0x00"  # n
"0x00" "0x38" "0x44" "0x44" "0x44" "0x38" "0x00" "0x00"  # o
"0x00" "0xFC" "0x24" "0x24" "0x24" "0x18" "0x00" "0x00"  # p
"0x00" "0x18" "0x24" "0x24" "0x24" "0xFC" "0x80" "0x00"  # q
"0x00" "0x00" "0x78" "0x04" "0x04" "0x04" "0x00" "0x00"  # r
"0x00" "0x48" "0x54" "0x54" "0x54" "0x20" "0x00" "0x00"  # s
"0x00" "0x00" "0x04" "0x3E" "0x44" "0x40" "0x00" "0x00"  # t
"0x00" "0x3C" "0x40" "0x40" "0x40" "0x3C" "0x00" "0x00"  # u
"0x00" "0x0C" "0x30" "0x40" "0x30" "0x0C" "0x00" "0x00"  # v
"0x00" "0x3C" "0x40" "0x38" "0x40" "0x3C" "0x00" "0x00"  # w
"0x00" "0x44" "0x28" "0x10" "0x28" "0x44" "0x00" "0x00"  # x
"0x00" "0x1C" "0xA0" "0xA0" "0xA0" "0x7C" "0x00" "0x00"  # y
"0x00" "0x44" "0x64" "0x54" "0x4C" "0x44" "0x00" "0x00"  # z
"0x00" "0x08" "0x08" "0x76" "0x42" "0x42" "0x00" "0x00"  # {
"0x00" "0x00" "0x00" "0x7E" "0x00" "0x00" "0x00" "0x00"  # |
"0x00" "0x42" "0x42" "0x76" "0x08" "0x08" "0x00" "0x00"  # }
"0x00" "0x00" "0x04" "0x02" "0x04" "0x02" "0x00" "0x00"  # ~
)

function display_off() {
i2cset -y $I2CBUS $DEVADDR 0x00 0xAB # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0x00 # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xAE # Display OFF (sleep mode)
sleep 0.1
}

function init_display() {
i2cset -y $I2CBUS $DEVADDR 0x00 0xFD 0x12 i # Unlock
i2cset -y $I2CBUS $DEVADDR 0x00 0xA4  # Display off
i2cset -y $I2CBUS $DEVADDR 0x00 0x15 0x00 0x3F i  # Set Column address
i2cset -y $I2CBUS $DEVADDR 0x00 0x75 0x00 0x7F i  # Set Row address
i2cset -y $I2CBUS $DEVADDR 0x00 0xA1 0x00  i  # Set Start line
i2cset -y $I2CBUS $DEVADDR 0x00 0xA2 0x00 i  # Set Display offset

i2cset -y $I2CBUS $DEVADDR 0x00 0xA0 0x14 0x11 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xA8 0x7F i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xAB 0x01 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xB1 0xE2 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xB3 0x91 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xBC 0x08 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xBE 0x07 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xB6 0x01 i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xD5 0x62 i  # Set Display offset

i2cset -y $I2CBUS $DEVADDR 0x00 0xB9  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0x81 0x7F i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xA4 # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0x2E  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xAF  # Set Display offset

i2cset -y $I2CBUS $DEVADDR 0x00 0xCA 0x3F i  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xA0 0x51 0x42 i  # Set Display offset

#i2cset -y $I2CBUS $DEVADDR 0x00 0xA6  # Set Display offset
}

function display_on() {
i2cset -y $I2CBUS $DEVADDR 0x00 0xAB  # Display ON (normal mode)
i2cset -y $I2CBUS $DEVADDR 0x00 0x01  # Set Display offset
i2cset -y $I2CBUS $DEVADDR 0x00 0xAF  # Set Display offset

sleep 0.001
}

function reset_cursor() {
   i2cset -y $I2CBUS $DEVADDR 0x00 0x15 0x00 0x3F 0x75 0x00 0x7F i 
}

function set_cursor() {
	i2cset -y $I2CBUS $DEVADDR 0x00 0x15 $(( ${1} >> 1 ))  0x3F 0x75 ${2} 0x7F i 
}

display_off
init_display
display_on
reset_cursor

# fill screen
for i in $(seq 256)
do
   i2cset -y $I2CBUS $DEVADDR 0x40 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff 0xff i
done

reset_cursor

# clear screen
for i in $(seq 256)
do
   i2cset -y $I2CBUS $DEVADDR 0x40 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 i
done

reset_cursor

# draw a pattern
for i in $(seq 0 10)
do
    for j in $(seq 0 10)
    do
	set_cursor $i $j
        i2cset -y $I2CBUS $DEVADDR 0x40 0xff i
    done
done

for i in $(seq 10 20)
do
    for j in $(seq 10 20)
    do
        set_cursor $i $j
        i2cset -y $I2CBUS $DEVADDR 0x40 0x88 i
    done
done

for i in $(seq 20 30)
do
    for j in $(seq 20 30)
    do
        set_cursor $i $j
        i2cset -y $I2CBUS $DEVADDR 0x40 0x44 i
    done
done

for i in $(seq 30 40)
do
    for j in $(seq 30 40)
    do
        set_cursor $i $j
        i2cset -y $I2CBUS $DEVADDR 0x40 0x22 i
    done
done

for i in $(seq 40 50)
do
    for j in $(seq 40 50)
    do
        set_cursor $i $j
        i2cset -y $I2CBUS $DEVADDR 0x40 0x11 i
    done
done


