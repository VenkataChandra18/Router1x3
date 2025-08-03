module register_tb;

	// Inputs
	reg clk;
	reg rst;
	reg pkt_valid;
	reg fifo_full;
	reg rst_int_reg;
	reg detect_add;
	reg ld_state;
	reg laf_state;
	reg full_state;
	reg lfd_state;
	reg [7:0] data_in;

	// Outputs
	wire parity_done;
	wire low_pkt_valid;
	wire err;
	wire [7:0] dout;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	register uut (
		.clk(clk), 
		.rst(rst), 
		.pkt_valid(pkt_valid), 
		.fifo_full(fifo_full), 
		.rst_int_reg(rst_int_reg), 
		.detect_add(detect_add), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.lfd_state(lfd_state), 
		.data_in(data_in), 
		.parity_done(parity_done), 
		.low_pkt_valid(low_pkt_valid), 
		.err(err), 
		.dout(dout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		pkt_valid = 0;
		fifo_full = 0;
		rst_int_reg = 0;
		detect_add = 0;
		ld_state = 0;
		laf_state = 0;
		full_state = 0;
		lfd_state = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		end
      initial
		begin
		clk=1'b0;
		forever #5 clk=~clk;
		end
		
		task reset_in;
		begin
			@(negedge clk)
			rst=1'b0;
			@(negedge clk)
			rst=1'b1;
		end
		endtask
			task packet_generation;
			reg[7:0]payload_data,parity,header;
			reg[5:0]payload_len;
			reg[1:0]addr;
			
		
		begin
			@(negedge clk)
			payload_len=6'd10;
			addr=2'b10;
			pkt_valid=1'b1;
			detect_add=1'b1;
			header={payload_len,addr};
			data_in=header;
			parity=8'h00^header;
		
			@(negedge clk)
			detect_add=1'b0;
			lfd_state=1'b1;
			full_state=1'b0;
			fifo_full=1'b0;
			laf_state=1'b0;
			for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clk)
			lfd_state=1'b0;
			ld_state=1'b1;
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;
		end
			@(negedge clk)
			pkt_valid=1'b0;
			data_in=parity;
			@(negedge clk)
			ld_state=1'b0;
		end
		endtask
		initial
		begin
		reset_in;
		packet_generation;
#1000 $finish;
		end
	
      
endmodule


