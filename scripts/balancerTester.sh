#!/bin/bash

for i in {1..100}

do

   touch balancerTest.txt

   curl http://10.212.139.132 >> balanserTesting.txt

done

