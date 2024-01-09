# OPEN SOURCE ASIC DESIGN
This Repo contains details of designing and implementing a 32 bit (Single Precision)Floating point adder and 32 bit (Single Precision) Floating point multiplier module using Open source ASIC/IC Design tools

# IEEE 754 floating point Representation
Representation of Floating-Point Numbers

A simple representation of a floating-point (or real) number (N) uses a fraction (F), base (B), and exponent (E), where N = F X B^E

F is also called Mantissa and E is also called Exponent

### IEEE 754 has 3 basic components:

The Sign of Mantissa –
This is as simple as the name. 0 represents a positive number while 1 represents a negative number.

The Biased exponent –
The exponent field needs to represent both positive and negative exponents. A bias is added to the actual exponent in order to get the stored exponent.

The Normalised Mantissa –
The mantissa is part of a number in scientific notation or a floating-point number, consisting of its significant digits. Here we have only 2 digits, i.e. O and 1. So a normalised mantissa is one with only one 1 to the left of the decimal.

# Design of Floating Point Adder in Verilog 
