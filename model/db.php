<?php

class DB{
    private $conn;
    private static $instance;

    public $servername;
    public $username;
    public $password;
    public $dbname;
    public $port;

    private function __construct(){
        $config_data = file_get_contents("../config.json");
        $config_content = json_decode($config_data, true);

        $this->servername = $config_content["servername"];
        $this->username = $config_content["username"];
        $this->password = $config_content["password"];
        $this->dbname = $config_content["dbname"];
        $this->port = $config_content["port"];

        $this->conn = new mysqli($this->servername, $this->username, $this->password, $this->dbname, $this->port);

        if($this->conn->connect_error){
            die("Connect failed: " .$this->conn->connect_error);
        }
    }


    public static function getInstance(){
        if(!isset(self::$instance)){
            self::$instance = new DB();
        }
        return self::$instance;
    }

    public function query(string $query){
        return $this->conn->query($query);
    }

    public function addRecord(string $query): int
    {
        $result = $this->conn->query($query);
        if($result) return $this->conn->insert_id;
        return -1;
    }

    public function escapeSpecialCharater($param){
        return $this->conn->real_escape_string($param);
    }

    public function getConn(): string
    {
        return $this->conn;
    }

    public function closeConn(){
        $this->conn->close();
    }

    public function openConn(){
        if($this->conn == null){
            $this->conn = new mysqli($this->servername, $this->username, $this->password, $this->dbname);
            if($this->conn->connect_error){
                die("Connect failed: " .$this->conn->connect_error);
            }
        }
    }
}