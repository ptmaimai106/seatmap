<?php

require "DB.php";

function getAdminInfo(){
    $db = DB::getInstance();
    $query = "SELECT * FROM `admin`";
    return $db->query($query);
}

function checkLogin(string $username, string $password): int
{
    $db = DB::getInstance();
    $query = "SELECT * FROM `admin` WHERE `admin`.username = '$username' AND `admin`.password = '$password'";
    $result = $db->query($query);
    return $result->num_rows;
}