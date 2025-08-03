
module fifo_tb();
reg clk;
	reg rst;
	reg soft_reset;
	reg write_enb;
	reg read_enb;
	reg [7:0] data_in;
	reg lfd_state;
wire empty;
	wire full;
	wire [7:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	fifo uut (
		.clk(clk), 
		.rst(rst), 
		.soft_reset(soft_reset), 
		.write_enb(write_enb), 
		.read_enb(read_enb), 
		.empty(empty), 
		.full(full), 
		.data_in(data_in), 
		.lfd_state(lfd_state), 
		.data_out(data_out)
	);
	integer k;
initial
begin
 {clk,rst,write_enb,read_enb,data_in} = 0;
end
initial
begin
clk = 1'b0;
forever #5 clk = ~clk;
end
task reset;
begin
@(negedge clk)
rst = 1'b0;
@(negedge clk)
rst = 1'b1;
end
endtask

task soft_reset_1;
begin
@(negedge clk)
soft_reset = 1'b1;
@(negedge clk)
soft_reset = 1'b0;
end
endtask

task write;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
begin
@(negedge clk)
payload_len=6'd14;
addr=2'b01;
header={payload_len,addr};
data_in=header;
lfd_state=1'b1;
write_enb=1'b1;
for(k=0;k<payload_len;k=k+1)
begin 
@(negedge clk)
lfd_state<=1'b0;
payload_data<={$random}%256;
data_in=payload_data;
end
@(negedge clk)
parity={$random}%256;
data_in=parity;
end
endtask

task read;
begin
@(negedge clk)
read_enb = 1'b1;
write_enb = 1'b0;
end
endtask
initial
begin
reset;
soft_reset_1;
write;
read;

#500 $finish;
end

//$monitor("clk=%b,rst=%b,we=%b,re=%b,empty=%b,full=%b,d_in=%b,d_out=%b %b %b",clk,rst,we,re,empty,full,d_in,d_out,DUT.wptr,DUT.rptr);
endmodule


