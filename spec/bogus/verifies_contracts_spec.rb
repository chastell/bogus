require 'spec_helper'

describe Bogus::VerifiesContracts do
  let(:real_interactions) { stub }
  let(:doubled_interactions) { stub }
  let(:verifies_contracts) { isolate(Bogus::VerifiesContracts) }

  let(:matched_interaction) { interaction("matched") }

  it "fails unmatched calls" do
    first_interaction = interaction("first")
    second_interaction = interaction("second")

    stub(doubled_interactions).for_fake(:fake_name){[first_interaction, matched_interaction, second_interaction]}

    stub(real_interactions).recorded?(:fake_name, first_interaction) { false }
    stub(real_interactions).recorded?(:fake_name, second_interaction) { false }
    stub(real_interactions).recorded?(:fake_name, matched_interaction) { true }

    expect_verify_to_raise_error_with_interactions(:fake_name, [first_interaction, second_interaction])
  end

  it "passes with all calls matched" do
    stub(doubled_interactions).for_fake(:fake_name) { [matched_interaction] }
    stub(real_interactions).recorded?(:fake_name, matched_interaction) { true }

    expect {
      verifies_contracts.verify(:fake_name)
    }.not_to raise_error
  end

  def expect_verify_to_raise_error_with_interactions(name, interactions)
    verifies_contracts.verify(name)
    fail
  rescue Bogus::ContractNotFulfilled => contract_error
    contract_error.interactions.should == { name => interactions }
  end

  def interaction(method)
    Bogus::Interaction.new(method, [:foo, :bar]) { "return value" }
  end
end
