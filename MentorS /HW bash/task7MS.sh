#!/bin/bash

add() {
    local num1=$1
    local num2=$2
    local sum=$((num1 + num2))
    echo "$num1 + $num2 = $sum"
}

read -p "Введите первое число: " number1
read -p "Введите второе число: " number2

add "$number1" "$number2"
