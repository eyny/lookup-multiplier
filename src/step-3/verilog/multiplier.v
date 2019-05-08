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
  
  wire [9:0] rom1_address;
  assign rom1_address[7:0] = adder_s;
  assign rom1_address[8] = adder_c ^ invert_carry;
  assign rom1_address[9] = sgnd;
  
  wire [8:0] rom2_address;  
  assign rom2_address[7:0] = subtractor_d;
  assign rom2_address[8] = subtractor_c ^ invert_carry;

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

  Subtractor #(.bits(16)) final_subtractor (
    .a(rom1_data),
    .b(rom2_data),
    .d(p)
  );
endmodule