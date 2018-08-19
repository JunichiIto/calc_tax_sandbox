require 'date'

module CalcTaxSandbox
  class Register
    def initialize(current_date = Date.today)
      @current_date = current_date
      @sales_rows = []
    end

    def add(item, quantity)
      post_tax_price = item.post_tax_price(on: @current_date)
      row = SalesRow.new(item, post_tax_price, quantity)
      @sales_rows << row
    end

    def total
      @sales_rows.sum do |row|
        row.post_tax_price.with_tax * row.quantity
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
      rows << print_sub_total(keigen_rows, OLD_TAX_RATE)
      rows << ''
      rows << print_sub_total(standard_rows, NEW_TAX_RATE)
      rows << ''
      rows << "お預り #{@paid}"
      rows << "お釣 #{change}"
      rows.join("\n")
    end

    private

    def format_sales_row(row)
      post_tax_price = row.post_tax_price
      total = post_tax_price.with_tax * row.quantity
      keigen_mark = post_tax_price.keigen? ? '※' : ''
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
      total = sales_rows.sum { |row| row.post_tax_price.with_tax }
      tax = sales_rows.sum { |row| row.post_tax_price.tax }
      [total, tax]
    end

    def keigen_rows
      @sales_rows.select { |row| row.post_tax_price.keigen? }
    end

    def standard_rows
      @sales_rows.reject { |row| row.post_tax_price.keigen? }
    end
  end
end
