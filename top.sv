
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module top();
  // Example 1
  bit clk;
  // Clock generation
  initial begin
    forever
    #1 clk =~clk;
  end
  // Instantiate the interface and DUT
  FIFO_if FIFOif (clk);
  FIFO DUT (
    .clk       (clk),
    .rst_n       (FIFOif.rst_n),
    .wr_en         (FIFOif.wr_en),
    .rd_en         (FIFOif.rd_en),
    .data_in       (FIFOif.data_in),
    .data_out (FIFOif.data_out),
    .wr_ack (FIFOif.wr_ack),
    .overflow  (FIFOif.overflow),
    .full  (FIFOif.full),
    .empty  (FIFOif.empty),
    .almostfull  (FIFOif.almostfull),
    .almostempty    (FIFOif.almostempty),
    .underflow       (FIFOif.underflow)
);




  // run test using run_test task
  initial begin
    uvm_config_db#(virtual FIFO_if)::set(null , "uvm_test_top" , "FIFO_IF" , FIFOif);
  run_test("FIFO_test"); 
  end

 // binding 
bind top FIFO_assertions ASS1 (
    .FIFOif (FIFOif),
    .wr_ptr (DUT.wr_ptr),
    .rd_ptr (DUT.rd_ptr),
    .count  (DUT.count)
);

  
endmodule 