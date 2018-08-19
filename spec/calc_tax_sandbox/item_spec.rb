require 'date'

RSpec.describe CalcTaxSandbox::Item do
  describe '#price_with_tax' do
    subject { item.price_with_tax(on: date) }
    context '食品でも新聞でもない場合' do
      let(:item) { CalcTaxSandbox::Item.new('プロを目指す人のためのRuby入門', 2980) }
      context '2019-09-30の場合' do
        let(:date) { Date.new(2019, 9, 30)  }
        context 'その他の商品の場合' do
          it { is_expected.to eq 3218 }
        end
      end
      context '2019-10-01の場合' do
        let(:date) { Date.new(2019, 10, 1)  }
        context 'その他の商品の場合' do
          it { is_expected.to eq 3278 }
        end
      end
    end
  end
end