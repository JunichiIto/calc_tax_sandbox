require 'date'
require 'stringio'

module CalcTaxSandbox
  class Register
    def initialize(current_date = Date.today)
      @current_date = current_date
      @sales_rows = []
    end

    def add(item, quantity)
      post_tax_price = item.build_post_tax_price(on: @current_date)
      row = SalesRow.new(item, post_tax_price, quantity)
      @sales_rows << row
    end

    def total
      @sales_rows.sum(&:total)
    end

    def pay(paid)
      @paid = paid
    end

    def change
      @paid - total
    end

    def print_receipt
      io = StringIO.new

      io.puts @current_date.strftime('%Y年%m月%d日')
      io.puts
      @sales_rows.each do |row|
        io.puts format_sales_row(row)
      end
      io.puts
      io.puts "合計 #{total}"
      if @current_date < NEW_RULE_START_DATE
        tax = @sales_rows.sum(&:total_tax)
        io.puts print_tax_total(tax)
      else
        io.puts
        io.puts print_sub_total(keigen_rows, OLD_TAX_RATE)
        io.puts
        io.puts print_sub_total(standard_rows, NEW_TAX_RATE)
      end
      io.puts
      io.puts "お預り #{@paid}"
      io.puts "お釣 #{change}"

      io.string
    end

    private

    def format_sales_row(row)
      keigen_mark = row.keigen? ? '※' : ''
      "#{row.item.name}#{keigen_mark} #{row.quantity} #{row.total}"
    end

    def print_sub_total(sales_rows, tax_rate)
      sub_total, tax = sub_total(sales_rows)
      <<~TEXT.chomp
        #{tax_rate}%対象 #{sub_total}
        #{print_tax_total(tax)}
      TEXT
    end

    def print_tax_total(tax)
      "（内消費税額 #{tax}）"
    end

    def sub_total(sales_rows)
      total = sales_rows.sum(&:total)
      tax = sales_rows.sum(&:total_tax)
      [total, tax]
    end

    def keigen_rows
      @sales_rows.select(&:keigen?)
    end

    def standard_rows
      @sales_rows.reject(&:keigen?)
    end
  end
end
