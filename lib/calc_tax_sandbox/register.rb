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
        item = row.item
        price_detail = row.price_detail
        total = price_detail.with_tax * row.quantity
        keigen_mark = price_detail.keigen? ? '※' : ''
        rows << "#{item.name}#{keigen_mark} #{row.quantity} #{total}"
      end
      rows << "合計 #{total}"
      rows << ''
      sub_total, tax = keigen_sub_total
      rows << "#{OLD_TAX_RATE}%対象 #{sub_total}"
      rows << "（内消費税額 #{tax}）"
      rows << ''
      sub_total, tax = standard_sub_total
      rows << "#{NEW_TAX_RATE}%対象 #{sub_total}"
      rows << "（内消費税額 #{tax}）"
      rows << ''
      rows << "お預り #{@paid}"
      rows << "お釣 #{change}"
      rows.join("\n")
    end

    private

    def keigen_sub_total
      rows = @sales_rows.select(&:keigen?)
      total = rows.sum { |row| row.price_detail.with_tax }
      tax = rows.sum { |row| row.price_detail.tax }
      [total, tax]
    end

    def standard_sub_total
      rows = @sales_rows.reject(&:keigen?)
      total = rows.sum { |row| row.price_detail.with_tax }
      tax = rows.sum { |row| row.price_detail.tax }
      [total, tax]
    end
  end
end
