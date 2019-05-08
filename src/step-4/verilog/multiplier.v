module Adder #(parameter bits = 1) (
  input [(bits-1):0] a,
  input [(bits-1):0] b,
  output [(bits-1):0] s,
  output c
);
   wire [bits:0] temp;
   assign temp = a + b;
   assign s = temp [(bits-1):0];
   assign c = temp[bits];
endmodule

module Subtractor #(parameter bits = 1) (
  input [(bits-1):0] a,
  input [(bits-1):0] b,
  output [(bits-1):0] d,
  output c
);
  wire [bits:0] temp;
  assign temp = a - b;
  assign d = temp[(bits - 1):0];
  assign c = temp[bits];
endmodule

module Register #(parameter bits = 1) (
  input clk,
  input [(bits-1):0]d,
  output [(bits-1):0]q
);
  reg [(bits-1):0] state = 'hX;
  assign q = state;

  always @ (posedge clk) 
    state <= d;
endmodule

module ROM #(parameter address_bits = 1, file = "") (
  input [(address_bits-1):0] address,
  output [15:0] data
);
  reg [15:0] memory [0:(2**address_bits-1)];  
  assign data = memory[address];
  
  initial
    $readmemh(file, memory); 
endmodule

module Multiplier  (
  input clk,
  input [7:0] a,
  input [7:0] b,
  input sgnd,
  output [15:0] p
);  
  wire [7:0] adder_s;
  wire adder_c;
  Adder #(.bits(8)) adder (
    .a(a),
    .b(b),
    .s(adder_s),
    .c(adder_c)
  );
  
  wire [7:0] subtractor_d;
  wire subtractor_c;
  Subtractor #(.bits(8)) subtractor (
    .a(a),
    .b(b),
    .d(subtractor_d),
    .c(subtractor_c)
  );
  
  wire invert_carry = (a[7] ^ b[7]) & sgnd;  
  
  wire [9:0] register1_input;
  assign register1_input[7:0] = adder_s;
  assign register1_input[8] = adder_c ^ invert_carry;
  assign register1_input[9] = sgnd;  
  
  wire [8:0] register2_input;  
  assign register2_input[7:0] = subtractor_d;
  assign register2_input[8] = subtractor_c ^ invert_carry;
  
  wire [9:0] rom1_address;  
  Register #(.bits(10)) register1 (
    .clk(clk),
    .d(register1_input),
    .q(rom1_address)
  ); 
  
  wire [8:0] rom2_address;  
  Register #(.bits(9)) register2 (
    .clk(clk),
    .d(register2_input),
    .q(rom2_address)
  ); 

  wire [15:0] rom1_data;
  ROM #(.address_bits(10), .file("rom1.hex")) rom1 (
    .address(rom1_address),
    .data(rom1_data)
  ); 

  wire [15:0] rom2_data;  
  ROM #(.address_bits(9), .file("rom2.hex")) rom2 (
    .address(rom2_address),
    .data(rom2_data)
  ); 
  
  wire [15:0] register_3_output;
  Register #(.bits(16)) register3 (
    .clk(clk),
    .d(rom1_data),
    .q(register_3_output)
  ); 
  
  wire [15:0] register_4_output;  
  Register #(.bits(16)) register4 (
    .clk(clk),
    .d(rom2_data),
    .q(register_4_output)
  );
  
  Subtractor #(.bits(16)) final_subtractor (
    .a(register_3_output),
    .b(register_4_output),
    .d(p)
  );
endmodule