module FIFO_assertions #(
    parameter FIFO_WIDTH = 16,
    parameter FIFO_DEPTH = 8,
    parameter max_fifo_addr = $clog2(FIFO_DEPTH)
)(
    FIFO_if FIFOif,
	input wire [max_fifo_addr-1:0] wr_ptr,
	input wire [max_fifo_addr-1:0] rd_ptr,
	input wire [max_fifo_addr:0]   count
);

// a. Reset Behavior
property p_reset;
    @(posedge FIFOif.clk)
    !FIFOif.rst_n |-> (!wr_ptr && !rd_ptr && !count);
endproperty
assert property (p_reset);
cover  property (p_reset);


// b. Write Acknowledge
property p_wr_ack;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (FIFOif.wr_en && !FIFOif.full) |=> FIFOif.wr_ack;
endproperty
assert property (p_wr_ack);
cover  property (p_wr_ack);


// c. Overflow Detection
property p_overflow;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (FIFOif.wr_en && FIFOif.full) |=> FIFOif.overflow;
endproperty
assert property (p_overflow);
cover  property (p_overflow);


// d. Underflow Detection
property p_underflow;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (FIFOif.rd_en && FIFOif.empty) |=> FIFOif.underflow;
endproperty
assert property (p_underflow);
cover  property (p_underflow);


property p_underflow_clear;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    !(FIFOif.rd_en && FIFOif.empty) |=> !FIFOif.underflow;
endproperty
assert property (p_underflow_clear);
cover  property (p_underflow_clear);


// e. Empty Flag
property p_empty;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (!count) |-> FIFOif.empty;
endproperty
assert property (p_empty);
cover  property (p_empty);


// f. Full Flag
property p_full;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (count == FIFO_DEPTH) |-> FIFOif.full;
endproperty
assert property (p_full);
cover  property (p_full);


// g. Almost Full
property p_almostfull;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    FIFOif.almostfull == (count == FIFO_DEPTH - 1);
endproperty
assert property (p_almostfull);
cover  property (p_almostfull);


// h. Almost Empty
property p_almostempty;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (count == 1) |-> FIFOif.almostempty;
endproperty
assert property (p_almostempty);
cover  property (p_almostempty);


// i. Write Pointer Wraparound
property p_wraparound_wr_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (wr_ptr == FIFO_DEPTH - 1) &&
    FIFOif.wr_en && !FIFOif.full
    |=> (wr_ptr == 0);
endproperty
assert property (p_wraparound_wr_ptr);
cover  property (p_wraparound_wr_ptr);


// Read Pointer Wraparound
property p_wraparound_rd_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    (rd_ptr == FIFO_DEPTH - 1) &&
    FIFOif.rd_en && !FIFOif.empty
    |=> (rd_ptr == 0);
endproperty
assert property (p_wraparound_rd_ptr);
cover  property (p_wraparound_rd_ptr);


// j. Write Pointer Threshold
property p_threshold_wr_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    ($unsigned(wr_ptr) < FIFO_DEPTH);
endproperty
assert property (p_threshold_wr_ptr);
cover  property (p_threshold_wr_ptr);


// Read Pointer Threshold
property p_threshold_rd_ptr;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    ($unsigned(rd_ptr) < FIFO_DEPTH);
endproperty
assert property (p_threshold_rd_ptr);
cover  property (p_threshold_rd_ptr);


// Count Threshold
property p_threshold_count;
    @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
    ($unsigned(count) <= FIFO_DEPTH);
endproperty
assert property (p_threshold_count);
cover  property (p_threshold_count);


// Asynchronous Reset
always_comb begin
    if (!FIFOif.rst_n) begin
        assert final (wr_ptr == 0);
        assert final (rd_ptr == 0);
        assert final (count  == 0);

        cover (
            wr_ptr == 0 &&
            rd_ptr == 0 &&
            count  == 0
        );
    end
end

endmodule