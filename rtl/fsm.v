
module router_fsm(input clock,resetn,pkt_valid,parity_done,fifo_full,low_pkt_valid,
		  input [1:0] data_in,
	  	  input soft_reset_0,soft_reset_1,soft_reset_2,
		  input fifo_empty_0,fifo_empty_1,fifo_empty_2,
		  output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state
	          );

parameter DECODE_ADDRESS = 3'b000,
	  LOAD_FIRST_DATA = 3'b001,
	  WAIT_TILL_EMPTY = 3'b010,
	  LOAD_DATA = 3'b011,
	  LOAD_PARITY = 3'b100,
	  FIFO_FULL_STATE = 3'b101,
	  CHECK_PARITY_ERROR = 3'B110,
	  LOAD_AFTER_FULL = 3'b111;
reg [2:0] p_state,n_state;
reg [1:0] addr;

always@(posedge clock)
	begin
		if(resetn == 1'b0)
			p_state <= DECODE_ADDRESS;
		else if(soft_reset_0||soft_reset_1||soft_reset_2)
			p_state <= DECODE_ADDRESS;
		else
			p_state <= n_state;
	end
always@(posedge clock)
        begin
                if(resetn == 1'b0)
                        addr <= 2'b0;
                else
								
                        addr <= data_in;
        end

always@ (*)
begin
	n_state = DECODE_ADDRESS;
case(p_state)
	DECODE_ADDRESS : begin
		     if((pkt_valid & (data_in[1:0] == 0) & fifo_empty_0)|
			    (pkt_valid & (data_in[1:0] == 1) & fifo_empty_1)|
			    (pkt_valid & (data_in[1:0] == 2) & fifo_empty_2))
			        n_state = LOAD_FIRST_DATA;

			 else if((pkt_valid & (data_in[1:0] == 0) & !fifo_empty_0)|
                  (pkt_valid & (data_in[1:0] == 1) & !fifo_empty_1)|
                  (pkt_valid & (data_in[1:0] == 2) & !fifo_empty_2))
                         n_state = WAIT_TILL_EMPTY;

			 else 
				 n_state = DECODE_ADDRESS;
		         end

	LOAD_FIRST_DATA : n_state = LOAD_DATA;

	WAIT_TILL_EMPTY : begin
		 	  if((fifo_empty_0 && (addr == 0)) ||
		  	    (fifo_empty_1 && (addr == 1)) ||
			    (fifo_empty_2 && (addr == 2)))
                           n_state = LOAD_FIRST_DATA;

			  else
				  n_state = WAIT_TILL_EMPTY;
		  	 end
	LOAD_DATA : begin
		       if(fifo_full)
			n_state = FIFO_FULL_STATE;
		       else if(!fifo_full && !pkt_valid)
			n_state = LOAD_PARITY;
		       else 
			       n_state = LOAD_DATA;
		    end

	LOAD_PARITY : n_state = CHECK_PARITY_ERROR;
	
	FIFO_FULL_STATE : begin
			    if(!fifo_full)
			       n_state = LOAD_AFTER_FULL;
		       	    else if(fifo_full) 
			       n_state = FIFO_FULL_STATE;
		          end
	CHECK_PARITY_ERROR : begin
		 		if(fifo_full)
				  n_state = FIFO_FULL_STATE;
			        else if(!fifo_full)
				  n_state = DECODE_ADDRESS;
			    end

	LOAD_AFTER_FULL : begin
			     if(!parity_done && low_pkt_valid)
			        n_state = LOAD_PARITY;
			     else if(!parity_done && !low_pkt_valid)
				n_state = LOAD_DATA;
			     else if(parity_done)
				 n_state = DECODE_ADDRESS;
		 	  end
endcase
end

assign busy = (p_state == LOAD_FIRST_DATA)||
	      (p_state == LOAD_PARITY)||
	      (p_state == FIFO_FULL_STATE)||
	      (p_state == LOAD_AFTER_FULL)||
	      (p_state == WAIT_TILL_EMPTY)||
	      (p_state == CHECK_PARITY_ERROR);

assign detect_add = (p_state == DECODE_ADDRESS);

assign ld_state = (p_state == LOAD_DATA);

assign laf_state = (p_state == LOAD_AFTER_FULL);

assign full_state = (p_state == FIFO_FULL_STATE);

assign write_enb_reg = (p_state == LOAD_DATA)||
		       (p_state == LOAD_PARITY)||
		       (p_state == LOAD_AFTER_FULL);

assign rst_int_reg = (p_state == CHECK_PARITY_ERROR);

assign lfd_state = (p_state == LOAD_FIRST_DATA);

endmodule 







