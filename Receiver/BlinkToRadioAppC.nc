#define NEW_PRINTF_SEMANTICS 1

#include <Timer.h>
#include "BlinkToRadio.h"
#include "printf.h"

configuration BlinkToRadioAppC {
}
implementation {
  components MainC;
  components LedsC;
  components BlinkToRadioC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);
  components new AMReceiverC(AM_BLINKTORADIO);
  components PrintfC;
  components SerialStartC;
  
  components CC2420ControlP;

  components new TimerMilliC() as TimeCount;
  App.TimeCount -> TimeCount;

  components CC2420ActiveMessageC;
  App -> CC2420ActiveMessageC.CC2420Packet;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
}
