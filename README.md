# Low-area-AES-on-FPGA

This project was implemented for EEE6225 System Design module in University of Sheffield 2018-2019 

Group members: Yuche Huang, Yukun Liu, Congbo Zhang, Jiahan Zhang


## Abstract 
* This project is our implementation of low-area AES on FPGA with permission of our group mates to upload

* The system is acheived by 572 slices and offering 55.59 Mbps as thruoghput

* The detial of the deisgn can be found in the [report](https://github.com/yuchehuang/Low-area-AES-on-FPGA/blob/master/Low%20area%20implementation%20of%20AES%20on%20FPGA.pdf)

## Advice 

The design still has something to improve. Due to some of the registers is created by ourselves, the slice used of the component is not optimised by the development sofware (xilinx) and will occupy a considerable slice. I recommend future students to use the components which is existed in the libraries directly to avoid the issue we encountered to achieve the work in low-area as the aim.

Please feel free to use as the reference material and do not copy it directly. It will be identified by plagiarism detection software. 