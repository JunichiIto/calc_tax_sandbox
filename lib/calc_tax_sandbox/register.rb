require 'date'

module CalcTaxSandbox
  class Register
    def initialize(current_date = Date.today)
      @current_date = current_date
      @sales_rows = []
    end

    def add(item, quantity)
      price_detail = item.price_detail(on: @current_date)
      @sales_rows << SalesRow.new(item, price_detail, quantity)
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
      rows << print_sub_total(*keigen_sub_total, OLD_TAX_RATE)
      rows << ''
      rows << print_sub_total(*standard_sub_total, NEW_TAX_RATE)
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

    def print_sub_total(sub_total, tax, tax_rate)
      rows = []
      rows << "#{tax_rate}%対象 #{sub_total}"
      rows << "（内消費税額 #{tax}）"
      rows.join("\n")
    end

    def keigen_sub_total
      sub_total(@sales_rows.select(&:keigen?))
    end

    def standard_sub_total
      sub_total(@sales_rows.reject(&:keigen?))
    end

    def sub_total(rows)
      total = rows.sum { |row| row.price_detail.with_tax }
      tax = rows.sum { |row| row.price_detail.tax }
      [total, tax]
    end
  end
end
