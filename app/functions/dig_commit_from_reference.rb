class DigCommitFromReference
  include ProcParty

  def initialize(repo)
    @repo = repo
  end

  def call(reference)
    if @repo.branches[reference]
      @repo.branches[reference].target
    elsif @repo.tags[reference]
      @repo.tags[reference].target
    elsif reference =~ /\A[a-f0-9]\z/
      @repo.lookup(reference)
    end
  end
end
