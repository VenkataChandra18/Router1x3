/*module router_sync(input detect_add,write_enb_reg,clock,resetn,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,
input [1:0]data_in, output reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full, output vld_out_0,vld_out_1,vld_out_2, output reg [2:0]write_enb);

reg [1:0] addr;
reg [4:0]count_0,count_1,count_2;

always @ (posedge clock) begin:reg_add
	if (resetn == 1'b0) addr = 2'b0;
	else begin
		if (detect_add == 1'b1) addr = data_in;
		else if (write_enb_reg == 1'b1) begin
			case (addr)
				2'b00 : write_enb = 3'b001;
				2'b01 : write_enb = 3'b010;
				2'b10 : write_enb = 3'b100;
				default : write_enb = 3'b000;
			endcase
		end
		else write_enb = 3'b000;
	end
end

always @ (posedge clock) begin: fi_full
	//if(resetn == 1'b0) fifo_full = 1'b0;
	//else begin
	case(addr)
		2'b00 : fifo_full = full_0;
		2'b01 : fifo_full = full_1;
		2'b10 : fifo_full = full_2;
default : fifo_full = 1'b0;		
	     endcase
     end
	  
	   assign vld_out_0 = ~(empty_0);
		assign vld_out_1 = ~(empty_1);
		assign vld_out_2 = ~(empty_2);

always @ (posedge clock) begin: soft_reset
	if (resetn == 1'b0) 
		begin
		{soft_reset_0,soft_reset_1,soft_reset_2} = 3'b000;
		{count_0,count_1,count_2} = 15'b0;
	end
	else 
		begin
		// for soft_reset_0
		if (vld_out_0 == 0) 
			begin
			count_0 = 5'b0;
			soft_reset_0 = 1'b0;
		end
		else if (read_enb_0 == 1'b0) 
			begin
			if (count_0 == 5'd29) 
			begin
			soft_reset_0 = 1'b1;
				count_0 = 5'b0;
				end
			 else
				count_0 = count_0 + 1'b1;

		
		end
		else begin
			soft_reset_0 = 0;
			count_0 = 0;
		end
		
		// for soft_reset_1
		if (vld_out_1 == 0) begin
			count_1 = 5'b0;
			soft_reset_1 = 1'b0;
		end
		else if (read_enb_1 == 0) begin
			if (count_1 ==5'd29) 
			begin
			soft_reset_1 = 1;
				count_1 = 0;
				end
			else count_1 = count_1 + 1;
				
			end
	
		else begin
			soft_reset_1 = 0;
			count_1 = 0;
		end
		
		// for soft_reset_2
		if (vld_out_2 == 0) begin
			count_2 = 5'b0;
			soft_reset_2 = 1'b0;
		end
		else if (read_enb_2 == 0) begin
			if (count_2 ==5'd29) 
			begin
			soft_reset_2 = 1;
				count_2 = 0;
				end
			else
				count_2 = count_2 + 1;
		end
		else begin
			soft_reset_2 = 0;
			count_2 = 0;
		end

endmodule*/

module router_sync(input clock, resetn,detect_add,write_enb_reg,
	                input [1:0] data_in,
						 input read_enb_0,read_enb_1,read_enb_2,
	                input empty_0,empty_1,empty_2,
						 input full_0,full_1,full_2,
						 output reg [2:0] write_enb,
						 output reg fifo_full,
						 output reg soft_reset_0,soft_reset_1,soft_reset_2,
						 output vld_out_0,vld_out_1,vld_out_2);
                   reg [4:0] count_0,count_1,count_2;
						 reg [1:0] addr;

		   //register the addr
		 
		   always@(posedge clock)
			  begin
				  if(resetn == 1'b0)
					  addr <= 2'b0;
				  else if(detect_add == 1'b1)
					  addr <= data_in;
			  end

	         //Generate the write_enb output

		 always@(*)
		 begin
			 if(write_enb_reg == 1'b1)
				 case(addr)
					 2'b00 : write_enb = 3'b001;
					 2'b01 : write_enb = 3'b010;
					 2'b10 : write_enb = 3'b100;
					 default : write_enb = 3'b000;
				 endcase
			else
				write_enb = 3'b000;
		end

		//Generate fifo_full

		always@(*)
		begin
			case(addr)
				2'b00 : fifo_full = full_0;
				2'b01 : fifo_full = full_1;
				2'b10 : fifo_full = full_2;
            default : fifo_full = 1'b0;
			endcase
		end

		//valid_out

		assign vld_out_0 = ~(empty_0);
		assign vld_out_1 = ~(empty_1);
		assign vld_out_2 = ~(empty_2);

		//soft_reset
	
		always@(posedge clock)
		begin
			if(resetn ==1'b0)
			begin
				count_0 <= 5'b0;
				soft_reset_0 <= 1'b0;
			end

			else if (vld_out_0 == 1'b0)
			begin
				count_0 <= 5'b0;
				soft_reset_0 <= 1'b0;
			end

			else if (read_enb_0 == 1'b0)
			begin
				if(count_0 == 5'd29)
				begin
					count_0 <= 5'b0;
					soft_reset_0 <= 1'b1;
				end
				else
					count_0 <= count_0 + 1'b1;
			end
			else
			begin
				count_0 <= 5'b0;
				soft_reset_0 <= 1'b0;
			end
		end
		
		
		always@(posedge clock)
                begin
                        if(resetn ==1'b0)
                        begin
                                count_1 <= 5'b0;
                                soft_reset_1 <= 1'b0;
                        end

                        else if (vld_out_1 == 1'b0)
                        begin
                                count_1 <= 5'b0;
                                soft_reset_1 <= 1'b0;
                        end

                        else if (read_enb_1 == 1'b0)
                        begin
                                if(count_1 == 5'd29)
                                begin
                                        count_1 <= 5'b0;
                                        soft_reset_1 <= 1'b1;
                                end
                                else
                                        count_1 <= count_1 + 1'b1;
                        end
                        else
                        begin
                                count_1 <= 5'b0;
                                soft_reset_1 <= 1'b0;
                        end
                end


		 always@(posedge clock)
                begin
                        if(resetn ==1'b0)
                        begin
                                count_2 <= 5'b0;
                                soft_reset_2 <= 1'b0;
                        end

                        else if (vld_out_2 == 1'b0)
                        begin
                                count_2 <= 5'b0;
                                soft_reset_2 <= 1'b0;
                        end

                        else if (read_enb_2 == 1'b0)
                        begin
                                if(count_2 == 5'd29)
                                begin
                                        count_2 <= 5'b0;
                                        soft_reset_2 <= 1'b1;
                                end
                                else
                                        count_2 <= count_2 + 1'b1;
                        end
                        else
                        begin
                                count_2 <= 5'b0;
                                soft_reset_2 <= 1'b0;
                        end
                end
endmodule

