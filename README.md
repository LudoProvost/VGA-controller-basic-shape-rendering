# VGA controller with basic shape rendering
Simple VGA controller made in verilog which writes to an output.txt file in PPM format which can later be opened with the VGA_px_gen_debug.py python scrypt as a PNG.

## How to run
1. Change the path to the output.txt on line 19 of ppm_file_writer.v
2. Select which shape you want generated in vga_controller_tb.v (line 76, 78, 80)
3. Color values can be changed as explained thoroughly in the testbench.

### Using different precision for gradient circle
The precision parameter should be set between 0 and 8. The number of different shades will be given by 2^precision. Shown below is the same gradient circle but with different precision levels.

#### Precision = 8:

![gradient_circle_LUT_prec8](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/637e8141-7d59-4c3f-be5c-d89462b5553f)

#### Precision = 5:

![gradient_circle_LUT_prec5](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/3a11a2cb-0792-429b-952a-574a59623923)

#### Precision = 1:

![gradient_circle_LUT_prec1](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/69717db6-1f43-455f-8639-1834cda6bbcf)

## Render examples
### Outwards gradient circle
The following gradient circle was generated with these values:
- rad = 200
* x0 = 320
+ y0 = 240
- outwardGradient = 0
* precision = 8
+ R = mid_i
- G = mid_i
* B = 255

![gradient_circle_LUT_prec8 (2)](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/915a84f9-1cd1-413b-baff-18105ff75210)

### Inwards gradient circle
The following gradient circle was generated with these values:
- rad = 100
* x0 = 320
+ y0 = 240
- outwardGradient = 1
* precision = 8
+ R = mid_i
- G = 0
* B = 0

![gradient_circle_LUT_prec8](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/f35397aa-2247-4954-a745-edff4802f455)

### Circle
The following circle was generated with these values:
- rad = 100
* x0 = 320
+ y0 = 240
- R = 100
* G = 255
+ B = 150

![image](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/2e77fa48-08d9-488d-96bc-67d9c0066eaa)

### Rectangle
The following rectangle was generated with these values:
- width = 200
* height = 100
+ x0 = 200
- y0 = 140
* R = 0
+ G = 255
- B = 0

![rectangle](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/889cb368-8a97-4c8e-8a74-8f8a7e34bf5c)

## Simulation wave form example
Full sim:

![sim_wf](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/139a596d-1d69-4c2f-a957-b18357251798)

Zoomed in:

![sim_wf_zoomed](https://github.com/LudoProvost/VGA-controller-basic-shape-rendering/assets/70982826/b9e6057a-5a5f-4681-84b3-5a8214cd7677)
