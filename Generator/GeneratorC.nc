

#include <Timer.h>
#include "Generator.h"
#include <UserButton.h>

module GeneratorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  //uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Notify<button_state_t>;
  uses interface Read<uint16_t> as TempRead;
}
implementation {
  uint16_t mode[4]={0,100,0,5000};
  uint16_t modeCount;
  uint16_t counter;
  uint8_t ct;
  uint16_t temp_value; 
  message_t pkt;
  bool busy = FALSE;
  //nx_uint8_t DT = rand() % 20 + 1;
  //uint8_t DT[108] = {1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0};
  uint8_t DT[7] = {1,0,1,0,1,0,1};
  //uint8_t DT[50];
  //uint16_t i;
  uint16_t n;


 event void Notify.notify(button_state_t state) {
     
    if ( state == BUTTON_PRESSED ) { 
      counter = 0;
      
      modeCount=mode[ct % 4];

      call Leds.led0Off();
      call Leds.led1Off();
      call Leds.led2Off();

      switch (ct%4) {
        case 0: 
          call Leds.led0On(); 
          break;
        case 1:
          call Leds.led1On(); 
          break;
        case 2:
          call Leds.led2On(); 
          break;
        case 3:
          call Leds.led1On(); 
          call Leds.led2On(); 
          break;
        default:
          break;
      }

      ct++;
       
  }
}



  event void Boot.booted() {
    call AMControl.start();
     //call Leds.led1On();
     call Notify.enable();  
     counter = 0;
     ct = 0;
     /*
     for (i=0;i<50;i++){
        DT[i]=1;
     }
*/

  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);

    }
    else {
      call AMControl.start();
      
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

   event void TempRead.readDone(error_t result, uint16_t TempValue)
   {
     if(result == SUCCESS){
      temp_value = TempValue;
   }
 }

  event void Timer0.fired() {
    if (counter<modeCount){
      call TempRead.read();
    
    if (!busy) {
    
      GenMsg* btrpkt = 
	(GenMsg*)(call Packet.getPayload(&pkt, sizeof(GenMsg)));
  call Leds.led0On();
  // call Leds.led1On();
   //call Leds.led2On();
      if (btrpkt == NULL) {
	return;
      }
      btrpkt->temperature = temp_value; 
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->numpkt = mode[(ct-1) %4];
      btrpkt->seqnr = counter+1;
      for (n=0;n<sizeof(DT);n++){
        btrpkt->DATA[n] = DT[n];
      }
      //btrpkt->counter = counter;

      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(GenMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }
}

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
     call Leds.led0Off();
     // call Leds.led1Off();
     // call Leds.led2Off();
      busy = FALSE;
      counter++;
    }
  }


}
