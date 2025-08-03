
`timescale 1ns / 1ps
module router_top(clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);
	input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
	input [7:0] data_in;
	output [7:0] data_out_0,data_out_1,data_out_2;
	output valid_out_0,valid_out_1,valid_out_2,error,busy;

	//parity_done_w - (fsm,register)
	//soft_reset_0_w,soft_reset_1_w,soft_reset_2_w - (fsm,synchronizer)
	//fifo_full_w - (fsm,register,synchronizer)
	//low_pkt_valid_w - (fsm,register)
	//empyt_0_w,empty_1_w,empty_2_w - (fsm,synchronizer,fifo)
	//detect_add_w (fsm,synchronizer,register)
	//ld_state_w (fsm,register)
	//laf_state_w(fsm,register)
	//full_state_w (fsm,register)
	//write_enb_reg_w (fsm, synchronizer) -done
	//rst_int_reg_w (fsm,register)
	//lfd_state_w (fsm,register)
	//full_0_w, full_1_w, full_2_w (synchronizer, fifo)
	//
	wire [2:0]write_enb_w;
	wire [7:0]data_out_w;


	router_fsm fsm (.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid),.busy(busy),.parity_done(parity_done_w), .data_in(data_in[1:0]), .soft_reset_0(soft_reset_0_w), .soft_reset_1(soft_reset_1_w), .soft_reset_2(soft_reset_2_w), 
		.fifo_full(fifo_full_w), .low_pkt_valid(low_pkt_valid_w), .fifo_empty_0(empty_0_w), .fifo_empty_1(empty_1_w), .fifo_empty_2(empty_2_w), .detect_add(detect_add_w), .ld_state(ld_state_w), .laf_state(laf_state_w), .full_state(full_state_w), .write_enb_reg(write_enb_reg_w), .rst_int_reg(rst_int_reg_w), .lfd_state(lfd_state_w));

	router_sync sync (.clock(clock), .resetn(resetn), .vld_out_0(valid_out_0), .vld_out_1(valid_out_1), .vld_out_2(valid_out_2), .read_enb_0(read_enb_0), .read_enb_1(read_enb_1), .read_enb_2(read_enb_2), .detect_add(detect_add_w), .write_enb_reg(write_enb_reg_w), .data_in(data_in[1:0]), .fifo_full(fifo_full_w), .empty_0(empty_0_w), .empty_1(empty_1_w), .empty_2(empty_2_w), .soft_reset_0(soft_reset_0_w), .soft_reset_1(soft_reset_1_w), .soft_reset_2(soft_reset_2_w), .full_0(full_0_w), .full_1(full_1_w), .full_2(full_2_w), .write_enb(write_enb_w));

	router_register register (.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid), .data_in(data_in), .fifo_full(fifo_full_w), .rst_int_reg(rst_int_reg_w), .detect_add(detect_add_w), .ld_state(ld_state_w), .laf_state(laf_state_w), .full_state(full_state_w), .lfd_state(lfd_state_w), .parity_done(parity_done_w), .low_pkt_valid(low_pkt_valid_w), .err(error), .dout(data_out_w));

	router_fifo fifo_1 (.clock(clock), .resetn(resetn), .read_enb(read_enb_0), .write_enb(write_enb_w[0]), .soft_reset(soft_reset_0_w), .data_in(data_out_w), .lfd_state(lfd_state_w), .empty(empty_0_w), .full(full_0_w), .data_out(data_out_0));
	
	router_fifo fifo_2 (.clock(clock), .resetn(resetn), .read_enb(read_enb_1), .write_enb(write_enb_w[1]), .soft_reset(soft_reset_1_w), .data_in(data_out_w), .lfd_state(lfd_state_w), .empty(empty_1_w), .full(full_1_w), .data_out(data_out_1));

	router_fifo fifo_3 (.clock(clock), .resetn(resetn), .read_enb(read_enb_2), .write_enb(write_enb_w[2]), .soft_reset(soft_reset_2_w), .data_in(data_out_w), .lfd_state(lfd_state_w), .empty(empty_2_w), .full(full_2_w), .data_out(data_out_2));

endmodule

