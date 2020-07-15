`timescale 1ns / 1ns
module TB_MAX7219();
reg sys_clk, _rst, str;
reg [7:0]IRreg, data;
wire CS, CLK, Din, busy;
integer i;
MAX7219#(.Freq_MegaHZ(50))
		 UUT(.sys_clk(sys_clk), ._rst(_rst), .str(str), .busy(busy), .IRreg(IRreg), .data(data), .CS(CS), .CLK(CLK), .Din(Din));
initial forever #1 sys_clk = ~sys_clk;
	always@(negedge _rst, negedge busy)begin
		if(!_rst)begin
			IRreg = 8'h00;
			data = 8'h00;
		end
		else begin
			IRreg = IRreg + 1;
			case(IRreg)
				4'h0:data  = 8'h00;
				4'h1:data  = 8'b11111111;
				4'h2:data  = 8'b00111100;
				4'h3:data  = 8'b00111100;
				4'h4:data  = 8'b11100111;
				4'h5:data  = 8'b11100111;
				4'h6:data  = 8'b00111100;
				4'h7:data  = 8'b00111100;
				4'h8:data  = 8'b11111111;
				4'h9:data  = 8'h00;//decode mode
				4'hA:data  = 8'h00;//light(0~15)
				4'hB:data  = 8'h07;//scanline(0~7)
				4'hC:data  = 8'h01;//shutdown
				4'hF:data  = 8'h00;//test
				default:data  = 8'h00;
			endcase
			if(IRreg==8'h10)
				$stop;
		end
	end
	initial begin
		sys_clk = 1'b0;
		_rst = 1'b1;
		str = 1'b0;
		IRreg = 8'h00;
		i = 0;
		#5 _rst = ~_rst;
		#5 _rst = ~_rst;
		str = 1;
	end
endmodule 