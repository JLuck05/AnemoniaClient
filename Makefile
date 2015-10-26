#@Author: Gianluca Lazzaro
#Makefile per client UDP
#
#-----------------------------------
#vars
#-----------------------------------
OUT_DIR := ../
PEGASO := ClientPegaso
ANEMONIA := ClientAnemonia
CROSS-COMP := arm-linux-gnueabi-gcc
CC := gcc -m32
LIBCROSSPATH := /usr/arm-linux-gnueabi/lib
LIBPATH := /usr/local/lib
LINKS := -lzlog -lpthread
#-----------------------------------
#executables
#-----------------------------------
MV := mv
#
#-----------------------------------
#rules
#-----------------------------------
standalone: Standalone clear
#
all: clientAcme clear
#
esempioIni: dictionary.o iniparser.o config_parser.o esempioIni.o
	echo linking config_parse, ecc...
	gcc -Wall -o esempioIni esempioIni.o config_parser.o iniparser.o dictionary.o
	echo done
#
prova: UDPClientNetduino.c config_parser.c iniparser.c dictionary.c
	echo linking config_parse...
	arm-linux-gnueabi-gcc -m32 -Wall -g -o ClientAcme -L/usr/local/lib -lzlog -lpthread UDPClientNetduino.c config_parser.c iniparser.c dictionary.c
#
anemonia: dictionary.o iniparser.o Anemonia.o
	$(info linking config_parse...)
	$(CROSS-COMP) -Wall -ggdb -o $(ANEMONIA) UDPClientAnemonia.o $(LINKS) config_parser.c iniparser.o dictionary.o -L $(LIBCROSSPATH)
	$(info compilation done! )
#
anemonia-local: dictionary-local.o iniparser-local.o Anemonia-local.o
	$(info linking config_parse...)
	$(CC) -Wall -ggdb -o $(ANEMONIA) UDPClientAnemonia.o $(LINKS) config_parser.c iniparser.o dictionary.o -L$(LIBPATH)
	$(info compilation done! )
#
pegaso: dictionary.o iniparser.o Pegaso.o
	$(info linking config_parse...)
	$(CROSS-COMP) -Wall -ggdb -o $(PEGASO) UDPClientPegaso.o $(LINKS) config_parser.c iniparser.o dictionary.o -L/usr/arm-linux-gnueabi/lib
	$(info moving executable to main dir...)
	$(MV) $(PEGASO) $(OUT_DIR)
#
Standalone: dictionary.o iniparser.o StandAlone.o
	echo linking library...
	gcc -m32 -Wall -ggdb -o Standalone UDPClientStandalone.o -lzlog -lpthread config_parser.c iniparser.o dictionary.o -L/usr/local/lib
#
StandAlone.o: UDPClientStandalone.c
	gcc -m32 -c UDPClientStandalone.c -I/usr/local/include -ggdb
#
Anemonia.o: UDPClientAnemonia.c
	$(CROSS-COMP) -c UDPClientAnemonia.c -I/usr/local/include -ggdb

Anemonia-local.o: UDPClientAnemonia.c
	$(CC) -c UDPClientAnemonia.c -I/usr/local/include -ggdb

Pegaso.o: UDPClientPegaso.c
	arm-linux-gnueabi-gcc -c UDPClientPegaso.c -I/usr/arm-linux-gnueabi/include -ggdb
#
config_parser.o: config_parser.c
	arm-linux-gnueabi-gcc -c config_parser.c -ggdb

iniparser.o: iniparser.c
	arm-linux-gnueabi-gcc -c iniparser.c -ggdb

dictionary.o: dictionary.c
	arm-linux-gnueabi-gcc -c dictionary.c -ggdb

config_parser-local.o: config_parser.c
	$(CC) -c config_parser.c -ggdb

iniparser-local.o: iniparser.c
	$(CC) -c iniparser.c -ggdb

dictionary-local.o: dictionary.c
	$(CC) -c dictionary.c -ggdb

clean: 
	rm *.o
	$(info everything cleaned... you can execute make [Project] now)
