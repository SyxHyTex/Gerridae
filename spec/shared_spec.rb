RSpec.shared_examples "shared examples" do |fxn_name, param, value|

  context "when values are returned" do
    let(:method) {fxn_name}
      it { is_expected.to eq value }
  end
end
