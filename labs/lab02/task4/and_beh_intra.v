module and_beh_intra (
  input      a,
  input      b,
  output reg y
);
  // Samples inputs immediately at time t, then schedules assignment to y at (t + 5)
  always @(*) begin
    y = #5 (a & b);
  end
endmodule