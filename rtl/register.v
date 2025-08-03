
module router_register(input clock,resetn,pkt_valid,
		  input fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state, 
		  input [7:0]data_in,
		  output reg parity_done,low_pkt_valid,err,
		  output reg [7:0]dout);
	reg [7:0]header_byte,full_state_byte,internal_parity_byte,packet_parity_byte;
	
	//Data Logic:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			dout <= 8'd0;
		else if(detect_add && pkt_valid && (data_in[1:0]!= 2'b11))
			dout <= dout;
		else if(lfd_state == 1'b1)
			dout <= header_byte;
		else if(ld_state && !fifo_full)
			dout <= data_in;
		else if(ld_state && fifo_full)
			dout <= dout;
		else if(laf_state)
			dout <= full_state_byte;
		else 
			dout <= dout;
	end

	//Full State byte:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			full_state_byte <= 8'b0;
		else if(fifo_full == 1'b1)
			full_state_byte <= data_in;
		else
			full_state_byte <= full_state_byte;
	end

	//Header Logic:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			header_byte <= 8'd0;
		else if(detect_add && pkt_valid && (data_in[1:0] != 2'd3))
			header_byte <= data_in;
		else
			header_byte <= header_byte;
	end

	//Internal Parity Logic:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			internal_parity_byte <= 8'd0;
		else if(detect_add)
			internal_parity_byte <= 8'd0;
		else if(lfd_state)
			internal_parity_byte <= internal_parity_byte ^ header_byte;
		else if (pkt_valid && ld_state && !full_state)
			internal_parity_byte <= internal_parity_byte ^ data_in;
		else
			internal_parity_byte <= internal_parity_byte;
			
	end

	//Packet Parity Logic:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			packet_parity_byte <= 8'd0;
		else if(detect_add)
			packet_parity_byte <= 8'd0;
		else if(ld_state && !pkt_valid)
			packet_parity_byte <= data_in;
		else
			packet_parity_byte <= packet_parity_byte;
	end

	//Parity Done:
	always@(posedge clock)
	begin
		if (resetn == 1'b0)
			parity_done <= 1'b0;
		else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
			parity_done <= 1'b1;
		else if(detect_add == 1'b1) 
			parity_done <= 1'b0;
		else
			parity_done <= parity_done;
	end

	//Error Logic:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			err <= 1'b0;
		else if(parity_done)
		begin
			if(internal_parity_byte == packet_parity_byte)
				err <= 1'b0;
			else if(internal_parity_byte != packet_parity_byte)
				err <= 1'b1;
			else
				err <= err;
		end
		else
			err <= err;
	end
	
	//Low Packet Valid:
	always@(posedge clock)
	begin
		if(resetn == 1'b0)
			low_pkt_valid <= 1'b0;
		else if(rst_int_reg == 1'b1)
			low_pkt_valid <= 1'b0;
		else if (!pkt_valid && ld_state)
			low_pkt_valid <= 1'b1;
		else
			low_pkt_valid <= low_pkt_valid;
	end

endmodule







