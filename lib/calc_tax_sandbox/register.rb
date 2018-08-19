require 'date'

module CalcTaxSandbox
  class Register
    def initialize(current_date = Date.today)
      @current_date = current_date
      @sales_rows = []
      @keigen_rows = []
      @standard_rows = []
    end

    def add(item, quantity)
      price_detail = item.price_detail(on: @current_date)
      row = SalesRow.new(item, price_detail, quantity)
      @sales_rows << row
      if price_detail.keigen?
        @keigen_rows << row
      else
        @standard_rows << row
      end
    end

    def total
      @sales_rows.sum do |row|
        row.price_detail.with_tax * row.quantity
      end
    end

    def pay(paid)
      @paid = paid
    end

    def change
      @paid - total
    end

    def print_receipt
      rows = []
      rows << @current_date.strftime('%Y年%m月%d日')
      rows << ''
      @sales_rows.each do |row|
        rows << format_sales_row(row)
      end
      rows << "合計 #{total}"
      rows << ''
      rows << print_sub_total(@keigen_rows, OLD_TAX_RATE)
      rows << ''
      rows << print_sub_total(@standard_rows, NEW_TAX_RATE)
      rows << ''
      rows << "お預り #{@paid}"
      rows << "お釣 #{change}"
      rows.join("\n")
    end

    private

    def format_sales_row(row)
      price_detail = row.price_detail
      total = price_detail.with_tax * row.quantity
      keigen_mark = price_detail.keigen? ? '※' : ''
      "#{row.item.name}#{keigen_mark} #{row.quantity} #{total}"
    end

    def print_sub_total(sales_rows, tax_rate)
      sub_total, tax = sub_total(sales_rows)
      <<~TEXT.chomp
        #{tax_rate}%対象 #{sub_total}
        （内消費税額 #{tax}）
      TEXT
    end

    def sub_total(sales_rows)
      total = sales_rows.sum { |row| row.price_detail.with_tax }
      tax = sales_rows.sum { |row| row.price_detail.tax }
      [total, tax]
    end
  end
end
