clear all
clc

Nr = [26.4035];
Dr = [4.3716 1];

sys = tf(Nr, Dr);

rlocus(sys);