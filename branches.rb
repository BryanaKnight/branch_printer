module Branches
  extend self

  def local_branches
    branches = Dir['.git/refs/heads/*']
    branches.each {|b| b.gsub!('.git/refs/heads/', '') }
  end

  def master_branch
    File.read('.git/HEAD').split(" ")[-1].gsub!('refs/heads/', '')
  end

  def remote_branches
    File.open('.git/packed-refs')
  end

  def branch_prefix(local_branch)
    local_branch == master_branch ? "* " : "  "
  end

  def head_pointer
    head_ref = File.read('.git/refs/remotes/origin/HEAD')
    path_after(head_ref, 'origin')
  end

  def head
    path = Dir['.git/refs/remotes/origin/HEAD'].first
    path_after(path)
  end

  def print_local_branches
    local_branches.each { |lb| puts "#{branch_prefix(lb)}#{lb}" }
  end

  def print_remote_branches
    remote_branches.each_line { |line| puts "  #{path_after(line)}" if line.include?('remotes') }
  end

  def print_head
    puts "  #{head} -> #{head_pointer}"
  end

  private

  def path_after(full_path, word='remotes')
    full_path[(/#{word}+(.+)/)]
  end

  print_local_branches
  print_head
  print_remote_branches

end
