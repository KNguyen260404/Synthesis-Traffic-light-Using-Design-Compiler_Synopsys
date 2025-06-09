# Giải thích chi tiết module Second_counter

Module Second_counter là một bộ đếm ngược được thiết kế để tạo ra tín hiệu "1 giây" bằng cách đếm từ 99 xuống 0 với xung clock 10MHz. Dưới đây là phân tích chi tiết từng phần của module:

## 1. Khai báo Module và Tham số

```verilog
module Second_counter #(parameter pMAX_VAL=99)
(
    input wire clk,  
    input wire en,
    input wire rst_n,
    output wire last,
    output wire pre_last,
    output reg [6:0] count
);
```

- **pMAX_VAL=99**: Tham số xác định giá trị tối đa của bộ đếm (đếm từ 99 xuống 0)
- **clk**: Tín hiệu clock đầu vào (10MHz)
- **en**: Tín hiệu cho phép (enable) bộ đếm hoạt động
- **rst_n**: Tín hiệu reset (active low) - khi rst_n=0, bộ đếm sẽ reset về giá trị ban đầu
- **last**: Tín hiệu báo hiệu khi bộ đếm đạt giá trị 0
- **pre_last**: Tín hiệu báo hiệu khi bộ đếm đạt giá trị 1
- **count**: Giá trị đếm hiện tại (7 bit để chứa được giá trị lên đến 99)

## 2. Khai báo Biến Nội bộ

```verilog
reg [6:0] int_count;
```

- **int_count**: Biến nội bộ lưu giá trị đếm hiện tại, được sử dụng để tính toán các tín hiệu đầu ra

## 3. Khởi tạo Ban đầu

```verilog
initial begin
  int_count = pMAX_VAL;
  count = pMAX_VAL;
end
```

- Khối này chỉ chạy một lần khi bắt đầu mô phỏng
- Khởi tạo int_count và count với giá trị pMAX_VAL (99)
- Mục đích: Tránh giá trị không xác định (x) trong mô phỏng

## 4. Logic Tuần tự (Sequential Logic)

```verilog
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    // Reset condition
    int_count <= pMAX_VAL;
    count <= pMAX_VAL;
  end
  else if(en) begin
    if(int_count > 0) begin
      // Normal counting
      int_count <= int_count - 1;
      count <= int_count - 1;
    end
    else begin
      // Wrap around when reached zero
      int_count <= pMAX_VAL;
      count <= pMAX_VAL;
    end
  end
  // Keep existing value when not enabled
end
```

- **always @(posedge clk or negedge rst_n)**: Block này thực thi khi có cạnh dương của clock hoặc cạnh âm của reset
- **if(!rst_n)**: Khi reset active (rst_n=0), reset cả int_count và count về giá trị pMAX_VAL (99)
- **else if(en)**: Chỉ đếm khi tín hiệu enable (en) là 1
  - **if(int_count > 0)**: Nếu chưa đếm đến 0, giảm giá trị đếm đi 1
  - **else**: Nếu đã đếm đến 0, reset lại về pMAX_VAL (99)
- Nếu en=0, giữ nguyên giá trị hiện tại (không có khối else)

## 5. Logic Tổ hợp (Combinational Logic)

```verilog
assign last = (int_count == 0) ? 1'b1 : 1'b0;    // Explicit ternary to avoid X
assign pre_last = (int_count == 1) ? 1'b1 : 1'b0; // Explicit ternary to avoid X
```

- **last**: Bằng 1 khi int_count = 0, ngược lại bằng 0
- **pre_last**: Bằng 1 khi int_count = 1, ngược lại bằng 0
- Sử dụng toán tử ba ngôi (ternary) rõ ràng để tránh giá trị không xác định (x)

## Cách Hoạt động của Module:

1. **Khởi tạo**: int_count và count được khởi tạo với giá trị 99
2. **Đếm ngược**: Mỗi chu kỳ clock, nếu en=1, int_count và count giảm 1 đơn vị
3. **Phát hiện kết thúc**: 
   - Khi int_count=1, pre_last=1 (báo hiệu sắp kết thúc)
   - Khi int_count=0, last=1 (báo hiệu đã kết thúc)
4. **Reset tự động**: Khi int_count=0, chu kỳ clock tiếp theo sẽ reset int_count và count về 99
5. **Reset bằng tay**: Khi rst_n=0, int_count và count được reset về 99 bất kể giá trị hiện tại

## Ứng dụng trong Hệ thống Đèn Giao thông:

- Module này đếm 100 chu kỳ clock (từ 99 về 0) để tạo ra tín hiệu "1 giây"
- Tín hiệu last được sử dụng để kích hoạt Light_Counter đếm số giây đã trôi qua
- Tín hiệu pre_last được sử dụng để giúp FSM bắt kịp với tín hiệu last (vì FSM có thanh ghi ở đầu ra)

## Waveform

Dưới đây là hình ảnh waveform của module Second_counter:

![Second Counter Waveform](../../example/Traffic-light-SystemVerilog/Image/Second_counter_waveform.png)

Trong waveform này, bạn có thể thấy:
- Quá trình đếm ngược của count từ 99 xuống 0
- Tín hiệu pre_last được kích hoạt (=1) khi count=1
- Tín hiệu last được kích hoạt (=1) khi count=0
- Sau khi count đạt 0, nó reset về 99 và bắt đầu chu kỳ đếm mới
