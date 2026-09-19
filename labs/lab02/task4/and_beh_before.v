module and_beh_before (
  input      a,
  input      b,
  output reg y
);
  // Waits 5 units after an input change, then samples inputs at time (t + 5)
  always @(*) begin
    #5 y = a & b;
  end
endmodule