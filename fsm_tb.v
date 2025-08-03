`timescale 1ns / 1ps	// Inputs
module fsm_tb();
	reg clk;
	reg rst;
	reg pkt_valid;
	reg parity_done;
	reg soft_reset_0;
	reg soft_reset_1;
	reg soft_reset_2;
	reg fifo_full;
	reg fifo_empty_0;
	reg fifo_empty_1;
	reg fifo_empty_2;
	reg low_pkt_valid;
	reg [1:0] din;

	// Outputs
	wire busy;
	wire detect_add;
	wire ld_state;
	wire laf_state;
	wire full_state;
	wire wr_en_reg;
	wire rst_int_reg;
	wire lfd_state;

	// Instantiate the Unit Under Test (UUT)
	fsm uut (
		.clk(clk), 
		.rst(rst), 
		.pkt_valid(pkt_valid), 
		.parity_done(parity_done), 
		.soft_reset_0(soft_reset_0), 
		.soft_reset_1(soft_reset_1), 
		.soft_reset_2(soft_reset_2), 
		.fifo_full(fifo_full), 
		.fifo_empty_0(fifo_empty_0), 
		.fifo_empty_1(fifo_empty_1), 
		.fifo_empty_2(fifo_empty_2), 
		.low_pkt_valid(low_pkt_valid), 
		.din(din), 
		.busy(busy), 
		.detect_add(detect_add), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.write_enb_reg(write_en_reg), 
		.rst_int_reg(rst_int_reg), 
		.lfd_state(lfd_state)
	);

	/*initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		pkt_valid = 0;
		parity_done = 0;
		soft_reset_0 = 0;
		soft_reset_1 = 0;
		soft_reset_2 = 0;
		fifo_full = 0;
		fifo_empty_0 = 0;
		fifo_empty_1 = 0;
		fifo_empty_2 = 0;
		low_pkt_valid = 0;
		din = 0;*/
		//end

		// Wait 100 ns for global reset to finish
		//#100;
      always 
		begin 
		// Add stimulus here
		clk=1'b0;
		#5 ;
		clk=1'b1;
		#5;
		end
		
	task reset_in;
	begin
	@(negedge clk)
	rst=1'b0;
	@(negedge clk)
	rst=1'b1;
	end
	endtask
	
	task t1();
	begin
		@(negedge clk)
			pkt_valid=1'b1;
			fifo_empty_1=1'b1;
			din=2'b01;
		@(negedge clk)
		@(negedge clk)
			fifo_full=1'b0;
			pkt_valid=1'b0;
			//sft_rst_1=1'b1;
		@(negedge clk)
		@(negedge clk)
			fifo_full=1'b0;
		end
	endtask
	
	

	task t2();
	begin
			@(negedge clk)
				pkt_valid=1'b1;
				fifo_empty_1=1'b1;
				din=2'b01;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b1;
			@(negedge clk)
				fifo_full=1'b0;
			@(negedge clk)
				parity_done=1'b0;
				low_pkt_valid=1'b1;
				//sft_rst_1=1'b0;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b0;
	end
endtask


task t3();
begin
			@(negedge clk)
				pkt_valid=1'b1;
				fifo_empty_1=1'b1;
				din=2'b01;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b1;
			@(negedge clk)
				fifo_full=1'b0;
			@(negedge clk)
				parity_done=1'b0;
				low_pkt_valid=1'b1;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b0;
end
endtask

task t4();
begin
			@(negedge clk)
				pkt_valid=1'b1;
				fifo_empty_1=1'b1;
				din=2'b01;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b0;
				pkt_valid=1'b0;
			@(negedge clk)
			@(negedge clk)
				fifo_full=1'b1;
			@(negedge clk)
				fifo_full=1'b0;
			@(negedge clk)
				parity_done=1'b1;
end
endtask

initial
begin

reset_in;
t1;
t2;

t3;
t4;
//#300; $finish;
end
endmodule
				 
			

