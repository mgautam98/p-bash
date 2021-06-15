#!/bin/bash

VAR="Linux_course/Linux_course1"

for _ in {0..10000}
do
  TEMP=${VAR##*/}
done