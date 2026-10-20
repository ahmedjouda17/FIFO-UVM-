package FIFO_seq_item_pkg;
  timeunit 1ns; timeprecision 1ps;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import shared_pkg::*;

  class FIFO_seq_item extends uvm_sequence_item;
    `uvm_object_utils(FIFO_seq_item)
    rand bit rst_n, wr_en, rd_en;
    rand bit [FIFO_WIDTH-1:0] data_in;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow, underflow, full, empty, almostfull, almostempty;


    constraint reset_c {rst_n dist {1:=95 , 0 :=5};}
    constraint write_c {wr_en dist {1:=WR_EN_ON_DIST , 0:=100 - WR_EN_ON_DIST};}
    constraint read_c {rd_en dist  {1:=RD_EN_ON_DIST , 0:=100 - RD_EN_ON_DIST};}

    function new(string name="FIFO_seq_item");
     super.new(name);
    endfunction

    function string convert2string();
      return $sformatf(" %s rst_n=%b wr_en=%b rd_en=%b data_in=%h data_out=%h ack=%b overflow=%b underflow=%b full=%b empty=%b almostfull=%b almostempty=%b",
       super.convert2string(),  rst_n,wr_en,rd_en,data_in,data_out,wr_ack,overflow,underflow,full,empty,almostfull,almostempty);
    endfunction

      function  string convert2string_stimuls();
        return $sformatf("rst_n=%b wr_en=%b rd_en=%b data_in=%h data_out=%h ack=%b overflow=%b underflow=%b full=%b empty=%b almostfull=%b almostempty=%b",
        rst_n,wr_en,rd_en,data_in,data_out,wr_ack,overflow,underflow,full,empty,almostfull,almostempty);
    endfunction
  endclass
endpackage : FIFO_seq_item_pkg

