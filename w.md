
RF Signal Generator

This signal generator is intended for realignment of radio receivers. The unit is cheap and fairly basic, but perfectly adequate for its intended purpose. However, the output is not a pure sine wave, so the unit may not be suited for more exacting electronic development work.

This photo was kindly supplied by Richard Hanes. Richard added an extra frequency band (up to 30MHz) as detailed towards the end of this article.

The unit covers a frequency range of 150KHz to 12MHz over five ranges (shown below). It is therefore suited to the alignment of RF and IF sections of AM (MW and LW) sets, as well as the IF sections of FM (VHF) circuits. It may also be used for RF alignment of SW circuits from 25 to 49 metres.

Range


Frequency


Inductor Value

A


150KHz - 500KHz


2.2mH

B


350KHz - 1MHz


470uH

C


750KHz - 2.25MHz


100uH

D


1.6MHz - 5MHz


22uH

E


3.5MHz - 12MHz


4.7uH

The output may be amplitude modulated by an internal 800Hz audio tone (approx. 30% modulation) or by an external signal. The output level is adjustable in two ranges up to a maximum of about 4V pk-pk. The unit is mains powered.

Circuit Description

If the diagrams on this page are not clear enough, you can download higher resolution copies. See the foot of this page for details.

TR1 is a high gain FET (Field Effect Transistor) and is configured as a Colpitts style oscillator. The oscillation frequency is set by the variable capacitor (C1+C2) and the five pairs of switched inductors. There is significant overlap between the ranges, due to the limited range of readily available inductors. However even by using specially would inductors, four frequency bands would have been needed to cover the range.

Circuit Diagram

The RF output is buffered by TR2, which is configured as an emitter follower. The output signal is developed across R6, and passes to the output sockets via variable and switched attenuater circuits.

The signal is amplitude modulated by varying the supply voltage to the oscillator circuit. This is carried out by TR3, which is an emitter follower. C10 decouples the feed at RF.

It should be noted that this modulation method does cause a small amount of unwanted frequency modulation as well as the desired amplitude modulation. If the unit was being used for listening to music on a radio this could cause a slight shrillness to the sound. However the arrangement has the advantage that it does not distort the RF waveform, which is important for alignment. It is also simpler to implement and gives consistent results - important requirements for this sort of project. As with any design there are always better ways of doing things, but this would result in a more expensive design that was more difficult to construct, and would not offer any significant advantages in practice.

SW2 selects either the internal or an external modulation signal. If no modulation is required, the switch is set to the external position with no signal applied to SK3. To give reasonable modulation the external signal should be about 1.5V RMS (4V pk-pk). If a music signal is used, the bandwidth should not extend above about 8KHz due to the limits of AM broadcasting. C10 will roll-off the higher frequencies to some extent. The selected modulation signal is buffered by TR4 and made available on SK4. This is useful for triggering an oscilloscope.

TR5 is configured in an R-C oscillator circuit. The frequency is set by C15, C16, C17, R19, R20 and R21 to about 800Hz. If you wish to alter the frequency, note that altering the value of R19 will affect the biasing of the transistor. Any variations should be carried out by changing the values of the capacitors rather than the resistors. R14 and C13 act as a filter to remove any distortion on the output.

The circuit is powered from a regulated 15V supply, and consumes about 30mA. IC1 is a standard three-pin 100mA regulator, fed by the full-wave rectified supply from a small mains transformer.

Update

John Shepherd has built this project and made the following comments:

    I had to reduce the value of R18 to 180K to get it to oscillate reliably.

    Also is the value of C13 right at 22nF - seems a bit high and it attenuates the signal too much on my version.

The audio oscillator is quite particular about the types of capacitor used for C15, 16 and 17. I used ceramic discs - and with these 220K for R18 was fine. Maybe the resistor needs to be adjusted to suit the transistor used?

22nF is the value I used for C13 - it is intended to improve the waveshape and will attenuate the signal a bit.

Has anyone else had the same problems as John?

Construction

The prototype was constructed on a piece of plain matrix board. Stripboard is not suitable because of the capacitance between adjacent tracks. A PCB could be designed, but this should follow the same general layout as the matrix board.

Circuit Board and Wiring

In the diagram the components and wires on the top face of the board are shown in black, while the underside connections are grey. Much of the circuit board wiring can be carried out using the component leadout wires, with pieces of tinned copper wire added where these are not long enough.

Note that there is an error on the above diagram. TR2 should be shown as a D shaped package the same as the others (with the flat face towards TR1).

John Shepherd has designed a PCB for this project. The files are available to download from this website, the link is at the bottom of this page. Doug Baird added:

    On the PCB, there seems to be a pad missing for the pot that is at the front of the board. I am including a PCB that I did. Sorry about taking the audacity to use the one there, then modify it but I am sending it along as a gif attachment. Use it if you like.

Doug's PCB file is also available below.

The unit should be built into a suitable metal cabinet to give adequate screening. This should be earthed via the earth wire of three-core mains flex.

C1+C2 is a Jackson Type-O air spaced variable capacitor. This is the most expensive component in the unit, costing around £15. However valve radio enthusiasts should be able to salvage something suitable from a scrap set.

You may wish to arrange a suitable pointer and scale if you intend to calibrate the unit. A suitable ball reduction drive and pointer (also made by Jackson) are available from Maplin and other suppliers. Alternatively, you may be able to use the scale and pointer arrangement from a scrap set.

The inductors are mounted on the rear of the rotary switch as shown. This should be positioned close to the variable capacitor to keep the wire lengths to a minimum. In addition, the circuit board should be positioned to give a minimum wire length to the variable capacitor and switch.

Thanks to Gary Tempest for these comments:

    Built the sig gen. You might want to point out to others that coil positioning is critical. I used a sub-miniature switch and everthing very tight and short. NOT GOOD. The coils, even ones not in use, couple to those that are and 'pull' giving strange effects. Also, if the two coils for the highest frequency range are placed along side each other you only get about 10 MHz max. Move them apart by 10 mm and you get up to 12 MHz. Because positioning affects the calibration, before completing this I fixed coils and 'front end' wiring (tuning cap etc.) with clear silicon sealer.

Richard Hanes agrees:

    I would support Gary's comments. The coils need to be laid out radially from a standard size switch or there is all manner of interaction. Your diagram, while presumably intended to be pictorial, is close to the optimum physical!

The transformer should be mounted towards the back of the case, well away from the RF tuning components. If a transformer with flying leads is used, these may be joined to the mains flex with a choc-block connector.

It may be worth including the Audio Output Level Indicator (shown elsewhere on this web site) in the same case. The two units would generally be used together so this could be a useful combination.

Accurate Calibration

For accurate calibration, a frequency calibrator or accurate oscilloscope is required. The unit may be set for various frequencies and these should be marked on the scale. Mark the scale every 5KHz between 400 and 500KHz if possible, so that the AM IF frequency (typically 455KHz, 465KHz or 470KHz) may be accurately set. Also, make every 0.1MHz between 10.4MHz and 11MHz, to allow the FM IF of 10.7MHz to be accurately set.

Alternatively, a good quality Short Wave receiver with digital readout may be used. With the internal modulation switched on, connect the unit to the receiver aerial connection. Set the receiver to the required frequency and adjust the signal generator frequency until the tone is heard.

Alternative Calibration

If none of these items are available, you should be able to adjust part of the range with a normal broadcast radio, as described above. If you have a good quality Hi-Fi receiver with a digital readout this would be better, otherwise use a set where the calibration is known to be good.

If the receiver does not have an external aerial connection, connect a coil of a few turns of wire about 6" (150mm) in diameter to the signal generator output, and position this close to the receiver.

You should be able to pick up the third harmonic of the frequencies between the MW and LW bands, at the appropriate position on the MW band. Thus, you should be able to tune in the third harmonic of 400KHz at 1200KHz.

Between 450KHz and 480KHz you could hit the IF frequency of the radio. This is generally fairly obvious, as the radio's tuning control will have little effect. It is also possible for the unit to beat with the radio's local oscillator, so do not be too concerned if the results do not seem to make sense. If it does not seem to work properly, try using a different radio.

You will not be able to calibrate frequencies above the top of the MW band (about 1600KHz) by this method. However for most radio alignment work this will not be a problem.

For alignment of VHF sets you will need to know the position of the IF (10.7MHz). Connect the unit to the aerial of an FM radio, turn the modulation off and set the output level to maximum. Tune the set to a weaker station on FM, and then adjust the signal generator frequency around the top band. When the IF of the set (invariably 10.7MHz) is found the reception should become much weaker or disappear altogether. This works better with some radios than others - and is generally more effective on cheap transistor sets.

Parts List

Resistors (all 5% 0.25W or better)


Capacitors

R1


1K2


C1+C2


365pF + 365pF Variable

R2


47K


C3,6,7,9,11,12


100nF

R3,10,12


22K


C4,5


100pF

R4


10K


C8


100nF 160V

R5


2K2


C10


2.2nF

R6,13,17


470R


C13


22nF

R7


150R


C14


1uF

R8


1K0


C15,16,17


4.7nF

R9


68R


C18


100uF

R11,14


15K


C19


100nF

R15


100R


C20


1000uF

R16


4K7


R18


220K


Miscellaneous

R19,20,21


27K


SW1,2


SPDT Toggle or Slide Switch

VR1


1K0 Lin Pot


SW3+SW4


2 Pole 6 Way Rotary Switch (1 off)


X1


15-0-15V 100mA Transformer

Inductors


SK1,2,3,4,5


4mm Socket or Binding Post

L1,2


2.2mH


Metal case

L3,4


470uH


Plain matrix board

L5,6


100uH


Tinned copper wire

L7,8


22uH


Knobs

L9,10


4.7uH


Materials for pointer


Mains flex

Semiconductors


13A plug with 3A fuse

D1,2


1N4002


Choc-block connector

TR1


BF244A


TR2,3,4,5


BC548C


IC1


78L15


High resolution copies of the circuit and layout diagrams (in .GIF, CorelDRAW 7 and ISIS Lite formats) are available for download in a ZIP file. File size is 267K. To download a copy Click Here.

The artwork files for a PCB for this project, designed by John Shepherd (in .GIF and Ares Lite formats) are available for download in a ZIP file. File size is 25K. To download a copy Click Here.

A version of the PCB layout by Doug Baird, which includes a pad apparently missing on the above one, is available as a GIF file. To view and save a copy Click Here.

Note that ISIS Lite and ARES Lite are unlimited shareware products. The unregistered versions don't expire but do nag you about registering. Registration is about £30 for both products together, which adds extra features and removes the nagging. They are available from http://www.proteuslite.com.

Variations

Richard Hanes has constructed a version with an additional range covering 10-30MHz:

    The variable capacitor that I had to hand was only 275+275pF so I used twice your values for the lower ranges and added 1u0H for the top range. (I also used BF256A for the FET - my guess is that it makes little difference, but I don't have a BF244 to try). Values and frequencies covered are as follows:

4m7H 	140 - 350 KHz
1m0H 	300 - 800 KHz
220uH 	0.65 - 1.8 MHz
47uH 	1.5 - 4.6 MHz
10uH 	3.0 - 10.5 MHz
1u0H 	10 - 34 MHz

    I found that a 470K gate resistor (R2) gave more consistent levels across ranges (possibly associated with the higher impedance of my tuned components).

    I would support Gary's comments (as reproduced on the website). The coils need to be laid out radially from a standard size switch or there is all manner of interaction. Your diagram, while presumably intended to be pictorial, is close to the optimum physical! To get to 30+MHz the leads must be kept short and thick, as is usual at these frequencies. I found 18swg tinned copper supported the components nicely and worked well.

    The unit is built into a standard die-cast box about 7" x 5" x 2" with external plug-top psu (the latter being an oddball supplying 19VAC at 100mA).

    I have made some minor tweaks in the attenuator department to give me the ranges shown and to "peak" the response at the top end (as the level does otherwise fall several dBs up at 30MHz). Its not a precision generator, but it is excellent for the intended purpose and considering the cost!!!

The "oddball" power supply adaptor that Richard used probably originally belonged to a modem. Many Hayes modems, from the days when 28k was fast, came with AC adaptors producing around this voltage. The adaptors are still useful, but the modems aren't!

<- Previous

Projects Menu

Next ->

Home
This website, including all text and images not otherwise credited, is copyright © 1997 - 2006 Paul Stenning.
No part of this website may be reproduced in any form without prior written permission from Paul Stenning.
All details are believed to be accurate, but no liability can be accepted for any errors.
The types of equipment discussed on this website may contain high voltages and/or operate at high temperatures.
Appropriate precautions must always be taken to minimise the risk of accidents.
Last updated 14th April 2006.
