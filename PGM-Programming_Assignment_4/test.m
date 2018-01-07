#!/usr/local/bin/octave -qf 
load('PA4Sample.mat', 'SumProdCalibrate');
CliqueTreeCalibrate(SumProdCalibrate.INPUT, 1)
