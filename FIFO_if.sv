interface FIFO_if (input bit clk);
  parameter int FIFO_WIDTH = 16;

  // Inputs to the design
  logic rst_n;
  logic wr_en, rd_en;
  logic [FIFO_WIDTH-1:0] data_in;

  // Outputs from the design
  logic [FIFO_WIDTH-1:0] data_out;
  logic wr_ack, overflow, underflow;
  logic full, empty, almostfull, almostempty;
endinterface : FIFO_if