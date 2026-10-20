package FIFO_coverage_pkg;
import FIFO_seq_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_coverage extends uvm_component;
`uvm_component_utils(FIFO_coverage)
uvm_analysis_export #(FIFO_seq_item) cov_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
FIFO_seq_item seq_item_cov;

covergroup CovCode;

// ============= COVERPOINTS INPUTS ================== 

// coverpoint write  
wr_en_cp : coverpoint seq_item_cov.wr_en {
    bins wr_en_0 = {0};
    bins wr_en_1 = {1};
}

//  coverpoint read  
rd_en_cp : coverpoint seq_item_cov.rd_en {
    bins rd_en_0 = {0};
    bins rd_en_1 = {1};
}

// ============= COVERPOINTS OUTPUTS ================== 

// coverpoint Write Acknowledge 
wr_ack_cp : coverpoint seq_item_cov.wr_ack {
    bins wr_ack_0 = {0};
    bins wr_ack_1 = {1};
}

// coverpoint overflow 
overflow_cp : coverpoint seq_item_cov.overflow {
    bins overflow_0 = {0};
    bins overflow_1 = {1};
}

// coverpoint full 
full_cp : coverpoint seq_item_cov.full {
    bins full_0 = {0};
    bins full_1 = {1};
} 

// coverpoint empty 
empty_cp : coverpoint seq_item_cov.empty {
    bins empty_0 = {0};
    bins empty_1 = {1};
} 

// coverpoint almostfull  
almostfull_cp : coverpoint seq_item_cov.almostfull {
    bins almostfull_0 = {0};
    bins almostfull_1 = {1};
} 

// coverpoint almostempty  
almostempty_cp : coverpoint seq_item_cov.almostempty {
    bins almostempty_0 = {0};
    bins almostempty_1 = {1};
} 

// coverpoint underflow  
underflow_cp : coverpoint seq_item_cov.underflow {
    bins underflow_0 = {0};
    bins underflow_1 = {1};
} 


// =================== CROSS COVERAGE =====================


cross_1 : cross wr_en_cp, rd_en_cp, wr_ack_cp {
    ignore_bins no_write_ack =
        binsof(wr_en_cp)  intersect {0} &&
        binsof(wr_ack_cp) intersect {1};
}

cross_2 : cross wr_en_cp, rd_en_cp, overflow_cp {
    ignore_bins no_write_overflow =
        binsof(wr_en_cp)    intersect {0} &&
        binsof(overflow_cp) intersect {1};
}

cross_3 : cross wr_en_cp, rd_en_cp, full_cp {
    ignore_bins full_after_read =
        binsof(rd_en_cp) intersect {1} &&
        binsof(full_cp)  intersect {1};
}

cross_4 : cross wr_en_cp, rd_en_cp, empty_cp {
    ignore_bins empty_after_write =
        binsof(wr_en_cp) intersect {1} &&
        binsof(empty_cp) intersect {1};
}

cross_5 : cross wr_en_cp, rd_en_cp, almostfull_cp;
cross_6 : cross wr_en_cp, rd_en_cp, almostempty_cp;

cross_7 : cross wr_en_cp, rd_en_cp, underflow_cp {
    ignore_bins no_read_underflow =
        binsof(rd_en_cp)     intersect {0} &&
        binsof(underflow_cp) intersect {1};
}

endgroup



    function new (string name = "FIFO_coverage" , uvm_component parent = null);
        super.new(name,parent);
        CovCode =new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export",this);
        cov_fifo = new("cov_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item_cov);
        CovCode.sample();
    end
    endtask
endclass 
endpackage