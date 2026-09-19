module and_df (
  input  a,
  input  b,
  output y
);
  // Inertial delay: Pulses shorter than the delay value are filtered out
  assign #5 y = a & b;
endmodule