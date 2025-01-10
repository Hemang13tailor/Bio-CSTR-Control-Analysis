clear all
clc

Nr = [-13.8197];
Dr = [4.5441 1];

sys = tf(Nr, Dr);

rlocus(sys);