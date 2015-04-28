// $Id: BlinkToRadioC.nc,v 1.6 2010-06-29 22:07:40 scipio Exp $
#include <Timer.h>
#include "BlinkToRadio.h"
#include "printf.h" 


module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
//  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface CC2420Packet;
  uses interface Timer<TMilli> as TimeCount;
}
implementation { 
  uint16_t rssi;
  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;
  uint16_t time_counter;
  bool timerStarted = FALSE;

  event void Boot.booted() {

    printf("Telosb mote is booted. Starting radio...\n");
    printfflush();

    counter = 0; // This counter counts number of packages sent
    time_counter = 0; // count relative time

    call AMControl.start();
    call Leds.led1On();
  }

  event void TimeCount.fired() {
      time_counter++;
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {

    }
    else {
      call AMControl.start();
    }
  }

 

 event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){

    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt;

      if (!timerStarted) {
        call TimeCount.startPeriodic(1);
        timerStarted = TRUE;
      }
      call Leds.led2On();

      // Increment the packet counter
      counter++;

      // Read payload
       btrpkt = (BlinkToRadioMsg*)payload;
      
      rssi = call CC2420Packet.getRssi(msg);

      // time = call LocalTime.get();
      printf("NODE ID %d, seq: %d rssi: %d time: %d\n", btrpkt->nodeid, counter, rssi, time_counter);
      printfflush();

    }
    call Leds.led2Off();
    return msg;
  }


  event void AMControl.stopDone(error_t err) {
  }
  event void AMSend.sendDone(message_t* msg, error_t err) {

  }

  /**
    counter++;
    if (!busy) {
    
      BlinkToRadioMsg* btrpkt = 
	(BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
   call Leds.led0On();
      if (btrpkt == NULL) {
	return;
      }
      btrpkt->nodeid = TOS_NODE_ID;
      //btrpkt->counter = counter;
      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      call Leds.led0Off();
      busy = FALSE;
    }
  } */

}
