<?php
include_once "DB.php";


class SeatmapModel{
    protected $db;

    public function __construct(){
        $this-> db = DB::getInstance();
    }

    public function getSeatmaps()
    {
        $query = "SELECT * FROM seatmap";
        $result = $this->db->query($query);
        return $result;
    }

    public function getSeatmap(int $id)
    {
        $query = "SELECT * FROM seatmap WHERE id=$id";
        $result = $this->db->query($query);
        return $result;
    }

    public function addSeatmap(string $name,string $filename): int
    {

        $queryAdd = "INSERT INTO `seatmap`( `name`, `filename`)VALUES ('$name','$filename')";
        $insert_id = $this->db->addRecord($queryAdd);
        return $insert_id;
    }

    public function editSeatmap(int $id,string $name,string $filename): bool
    {
        $queryEdit =  "UPDATE `seatmap` SET `name`='$name',`filename`='$filename' WHERE id=$id";
        $result = $this->db->query($queryEdit);
        return $result;
    }

    public function deleteSeatmap(int $id): bool
    {
        $queryDelete = "DELETE FROM `seatmap` WHERE id=$id ";
        $result = $this->db->query($queryDelete);
        return $result;
    }

}
