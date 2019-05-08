module ROM (
  input [15:0] address,
  output [15:0] data
);
  reg [15:0] memory [0:65535];  
  assign data = memory[address];

  initial
    $readmemh("rom.hex", memory); 
endmodule

module Multiplier (
  input [7:0] a,
  input [7:0] b,
  output [15:0] p
);
  wire [15:0] rom_address;
  assign rom_address[7:0] = a;
  assign rom_address[15:8] = b;
  
  ROM rom(
    .address(rom_address), 
    .data(p)
  );  
endmodule