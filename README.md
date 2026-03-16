# FPGA-Based Numeric System with PS/2 Mouse Interface

This project implements a digital counter on an FPGA development board (e.g., Nexys series) that allows users to increment or decrement a value using a PS/2 mouse. The current count is displayed in real-time on a 7-segment display (SSD).

## 1. Project Specifications
* **Core Functionality**: Counting mouse clicks (Left/Right buttons).
* **Counting Range**: 00 to 99 (with wrap-around logic).
* **Control Inputs**:
    * **RESET**: Hardware button to clear the counter to 0.
    * **REVERSE**: Switch to invert the counting logic (swaps increment/decrement functions between buttons).
* **Visual Feedback**: LEDs indicating which mouse button is active and the current operation mode.

## 2. System Architecture (VHDL Modules)

The project follows a modular design for scalability and easier debugging:

* **`Proiect.vhd`**: The Top-Level module. It integrates all sub-components and implements the main counting logic and state management.
* **`Mouse_D.vhd` & `mouse_led.vhd`**: Handles high-level mouse communication, including the initialization sequence and packet decoding.
* **`ps2_rxtx.vhd`**: A bidirectional unit consisting of:
    * **`ps2_rx.vhd`**: Receives serial data bits from the mouse.
    * **`ps2_tx.vhd`**: Sends commands to the mouse (e.g., the "Enable Data Reporting" command `0xF4`).
* **`SSD.vhd`**: Driver for the 7-segment display, managing anode multiplexing and cathode encoding.
* **`Convertor_decimal.vhd`**: Converts the 8-bit binary counter value into BCD (Binary Coded Decimal) format for the display.
* **`MPG.vhd` (Mono Pulse Generator)**: Provides debouncing for physical buttons on the FPGA board to ensure clean signal transitions.

## 3. Counting Logic

The control logic within `Proiect.vhd` operates as follows based on the **REVERSE** switch:

| Mode (Reverse) | Left Click | Right Click | LED Indicator (LED_IS_LEFT) |
| :--- | :--- | :--- | :--- |
| **OFF (Default)** | Increment (+1) | Decrement (-1) | High ('1') |
| **ON (Inverted)** | Decrement (-1) | Increment (+1) | Low ('0') |

## 4. How to Use

1.  **Hardware Connection**: Connect a PS/2 compatible mouse to the dedicated port on the FPGA board.
2.  **Deployment**: Synthesize, implement, and generate the bitstream using your FPGA tools (e.g., Xilinx Vivado). Flash the `.bit` file to the board.
3.  **Initialization**: Press the **RESET** button. The system will enter the initialization phase to sync with the mouse.
4.  **Operation**:
    * Click the **Left Button** to increase the value.
    * Click the **Right Button** to decrease the value.
    * Flip the **REVERSE** switch to swap the button behaviors.

## 5. Hardware Resources
* **System Clock**: 100 MHz (standard onboard oscillator).
* **I/O Pins**: PS/2 CLK & DATA, 8 Anodes / 8 Cathodes (SSD), Reset Button, Mode Switch, and Status LED.

## 6. Future Improvements
* Add support for X/Y axis movement detection to move a cursor or change values by sliding.
* Implement scroll wheel support for faster incrementing.
* Integrate wireless mouse support via a dedicated adapter.
