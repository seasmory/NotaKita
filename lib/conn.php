<?php
$connect = new mysqli("localhost","root","","student");

if($connect){
    echo "Connection Success";
}else{
    echo "error";
    exit();
}