#!/bin/bash

for rowi in {26..52}
do
echo $rowi
  nohup Rscript "bbou_national_priors_table.R" $rowi > nohup_2.out 2>&1
done


