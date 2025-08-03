

module router_fifo(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,data_out,full,empty);
   input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
   input [7:0]data_in;
   output full,empty;
   output reg [7:0]data_out;
   reg[8:0]mem[0:15];
   reg[4:0] wr_ptr;
	reg [4:0] read_ptr;
	reg [6:0]counter;
	reg lfd_s;
	integer i;
	
	always@(posedge clock)
	begin
	if(resetn == 1'b0)
	lfd_s <= 1'b0;
	else 
	lfd_s <= lfd_state;
	end
	
   always@(posedge clock)
     begin
	     if(resetn==1'b0)
	     begin
		     for(i=0; i<16; i=i+1)
		     begin
			     mem[i]<=9'h0;
			     wr_ptr<=5'b0;
		     end
	     end
		  
      //write operation
	     else if(soft_reset==1'b1)
	     begin
		     for(i=0;i<16;i=i+1)
		     begin
			     mem[i]<=9'h0;
			     wr_ptr<=5'b0;
		     end
	     end

	     else if(write_enb == 1'b1 && full == 1'b0)
	     begin
		     mem[wr_ptr[3:0]]<={lfd_s,data_in};
		     wr_ptr<=wr_ptr+1'b1;
	     end
     end

     //read operation

     always@(posedge clock)
     begin
	     if(resetn==1'b0)
	     begin
		     data_out<=8'h0;
		     read_ptr<=5'b0;
	     end

	     else if(soft_reset==1'b1)
	     begin
		     data_out<={8{1'bz}};
		     read_ptr<=5'b0;
	     end

	     else if(read_enb==1'b1&&empty==1'b0)
	     begin
		     data_out<=mem[read_ptr[3:0]][7:0];
		     read_ptr<=read_ptr+1'b1;
	     end
		  else if(!full && empty && counter ==1'b0)
					data_out<={8{1'bz}};
			else
					data_out<=data_out;
	 end


always@(posedge clock)
begin
	if(resetn==1'b0)
			counter<=7'b0;
			
	else if(soft_reset==1'b1)
				counter <= 0;
				
	else if(lfd_s==1'b1)
				counter <= mem[read_ptr[3:0]][7:2] + 1'b1;
				
	else if(read_enb == 1'b1)
	begin
		     if(mem[read_ptr[3:0]][8] == 1'b1)
			     counter <=counter;
				else
					counter <=counter-1'b1;
	end
end

assign full=(wr_ptr=={~read_ptr[4],read_ptr[3:0]});
assign empty=(wr_ptr==read_ptr);

endmodule
