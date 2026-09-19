// // tb.v
// // Starter testbench template -- YOU complete this file.

// module tb;

//   // TODO: declare the inputs and outputs

//   // TODO: instantiate DUT here

//   // Waveform dump configuration (DO NOT CHANGE)
//   string vcd_file;
//   initial begin
//     if ($value$plusargs("vcd=%s", vcd_file)) begin
//       $dumpfile(vcd_file);
//       $dumpvars(0, DUT);
//     end
//   end

//   initial begin
//     // TODO: apply different input combinations

//   end

//   initial
//     $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y); // change as required

// endmodule
`timescale 1ns/1ps

module tb;
  parameter WIDTH = 8;
  parameter DEPTH = 8;

  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  // Parameter override
  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer k;
  integer errors;

  initial begin
    errors = 0;
    #5;
    for (k = 0; k < DEPTH; k = k + 1) begin
      t_sel = k;
      #5;
      if (t_dout !== (k * k)) begin
        $display("FAIL at time %0t: sel=%0d got dout=%0d expected=%0d", $time, t_sel, t_dout, (k * k));
        errors = errors + 1;
      end else begin
        $display("PASS at time %0t: sel=%0d dout=%0d", $time, t_sel, t_dout);
      end
    end

    if (errors == 0)
      $display("ALL %0d LOCATIONS PASSED!", DEPTH);
    else
      $display("COMPLETED WITH %0d ERRORS.", errors);

    $finish;
  end

  initial
    $monitor($time, " sel=%b | dout=%d", t_sel, t_dout);
endmodule