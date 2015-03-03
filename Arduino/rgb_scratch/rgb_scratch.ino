/*
  rgb_scratch
 
 Checks scratch bank 1. Blinks LED the color of the value passed in.
Byte 0: on/off
Byte 1: Red
Byte 2: Green
Byte 3: Blue
 
 <http://www.punchthrough.com/bean> 
 
 */


void setup() 
{
  Serial.begin(57600);
}


// the loop routine runs over and over again forever:
void loop() 
{
  ScratchData thisScratch = Bean.readScratchData(1);
  
  if ( thisScratch.length >= 4 ) {
	  bool isOn = thisScratch.data[0];
	  bool r = thisScratch.data[1];
	  bool g = thisScratch.data[2];
	  bool b = thisScratch.data[3];
	  
	  if ( isOn ) {
	      Bean.setLed( r, g, b );
	  } else {
	      Bean.setLed( 0, 0, 0 );
	  }
	
  }
  
  Bean.sleep(1000);
}  
