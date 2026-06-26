#!/usr/bin/env ruby
require 'minitest/autorun'
require 'json'
require 'tmpdir'
require 'fileutils'

# =============================================================
# Tests for 0-hello_world_function.rb
# =============================================================
require_relative '0-hello_world_function'

class TestHelloWorldFunction < Minitest::Test
  def test_say_hello_outputs_correct_message
    output = capture_io { say_hello("Ruby") }.first
    assert_equal "Hello, Holberton! from Ruby\n", output
  end

  def test_say_hello_with_empty_string
    output = capture_io { say_hello("") }.first
    assert_equal "Hello, Holberton! from \n", output
  end

  def test_say_hello_with_special_characters
    output = capture_io { say_hello("Test@123") }.first
    assert_equal "Hello, Holberton! from Test@123\n", output
  end
end

# =============================================================
# Tests for 1-hello_world_class.rb
# =============================================================
require_relative '1-hello_world_class'

class TestHelloWorldClass < Minitest::Test
  def test_initialize_sets_message
    hw = HelloWorld.new
    assert_instance_of HelloWorld, hw
  end

  def test_print_hello_outputs_message
    hw = HelloWorld.new
    output = capture_io { hw.print_hello }.first
    assert_equal "Hello, World!\n", output
  end
end

# =============================================================
# Tests for 2-prime.rb
# =============================================================
require_relative '2-prime'

class TestPrime < Minitest::Test
  def test_prime_with_2
    assert_equal true, prime(2)
  end

  def test_prime_with_3
    assert_equal true, prime(3)
  end

  def test_prime_with_4
    assert_equal false, prime(4)
  end

  def test_prime_with_1
    assert_equal false, prime(1)
  end

  def test_prime_with_large_prime
    assert_equal true, prime(997)
  end

  def test_prime_with_large_non_prime
    assert_equal false, prime(1000)
  end

  def test_prime_with_negative
    assert_equal false, prime(-7)
  end
end

# =============================================================
# Tests for 5-cipher.rb (CaesarCipher)
# =============================================================
require_relative '5-cipher'

class TestCaesarCipher < Minitest::Test
  def setup
    @cipher = CaesarCipher.new(3)
  end

  def test_encrypt_lowercase
    assert_equal "khoor", @cipher.encrypt("hello")
  end

  def test_encrypt_uppercase
    assert_equal "KHOOR", @cipher.encrypt("HELLO")
  end

  def test_encrypt_mixed_case
    assert_equal "Khoor Zruog", @cipher.encrypt("Hello World")
  end

  def test_encrypt_preserves_non_alpha
    assert_equal "khoor, zruog!", @cipher.encrypt("hello, world!")
  end

  def test_decrypt_lowercase
    assert_equal "hello", @cipher.decrypt("khoor")
  end

  def test_decrypt_uppercase
    assert_equal "HELLO", @cipher.decrypt("KHOOR")
  end

  def test_encrypt_decrypt_roundtrip
    original = "The Quick Brown Fox 123!"
    assert_equal original, @cipher.decrypt(@cipher.encrypt(original))
  end

  def test_encrypt_wraps_around_z
    assert_equal "abc", @cipher.encrypt("xyz")
  end

  def test_decrypt_wraps_around_a
    assert_equal "xyz", @cipher.decrypt("abc")
  end

  def test_shift_of_zero
    cipher = CaesarCipher.new(0)
    assert_equal "hello", cipher.encrypt("hello")
  end

  def test_full_alphabet_shift
    cipher = CaesarCipher.new(26)
    assert_equal "hello", cipher.encrypt("hello")
  end

  def test_large_shift
    cipher = CaesarCipher.new(29)
    assert_equal "khoor", cipher.encrypt("hello")
  end

  def test_empty_string
    assert_equal "", @cipher.encrypt("")
  end

  def test_numbers_and_symbols_unchanged
    assert_equal "123!@#", @cipher.encrypt("123!@#")
  end
end

# =============================================================
# Tests for 3-read_file.rb (count_user_ids)
# =============================================================
require_relative '3-read_file'

class TestCountUserIds < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @tmpdir
  end

  def test_counts_user_ids_correctly
    data = [
      { "userId" => 1, "title" => "a" },
      { "userId" => 1, "title" => "b" },
      { "userId" => 2, "title" => "c" }
    ]
    path = File.join(@tmpdir, "test.json")
    File.write(path, JSON.generate(data))

    output = capture_io { count_user_ids(path) }.first
    assert_includes output, "1: 2"
    assert_includes output, "2: 1"
  end

  def test_empty_array
    path = File.join(@tmpdir, "empty.json")
    File.write(path, "[]")

    output = capture_io { count_user_ids(path) }.first
    assert_equal "", output
  end

  def test_single_user
    data = [{ "userId" => 5, "title" => "x" }]
    path = File.join(@tmpdir, "single.json")
    File.write(path, JSON.generate(data))

    output = capture_io { count_user_ids(path) }.first
    assert_includes output, "5: 1"
  end

  def test_sorted_output
    data = [
      { "userId" => 3, "title" => "a" },
      { "userId" => 1, "title" => "b" },
      { "userId" => 2, "title" => "c" }
    ]
    path = File.join(@tmpdir, "sorted.json")
    File.write(path, JSON.generate(data))

    output = capture_io { count_user_ids(path) }.first
    lines = output.strip.split("\n")
    assert_equal "1: 1", lines[0]
    assert_equal "2: 1", lines[1]
    assert_equal "3: 1", lines[2]
  end
end

# =============================================================
# Tests for 4-write_file.rb (merge_json_files)
# =============================================================
require_relative '4-write_file'

class TestMergeJsonFiles < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @tmpdir
  end

  def test_merges_two_json_arrays
    file1 = File.join(@tmpdir, "file1.json")
    file2 = File.join(@tmpdir, "file2.json")
    File.write(file1, '[{"a": 1}]')
    File.write(file2, '[{"b": 2}]')

    capture_io { merge_json_files(file1, file2) }

    result = JSON.parse(File.read(file2))
    assert_equal 2, result.length
    assert_includes result, { "b" => 2 }
    assert_includes result, { "a" => 1 }
  end

  def test_merge_order_is_file2_then_file1
    file1 = File.join(@tmpdir, "f1.json")
    file2 = File.join(@tmpdir, "f2.json")
    File.write(file1, '[{"from": "file1"}]')
    File.write(file2, '[{"from": "file2"}]')

    capture_io { merge_json_files(file1, file2) }

    result = JSON.parse(File.read(file2))
    assert_equal({ "from" => "file2" }, result[0])
    assert_equal({ "from" => "file1" }, result[1])
  end

  def test_merge_with_empty_file1
    file1 = File.join(@tmpdir, "empty1.json")
    file2 = File.join(@tmpdir, "data2.json")
    File.write(file1, '[]')
    File.write(file2, '[{"x": 1}]')

    capture_io { merge_json_files(file1, file2) }

    result = JSON.parse(File.read(file2))
    assert_equal [{ "x" => 1 }], result
  end

  def test_merge_prints_confirmation
    file1 = File.join(@tmpdir, "a.json")
    file2 = File.join(@tmpdir, "b.json")
    File.write(file1, '[]')
    File.write(file2, '[]')

    output = capture_io { merge_json_files(file1, file2) }.first
    assert_includes output, "Merged JSON written to file.json"
  end
end

# =============================================================
# Tests for 11-cli.rb helper functions (add_task, list_tasks, remove_task)
# =============================================================
# 11-cli.rb runs OptionParser.parse! at load time, so we extract the
# function definitions without executing the CLI argument parsing.

cli_source = File.read(File.join(File.dirname(__FILE__), '11-cli.rb'))
# Extract only the function definitions (up to the OptionParser block)
func_defs = cli_source.split(/^options\s*=/).first
eval(func_defs)

class TestCliTaskFunctions < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @tmpdir
  end

  def test_add_task_creates_file_and_adds_task
    Dir.chdir(@tmpdir) do
      output = capture_io { add_task("Buy groceries") }.first
      assert_includes output, "Task 'Buy groceries' added."
      assert File.exist?("tasks.txt")
      assert_includes File.read("tasks.txt"), "Buy groceries"
    end
  end

  def test_list_tasks_shows_tasks
    Dir.chdir(@tmpdir) do
      File.write("tasks.txt", "Task A\nTask B\n")
      output = capture_io { list_tasks }.first
      assert_includes output, "1. Task A"
      assert_includes output, "2. Task B"
    end
  end

  def test_list_tasks_empty_file_shows_nothing
    Dir.chdir(@tmpdir) do
      File.write("tasks.txt", "")
      output = capture_io { list_tasks }.first
      assert_equal "", output
    end
  end

  def test_remove_task_removes_correct_task
    Dir.chdir(@tmpdir) do
      File.write("tasks.txt", "Task A\nTask B\nTask C\n")
      output = capture_io { remove_task("2") }.first
      assert_includes output, "Task 'Task B' removed."
      remaining = File.read("tasks.txt")
      refute_includes remaining, "Task B"
      assert_includes remaining, "Task A"
      assert_includes remaining, "Task C"
    end
  end

  def test_remove_task_invalid_index_does_nothing
    Dir.chdir(@tmpdir) do
      File.write("tasks.txt", "Task A\n")
      output = capture_io { remove_task("5") }.first
      assert_equal "", output
      assert_includes File.read("tasks.txt"), "Task A"
    end
  end

  def test_add_multiple_tasks
    Dir.chdir(@tmpdir) do
      capture_io { add_task("First") }
      capture_io { add_task("Second") }
      content = File.read("tasks.txt")
      assert_includes content, "First"
      assert_includes content, "Second"
    end
  end
end
