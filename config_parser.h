#ifndef _CONFIG_PARSER_H_
#define _CONFIG_PARSER_H_


/*-------   Includes  -------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "iniparser.h"


#ifdef __cplusplus
extern "C" {
#endif

#define UDP_PACK_DIM 32768


typedef struct hydro_s{
	char  *sign;
	char *endian;
	int canali;//numero canali
	int bps;
	int sampleRate;
	int samplingTime;
} hydro;

typedef struct duinoD{
	char  pack[UDP_PACK_DIM];
	int byteScritti;
	struct duinoD *prec;
	struct duinoD *next;
} duinoData;

typedef struct sensorD{
	char  pack[3];
	int byteScritti;
	//sensorD *prec;
	struct sensorD *next;
} sensorData;

typedef struct listaCanali{
	int val;
	struct listaCanali * next;
}chanList;

typedef struct sensors_s{
	sensorData **sData;
	hydro *idrofono;
	char * sensorName;
	int status;
	int chanNumber;
	chanList *chHead;  //lista concatenata di canali
	char * unitadiMisura;
}sensors;


typedef struct sensors_list{
	chanList *availableChannels;
	int sensorNumber;
	int NchanActive; //canali attivi utilizzati 
	sensors *sensore;
	struct sensors_list *next;
}sensorList;

/*this structure contains configuration parameters*/
typedef struct _config_params_ {
	char* address;
	int port;
	char* directory;
}config_params;


void insertChannel(chanList *channel, chanList **head_ch);


sensorList * parse_ini_file(char * ini_name, config_params **params);

/* Ritorna il canale pi� alto disponibile   */
int MaxCh(chanList **head_ch);


#ifdef __cplusplus
}
#endif

#endif
