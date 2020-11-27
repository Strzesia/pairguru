require "rails_helper"

RSpec.describe ExportJob, type: :job do
  describe ".perform" do
    let(:user) { create(:user) }
    let(:path) { "path/to/file.csv" }

    it "calls MovieExporter" do
      expect_any_instance_of(MovieExporter).to receive(:call)
      ExportJob.perform_now(user, path)
    end
  end
end
