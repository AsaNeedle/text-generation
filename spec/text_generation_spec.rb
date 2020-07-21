require 'text_generation'
require 'listen'

describe TextGeneration do
  describe "#clean_data" do
    generator = TextGeneration.new
    context "given a string" do
      context "given sentence with punctuation" do
        it "removes punctuation" do
          expect(generator.clean_data("What's! love - got to do with it?"))
          .to eq(["whats", "love", "got", "to", "do", "with", "it"])
        end
      end
      context "given uppercase sentence" do
        it "returns lowercase word array" do
          expect(generator.clean_data("HI HOWS IT GOING"))
          .to eq(["hi", "hows", "it", "going"])
        end
      end
      context "given empty string" do
        it "returns empty array" do
          expect(generator.clean_data(""))
          .to eq([])
        end
      end
      context "given one word string" do
        it "returns one word array" do
          expect(generator.clean_data("sup"))
          .to eq(["sup"])
        end
      end
    end
  end
end