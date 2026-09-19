`timescale 1ns/1ps

module tb;
  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  reg [3:0] exp_res;
  integer errors;

  task check_alu(input [3:0] in_a, input [3:0] in_b, input in_op);
    begin
      t_a  = in_a;
      t_b  = in_b;
      t_op = in_op;
      #10;
      exp_res = (in_op == 1'b0) ? (in_a + in_b) : (in_a - in_b);
      if (t_result !== exp_res) begin
        $display("FAIL at time %0t: a=%d b=%d op=%b | got result=%d, expected=%d",
                 $time, in_a, in_b, in_op, t_result, exp_res);
        errors = errors + 1;
      end else begin
        $display("PASS at time %0t: a=%d b=%d op=%b | result=%d",
                 $time, in_a, in_b, in_op, t_result);
      end
    end
  endtask

  initial begin
    errors = 0;

    // Test 1: Test sensitivity list bug by toggling op with constant operands
    t_a = 4'd7; t_b = 4'd3; t_op = 1'b0;
    #10;
    check_alu(4'd7, 4'd3, 1'b1); // op flips to sub; result must change immediately

    // Test 2: Subtraction dependent execution chain tests
    check_alu(4'd10, 4'd4, 1'b1);
    check_alu(4'd5,  4'd2, 1'b1);
    check_alu(4'd3,  4'd3, 1'b1);
    check_alu(4'd2,  4'd5, 1'b1);

    // Test 3: Addition operations
    check_alu(4'd2,  4'd4, 1'b0);
    check_alu(4'd8,  4'd7, 1'b0);

    if (errors == 0)
      $display("ALL ALU TESTS PASSED SUCCESSFULLY.");
    else
      $display("ALU VERIFICATION FAILED WITH %0d ERRORS.", errors);

    $finish;
  end
endmodule