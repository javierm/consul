require_dependency Rails.root.join("app", "models", "legislation", "process").to_s

class Legislation::Process
  belongs_to :user, optional: true, inverse_of: :legislation_processes
end
