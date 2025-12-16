#!/bin/bash

for rowi in {1..25}
do
echo $rowi
  nohup Rscript "bbou_national_priors_table.R" $rowi
done


