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
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  event void Boot.booted() {

    printf("Telosb mote is booted. Starting radio...\n");
    printfflush();
    call AMControl.start();
    call Leds.led1On();
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
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      call Leds.led2Toggle();
      printf("NODE ID %d \n", btrpkt->nodeid);
      printfflush();
    }
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
