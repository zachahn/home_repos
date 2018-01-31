class DigObjectFromCommit
  include ProcParty

  def initialize(repo, commit)
    @repo = repo
    @commit = commit
  end

  def call(path)
    if @repo.empty?
      return
    end

    recurse(path, @commit.tree)
  end

  private

  def recurse(path, object)
    if path.nil? || path == ""
      return object
    end

    current_path_component, rest = path.split("/", 2)

    if object.type == :blob
      return object
    end

    found = object[current_path_component]

    recurse(rest, @repo.lookup(found[:oid]))
  end
end
