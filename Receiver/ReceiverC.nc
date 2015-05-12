#include <Timer.h>
#include "Receiver.h"
#include "printf.h" 


module ReceiverC {
  uses interface Boot;
  uses interface Leds;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface CC2420Packet;
  //uses interface Timer<TMilli> as TimeCount;
}
implementation { 
  uint16_t rssi;
  uint16_t counter;
  uint16_t last_numpkt;
  message_t pkt;
  //float TP;
  bool busy = FALSE;
  //uint16_t time_counter;
  bool timerStarted = FALSE;

  event void Boot.booted() {

  printf("Telosb mote is booted. Starting radio...\n");
  printfflush();

  counter = 0; // This counter counts number of packages sent
  //time_counter = 0; // count relative time

  call AMControl.start();
  call Leds.led1On();
}

//event void TimeCount.fired() {
 //   time_counter++;
//}

event void AMControl.startDone(error_t err) {
  if (err == SUCCESS) {

  }
  else {
    call AMControl.start();
  }
}

 

event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
  //uint16_t resolution = 100;
  //uint8_t i;
 // uint16_t packet_loss_ratio;
  uint16_t packets_lost;


  /**
   * Receive message
   */
  if (len == sizeof(GenMsg)) {
    GenMsg* btrpkt;

    //if (!timerStarted) {
     // call TimeCount.startPeriodic(1);
     // timerStarted = TRUE;
   // }
    call Leds.led2On();

    // Increment the packet counter
    counter++;

    // Read payload
    btrpkt = (GenMsg*)payload;

    // Verify that we recieve from our transmitter
    if (btrpkt->nodeid == NID) {
      rssi = call CC2420Packet.getRssi(msg);
      if (last_numpkt != btrpkt->numpkt) {
        counter = 0;
      }

      /***
      Packet loss ratio
      PLR = (number of recv pkgs) / (all packages)

      We have a variable counter, that increments everytime we receive a package. 
      In the received package, there is a sequence number, indicating how many packets are sent
      We divide the two... What datatype do we use for storing the value?
      */
      //packet_loss_ratio = resolution - (resolution * counter / btrpkt->seqnr);

      /*** 
        Packets lost
      */
      packets_lost = btrpkt->numpkt - (counter + 1) ;
      //TP = btrpkt->temperature;
      //TP = (TP * 0.0098) - 40;

      // time = call LocalTime.get();
      printf("\n%d, %d, %d, %d, %d",rssi,btrpkt->seqnr, packets_lost, len, btrpkt->temperature);
      printfflush();

/*
         printf("NODE ID %d, seq: %d rssi: %d time: %d, len: %d \n", btrpkt->nodeid, counter, rssi, time_counter, len);
         printfflush();

    // Print out the data
    for (i = 0; i < sizeof(btrpkt->data); i++) {
        if (i % 8 == 0) printf("\n");
        printf("   data[%d]: %d  ", i, btrpkt->data[i]);
    }
    printfflush();
*/

      } else {
         printf("BAD PACKET. Not from our generator (%d).\n", btrpkt->nodeid);
         printfflush();
      }


        last_numpkt = btrpkt->numpkt;
    } else {
        printf("Length mismatch");
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
