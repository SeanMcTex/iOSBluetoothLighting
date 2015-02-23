# Building a Custom iOS-Controlled Lighting System

I recently moved into a new apartment. It's a great place, except for one glaring omission: the built-in desk area has terrible light. I looked online a bit, and discovered that there are excellent LED strip lights that would fit under an overhanging shelf and illuminate the desk beatifully. 

But I am an Engineer! And Engineers love to build stuff! I decided the preferable course would be to create my own lighting system. With LEDs that can display custom colors. And make it controlled by iOS. 

More expensive, harder to build, and probably won't work as well? NOW WE'RE TALKING!

Because I've done most of my hobby electronics work on the [Arduino](http://arduino.cc), I decided to use one of those as the controller for the project. I'd recently learned about the [LightBlue Bean](https://punchthrough.com/bean/), a super-cool Arduino controller that adds Bluetooth 4.0 to the standard Arduino formula. The Bluetooth support would allow it to easily talk with an iOS or Android phone. (Android support is left as an exercise to the reader, because I don't know how to do it.) The [NeoPixel](http://www.adafruit.com/category/168) LEDs work well, and since you can wire a ton of them in serial, keep the wiring hassle to a minimum. And since the LEDs won't run long on battery power, a 5v power supply:

Thus, our parts list:

- [Adafruit NeoPixel Digital RGB LED Strip - White 30 LED - 1m](http://www.adafruit.com/products/1376)
- [LightBlue Bean](https://punchthrough.com/bean/)
- 3v Power Supply
- Pushbutton Switch
- Wires and solder and that stuff

In addition, since we'll be making an iOS app to control the project, we'll need Xcode and an iPhone. (The simulator won't be much use, since we'll need the Bluetooth support.)

## Step 1: Wire Up the Parts

We don't want to have to be replacing batteries all the time, so an external power supply seems the way to go. There's one potentially tricky problem here: the NeoPixel strip expects 5v, and the Bean runs at 3.3v. Fortunately, per ["Powering the NeoPixel"](https://learn.adafruit.com/adafruit-neopixel-uberguide/power), "Lower voltages are always acceptable, with the caveat that the LEDs will be slightly dimmer." Dimmer is OK; having our project catch fire and burn our house to the ground is not. Thus, we'll use a 3v external supply.

We'll also put a few other safety measures in place: In order to prevent power surges when the power supply is connected up, we'll bridge the pins from the power supply with a capacitor. The NeoPixel folk also recommend including a resistor between the control board and the strip's data pin, so we'll do that as well.

With all that in mind, here's what our final wiring diagram ends up looking like:



## Step 2: The Arduino Software

The Bean's software supports communicating over Bluetooth two different ways: using a virtual wireless serial port, and through five "Scratch" BTLE characteristics. The latter will be accessible to any Bluetooth device that connects to the Bean, but the former will be more familiar to folks who have been using Arduino for other purposes. Since all we need to send is RGB values, and we have the Bean SDK for iOS which makes accessing the serial port easy, we'll use it.

In addition to allowing the lights to be controlled from an iOS device, we'd also like to be able to use a hardware button to turn them on or off. This will be useful for those rare cases when we don't have our phone with us or we don't feel like pulling it out of a pocket.

To allow our Arduino and iOS software to talk to each other, we need to agree on a way our data will be sent over the serial port. Since we're interested in communicating RGB color values from the app to the Bean, we'll just plan to send and receive color values in 3-byte groups. (To turn the lights off, we just send 0,0,0.)

Here are some of the more interesting bits from the Arduino code:

### Setting everything up:

### Turn on/off all the lights when the button is pressed:

### Respond to Serial Data:


## Step 3: The iOS Software

Since we're a mobile shop, it would seem silly not to write our own custom software to control the project. All we'll really need for this is an on/off switch, a color picker, and some UI to connect to the bean. iOS doesn't come with a color picker control, but there are many open source efforts available in the [usual spots](https://www.cocoacontrols.com). Since we'll be communicating through the serial connection, we'll also want to include LightBlue's iOS SDK for the bean.

## Step 4: Profit?

