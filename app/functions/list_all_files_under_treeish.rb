class ListAllFilesUnderTreeish
  include ProcParty

  def initialize(repo)
    @repo = repo
  end

  def call(treeish)
    treeish = resolve_to_tree(treeish)

    all_files_under(treeish)
  end

  private

  def all_files_under(treeish)
    treeish.flat_map do |object|
      if object[:type] == :blob
        object[:name]
      else
        all_files_under(resolve_to_tree(object[:oid])).map do |subfile|
          "#{object[:name]}/#{subfile}"
        end
      end
    end
  end

  def resolve_to_tree(treeish)
    if treeish.is_a?(Rugged::Tree)
      return treeish
    end

    if @repo.branches[treeish]
      return @repo.branches[treeish].target.tree
    end

    @repo.lookup(treeish)
  end
end
