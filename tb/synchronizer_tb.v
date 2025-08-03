 
module synch_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [1:0] data_in;
	reg detect_add;
	reg write_enb_reg;
	reg read_enb_0;
	reg read_enb_1;
	reg read_enb_2;

	// Outputs
	wire vld_out_0;
	wire vld_out_1;
	wire vld_out_2;
	wire fifo_full;
	reg empty_0;
	reg empty_1;
	reg empty_2;
	wire soft_reset_0;
	wire soft_reset_1;
	wire soft_reset_2;
	reg full_0;
	reg full_1;
	reg full_2;
	wire [2:0] write_enb;

	// Instantiate the Unit Under Test (UUT)
	synch uut (
		.clk(clk), 
		.rst(rst), 
		.data_in(data_in), 
		.detect_add(detect_add), 
		.write_enb_reg(write_enb_reg), 
		.vld_out_0(vld_out_0), 
		.vld_out_1(vld_out_1), 
		.vld_out_2(vld_out_2), 
		.read_enb_0(read_enb_0), 
		.read_enb_1(read_enb_1), 
		.read_enb_2(read_enb_2), 
		.fifo_full(fifo_full), 
		.empty_0(empty_0), 
		.empty_1(empty_1), 
		.empty_2(empty_2), 
		.soft_reset_0(soft_reset_0), 
		.soft_reset_1(soft_reset_1), 
		.soft_reset_2(soft_reset_2), 
		.full_0(full_0), 
		.full_1(full_1), 
		.full_2(full_2), 
		.write_enb(write_enb)
	);

	initial
		begin
			clk=1'b0;
			forever #5 clk=~clk;
		end
	task reset_1;
	begin
	@(negedge clk);
	rst=1'b0;
	@(negedge clk);
	rst=1'b1;
	end
	endtask
	
	initial
		begin
		reset_1;
		@(negedge clk);
		detect_add=1'b1;
		data_in=2'b10;
		@(negedge clk);
		detect_add=1'b0;
		write_enb_reg=1'b1;
		@(negedge clk);
		{full_0,full_1,full_2}=3'b001;
		@(negedge clk);
		{empty_0,empty_1,empty_2}=3'b110;
		@(negedge clk);
		{read_enb_0,read_enb_1,read_enb_2}=3'b000;
		
		#1000;
		end     
endmodule


