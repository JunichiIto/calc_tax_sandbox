require 'date'

RSpec.describe CalcTaxSandbox::Item do
  describe '#price_with_tax' do
    subject { item.price_with_tax(on: date) }
    let(:date_20190930) { Date.new(2019, 9, 30) }
    let(:date_20191001) { Date.new(2019, 10, 1) }
    context '食品でも新聞でもない場合' do
      let(:item) { CalcTaxSandbox::Item.new('プロを目指す人のためのRuby入門', 2980) }
      context '税率変更前の場合' do
        let(:date) { date_20190930 }
        it { is_expected.to eq CalcTaxSandbox::Price.new(2980, 238, keigen: false) }
      end
      context '税率変更後の場合' do
        let(:date) { date_20191001 }
        it { is_expected.to eq CalcTaxSandbox::Price.new(2980, 298, keigen: false) }
      end
    end
    context '食品だった場合' do
      context '酒類だった場合' do
        let(:item) { CalcTaxSandbox::Food.new('ビール', 300, alcohol: true) }
        context '税率変更前の場合' do
          let(:date) { date_20190930 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(300, 24, keigen: false) }
        end
        context '税率変更後の場合' do
          let(:date) { date_20191001 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(300, 30, keigen: false) }
        end
      end
      context '酒類でなかった場合' do
        let(:item) { CalcTaxSandbox::Food.new('ハンバーガー', 300) }
        context '税率変更前の場合' do
          let(:date) { date_20190930 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(300, 24, keigen: false) }
        end
        context '税率変更後の場合' do
          let(:date) { date_20191001 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(300, 24, keigen: true) }
          context '外食だった場合' do
            subject { item.price_with_tax(on: date, eating_out: true) }
            it { is_expected.to eq CalcTaxSandbox::Price.new(300, 30, keigen: false) }
          end
        end
      end
    end
    context '新聞の定期購読だった場合' do
      context '週1回発行の場合' do
        let(:item) { CalcTaxSandbox::NewspaperSubscription.new('Ruby新聞', 5000, per_week: 1) }
        context '税率変更前の場合' do
          let(:date) { date_20190930 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(5000, 400, keigen: false) }
        end
        context '税率変更後の場合' do
          let(:date) { date_20191001 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(5000, 500, keigen: false) }
        end
      end
      context '週2回発行の場合' do
        let(:item) { CalcTaxSandbox::NewspaperSubscription.new('Ruby新聞', 5000, per_week: 2) }
        context '税率変更前の場合' do
          let(:date) { date_20190930 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(5000, 400, keigen: false) }
        end
        context '税率変更後の場合' do
          let(:date) { date_20191001 }
          it { is_expected.to eq CalcTaxSandbox::Price.new(5000, 400, keigen: true) }
        end
      end
    end
  end
end