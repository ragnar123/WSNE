#ifndef GENERATOR_H
#define GENERATOR_H


enum {
  AM_RAD = 6,
  TIMER_PERIOD_MILLI = 50,
  KEY = 123,
};

typedef nx_struct GenMsg {
  nx_uint16_t nodeid;
  nx_uint16_t numpkt;
  nx_uint16_t seqnr;
  nx_uint16_t temperature;
  nx_uint8_t DATA[7];

} GenMsg;

#endif

