
package FIFO_test_pkg;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_wr_only_seq_pkg::*;
import FIFO_rd_only_seq_pkg::*;
import FIFO_wr_rd_seq_pkg::*;
import FIFO_reset_seq_pkg::*;
import FIFO_idle_seq_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"


class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)
  // Example 1
  FIFO_env env; // handle 
  FIFO_config FIFO_cfg;
  virtual FIFO_if FIFO_vif;
  FIFO_wr_only_seq wr_seq;
  FIFO_rd_only_seq rd_seq;
  FIFO_wr_rd_seq wr_rd_seq;
  FIFO_idle_seq idle_seq;
  FIFO_reset_seq reset_seq;

  // Do the essentials (factory register & Constructor)
  function new(string name = "FIFO_test" , uvm_component parent = null);
  super.new(name,parent);    
  endfunction
  // Build the enviornment in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = FIFO_env::type_id::create("env",this);
    FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);

    // 4 sequences 
    wr_seq = FIFO_wr_only_seq::type_id::create("wr_seq",this);
    rd_seq = FIFO_rd_only_seq::type_id::create("rd_seq",this);
    wr_rd_seq = FIFO_wr_rd_seq::type_id::create("wr_rd_seq",this);
    idle_seq = FIFO_idle_seq::type_id::create("idle_seq",this);
    reset_seq = FIFO_reset_seq::type_id::create("reset_seq",this);

 if(!uvm_config_db #(virtual FIFO_if)::get(this , "" , "FIFO_IF" , FIFO_cfg.FIFO_vif))begin
    `uvm_fatal("build_phase" , "Test unable to get the virtual interface of the FIFO from FIFO_vonfig_db")
 end
uvm_config_db #(FIFO_config)::set(this,"*" , "CFG" , FIFO_cfg);
        
  endfunction
  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  // reset sequence 
  `uvm_info("run_phase" , "Reset Asserted ",UVM_LOW)
  reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase" , "Reset Deasserted ",UVM_LOW)

  // main sequence 
  `uvm_info("run_phase" , " Stimuls generation started ",UVM_LOW)
  `uvm_info("run_phase" , " Write Operation Only ",UVM_LOW)
  wr_seq.start(env.agt.sqr);
  `uvm_info("run_phase" , " Idle Operations ",UVM_LOW)
  idle_seq.start(env.agt.sqr);
  `uvm_info("run_phase" , " Write and Read Operations ",UVM_LOW)
  wr_rd_seq.start(env.agt.sqr);
  `uvm_info("run_phase" , " Read operation Only ",UVM_LOW)
  rd_seq.start(env.agt.sqr);

  // to  reach 100% coverage
  wr_seq.start(env.agt.sqr);
  rd_seq.start(env.agt.sqr);
  `uvm_info("run_phase" , " Stimuls generation finished ",UVM_LOW)
  phase.drop_objection(this);
  endtask : run_phase

endclass
endpackage