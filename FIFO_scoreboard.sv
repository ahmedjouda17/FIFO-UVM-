package FIFO_scoreboard_pkg;
import shared_pkg::*;
import FIFO_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class FIFO_scoreboard extends uvm_scoreboard;
`uvm_component_utils(FIFO_scoreboard)
uvm_analysis_export #(FIFO_seq_item) sb_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
FIFO_seq_item seq_item_sb;
logic [FIFO_WIDTH - 1:0] data_out_ref;
int correct_count = 0;
int error_count = 0;


    function new (string name = "FIFO_scoreboard" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase); super.run_phase(phase);
forever begin
    sb_fifo.get(seq_item_sb);
    ref_model(seq_item_sb);
     if(seq_item_sb.data_out != data_out_ref)begin
            `uvm_error("run_phase" , $sformatf ("comparison failed ,Transaction received by the DUT:%s while the reference out :0b%0b",
                seq_item_sb.convert2string(),data_out_ref));
                error_count++;
        end
        else begin
           `uvm_info("run_phase", $sformatf("correct shift_reg dataout = %s",seq_item_sb.convert2string()),UVM_HIGH);
           correct_count++; 
        end  
end
endtask


// QUEUE -----> SMALL FIFO TO CHECK DATA OUT 
reg [FIFO_WIDTH - 1:0] queue[$];

    task ref_model(FIFO_seq_item seq_item_chk);
     bit was_empty, was_full;

    if (!seq_item_chk.rst_n) begin
        queue.delete();
        data_out_ref = '0;
    end 
    else begin
        was_empty = (queue.size() == 0);
        was_full  = (queue.size() == FIFO_DEPTH);

        // write 
        if (seq_item_chk.wr_en && !was_full)
            queue.push_back(seq_item_chk.data_in);

        // read 
        if (seq_item_chk.rd_en && !was_empty)
            data_out_ref = queue.pop_front();
    end
    endtask



    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total Succefful transaction : %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total Failed transaction : %0d",error_count),UVM_MEDIUM);        
    endfunction
        
    

endclass 
endpackage