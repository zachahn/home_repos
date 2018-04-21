class ExtractDefaultBranchFromRepo
  include ProcParty

  def call(repo)
    if repo.empty?
      "master"
    else
      repo.head.name[%r{\Arefs/heads/(.*)\z}, 1]
    end
  end
end
