#Executed from Command Prompt=

#Enable Manual Fan Control=   
ipmitool -I lanplus -H 192.168.1.XX -U username -P password raw 0x30 0x30 0x01 0x00

#Disable Manual Fan Control=    
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x01 0x01

#3rd Party PCIe Response State (Fast fan speed when no therm sensors on PCIe card)=    
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0xce 0x01 0x16 0x05 0x00 0x00 0x00 
                    Result1= ... 00 00 00 (Enabled)
                    Result2= ... 01 00 00 (Disabled)

#Enable 3rd Party PCIe Response=   
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x00 0x00 0x00  

#Disable 3rd Party PCIe Response=    
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00

#Set All Fans (0xff) to % (??) Speed (in Hexadecimal)=   
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x19

#Set All Fans (0xff) to 50% (0x32)=
ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x32


#Percentages to Hexadecimal & Fan Speed
10%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0xA
15%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0xF
20%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x14 
25%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x19 
30%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x1E 
35%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x23 
40%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x28
45%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x2D 
50%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x32 
55%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x37
60%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x3C
65%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x41
70%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x46
75%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x4B
80%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x50
85%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x55
90%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x5A
95%  = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x5F
100% = ipmitool -I lanplus -H 192.168.1.XX -U username -P password 0x30 0x30 0x02 0xff 0x64 

#Report Temperatures
ipmitool -I lanplus -H 192.168.1.XX -U username -P password sdr type temperature

#Report Only Temp, Volt & Fan Sensors=    
ipmitool -I lanplus -H 192.168.1.XX -U username -P password sdr elist full

#Report Power Supply Output
ipmitool -I lanplus -H 192.168.1.XX -U username -P password sdr type ‘Power Supply’

#Displays Energy Consumption
ipmitool -I lanplus -H 192.168.1.XX -U username -P password delloem powermonitor