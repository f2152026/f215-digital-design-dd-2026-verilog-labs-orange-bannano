`timescale 1ns/1ps

module tb;
  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  reg exp_gt, exp_lt, exp_eq;
  integer i, j;
  integer errors;
  integer total_tests;

  initial begin
    errors = 0;
    total_tests = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;
        total_tests = total_tests + 1;

        exp_gt = (t_a > t_b);
        exp_lt = (t_a < t_b);
        exp_eq = (t_a == t_b);

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("Summary: %0d passed out of %0d total tests. ", (total_tests - errors), total_tests);
    if (errors == 0)
      $display("ALL TESTS PASSED.");
    else
      $display("TEST FAILED WITH %0d ERRORS.", errors);

    $finish;
  end
endmodule