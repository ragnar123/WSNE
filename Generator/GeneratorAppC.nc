
#include <Timer.h>
#include "Generator.h"

configuration GeneratorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components GeneratorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_RAD);
   components UserButtonC;
   components new SensirionSht11C() as TempSensor; 
 // components new AMReceiverC(AM_RAD);

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
    App.Notify -> UserButtonC;
    App.TempRead -> TempSensor.Temperature; 
 // App.Receive -> AMReceiverC;
}
