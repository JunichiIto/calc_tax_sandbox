RSpec.describe CalcTaxSandbox::Register do
  example '税率に応じて明細を出し分ける' do
    register = CalcTaxSandbox::Register.new(Date.new(2019, 10, 1))
    item = CalcTaxSandbox::Food.new('ヨーグルト', 100)
    register.add(item, 1)
    item = CalcTaxSandbox::Food.new('カップラーメン', 200)
    register.add(item, 1)
    item = CalcTaxSandbox::Item.new('ペットフード', 500)
    register.add(item, 1)

    expect(register.total).to eq 874
    register.pay(1000)
    expect(register.change).to eq 126

    expected = <<~TEXT.chomp
      2019年10月01日

      ヨーグルト※ 1 108
      カップラーメン※ 1 216
      ペットフード 1 550
      合計 874

      8%対象 324
      （内消費税額 24）

      10%対象 550
      （内消費税額 50）

      お預り 1000
      お釣 126
    TEXT
    expect(register.print_receipt).to eq expected
  end
end