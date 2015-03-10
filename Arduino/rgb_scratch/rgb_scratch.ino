#include <Adafruit_NeoPixel.h>

#define PIN 4
#define NUM_PIXELS 30

/*
  rgb_scratch
 
 Checks scratch bank 1. Blinks LED the color of the value passed in.
 Byte 0: on/off
 Byte 1: Red
 Byte 2: Green
 Byte 3: Blue
 
 <http://www.punchthrough.com/bean> 
 
 */

// Set up the NeoPixel strip.
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUM_PIXELS, PIN, NEO_GRB + NEO_KHZ800);

void setup() 
{
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'

}

void updateLight( bool isOn, int r, int g, int b ) {
  uint32_t c = strip.Color( r, g, b );
  if ( isOn ) {
    colorWipe( c, 50 );
  } 
  else {
    colorWipe( strip.Color( 0, 0, 0 ), 50 );
  }
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
      strip.setPixelColor(i, c);
      strip.show();
      delay(wait);
  }
}

bool compareScratch( ScratchData * scratch1, ScratchData * scratch2 )
{
  bool matched = true;
  
  if ( scratch1->length != scratch2->length )
  {
    matched = false;
  }
  else
  {
    int length = min( scratch1->length, scratch2->length );
    int i = 0;
    
    while ( i < length )
    {
      if ( scratch1->data[i] != scratch2->data[i] )
      {
        matched = false;
        i = length;
      }
      i++;
    }
  }
  
    return matched;
}

// the loop routine runs over and over again forever:
ScratchData lastScratch;
void loop() 
{
  ScratchData thisScratch = 
    Bean.readScratchData(1);

  bool matched = compareScratch( &thisScratch, &lastScratch );
  if ( thisScratch.length >= 4 && !matched ) {
    bool isOn = thisScratch.data[0];
    int r = thisScratch.data[1];
    int g = thisScratch.data[2];
    int b = thisScratch.data[3];

    updateLight( isOn, r, g, b );
    lastScratch = thisScratch;
  }

  Bean.sleep(1000);
}  


