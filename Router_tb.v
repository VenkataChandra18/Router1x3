

`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:10:06 04/11/2025
// Design Name:   router_top
// Module Name:   /home1/B115/VNHunaGund/VLSI_RN_OFFLINE/Verilog_labs/Router1X3/router_top/router_top_tb.v
// Project Name:  router_top
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module router_top_tb;

	// Inputs
	reg clock;
	reg resetn;
	reg read_enb_0;
	reg read_enb_1;
	reg read_enb_2;
	reg [7:0] data_in;
	reg pkt_valid;

	// Outputs
	wire [7:0] data_out_0;
	wire [7:0] data_out_1;
	wire [7:0] data_out_2;
	wire valid_out_0;
	wire valid_out_1;
	wire valid_out_2;
	wire error;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	router_top uut (
		.clock(clock), 
		.resetn(resetn), 
		.read_enb_0(read_enb_0), 
		.read_enb_1(read_enb_1), 
		.read_enb_2(read_enb_2), 
		.data_in(data_in), 
		.pkt_valid(pkt_valid), 
		.data_out_0(data_out_0), 
		.data_out_1(data_out_1), 
		.data_out_2(data_out_2), 
		.valid_out_0(valid_out_0), 
		.valid_out_1(valid_out_1), 
		.valid_out_2(valid_out_2), 
		.error(error), 
		.busy(busy)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		resetn = 0;
		read_enb_0 = 0;
		read_enb_1 = 0;
		read_enb_2 = 0;
		data_in = 0;
		pkt_valid = 0;
		forever #5 clock =~clock;
		end
		event e1,e2;
		
		task rst;
		begin
		@(negedge clock);
		resetn =1'b0;
		@(negedge clock);
		resetn = 1'b1;
		end
		endtask
		
		//top tb pl=14
		task pkt_gen_14_1;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin
		@(negedge clock);
		wait(~busy)
		@(negedge clock);
		payload_len = 6'd14;
		addr=2'b01;
		header = {payload_len,addr};
		parity= 8'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity= parity^header;
		
		@(negedge clock);
		wait (~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		@(negedge clock);
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity^payload_data;
		end
		
		@(negedge clock);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;
		end
		endtask
		
		//top tb pl<14
		task pkt_gen_14_2;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin
		@(negedge clock);
		wait(~busy)
		@(negedge clock);
		payload_len = 6'd10;
		addr=2'b01;
		header = {payload_len,addr};
		parity= 8'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity= parity^header;
		
		@(negedge clock);
		wait (~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		@(negedge clock);
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity^payload_data;
		end
		
		@(negedge clock);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;
		end
		endtask
		
		//top tb pl=16
		task pkt_gen_14_3;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin
		@(negedge clock);
		wait(~busy)
		@(negedge clock);
		payload_len = 6'd16;
		addr=2'b01;
		header = {payload_len,addr};
		parity= 8'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity= parity^header;
		
		@(negedge clock);
		wait (~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		@(negedge clock);
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity^payload_data;
		end
		
		@(negedge clock);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;
		end
		endtask
		
		//random payload
		task pkt_gen_14_4;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin
		->e1;
		@(negedge clock);
		wait(~busy)
		@(negedge clock);
		payload_len = {$random}%64;
		addr=2'b00;
		header = {payload_len,addr};
		parity= 8'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity= parity^header;
		
		@(negedge clock);
		wait (~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		@(negedge clock);
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity^payload_data;
		end

		@(negedge clock);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;
		end
		endtask
		
		//top tb pl = 17
		task pkt_gen_14_5;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		integer i;
		begin
		@(negedge clock);
		wait(~busy)
		@(negedge clock);
		payload_len = 6'd17;
		addr=2'b10;
		header = {payload_len,addr};
		parity= 8'b0;
		data_in = header;
		pkt_valid = 1'b1;
		parity= parity^header;
		
		@(negedge clock);
		wait (~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		@(negedge clock);
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity^payload_data;
		end
		->e2;
		@(negedge clock);
		wait(~busy)
		pkt_valid = 1'b0;
		data_in = parity;
		end
		endtask
		

		
		initial
		begin
		rst;
		repeat(3)@(negedge clock);
		pkt_gen_14_1;
		//repeat(2)
		@(negedge clock);
		read_enb_1 = 1'b1;
		wait(~valid_out_1)
		@(negedge clock);
		read_enb_1 = 1'b0;
		
		rst;
		repeat(3)@(negedge clock);
		pkt_gen_14_2;
		//repeat(2)
		@(negedge clock);
		read_enb_1 = 1'b1;
		wait(~valid_out_1)
		@(negedge clock);
		read_enb_1 = 1'b0;
		
		rst;
		repeat(3)@(negedge clock);
		pkt_gen_14_3;
		//repeat(2)
		@(negedge clock);
		read_enb_1 = 1'b1;
		wait(~valid_out_1)
		@(negedge clock);
		read_enb_1 = 1'b0;
		
		rst;
		repeat(3)@(negedge clock);
		pkt_gen_14_4;
		
		//rst;
		//repeat(3)@(negedge clock);
		pkt_gen_14_5;
		
		//#600 $finish;
		
		end
      
		initial
		begin
		@(e1);
		@(negedge clock);
		read_enb_0 = 1'b1;
		repeat (4) @(negedge clock);
		wait(~valid_out_0)
		@(negedge clock);
		read_enb_0 = 1'b0;
		end
		
		initial
		begin
		@(e2);
		@(negedge clock);
		read_enb_2 = 1'b1;
		//repeat (4) @(negedge clk);
		wait(~valid_out_2)
		@(negedge clock);
		read_enb_2 = 1'b0;
		end
endmodule

