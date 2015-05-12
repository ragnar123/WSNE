
#ifndef RECEIVER_H
#define RECEIVER_H

enum {
  AM_RAD= 6,
  TIMER_PERIOD_MILLI = 1000,
  KEY = 123,
  NID = 15
};

typedef nx_struct GenMsg {
  nx_uint16_t nodeid;
  nx_uint16_t numpkt;
  nx_uint16_t seqnr;
  nx_uint16_t temperature;
  nx_uint8_t DATA[7];

} GenMsg;


#endif

